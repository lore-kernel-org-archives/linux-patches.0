Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A609A12F59D;
	Tue, 23 Jan 2024 01:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971866; cv=none; b=tbDWa76QITuCaZT4xVcs27bqGOKskShIWjWlAA9mQPFOV5NXZmSRq17unpacAtbqNYDc2sK6ImV5nMVC54cLHgQkUryAtVMa37n4EO4YZL4Z5XZsfVN7qG3U9+x8p8ZP7nf/sYXIiKqV83smAICOVj/pAycEgGg58vinfE6qhME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971866; c=relaxed/simple;
	bh=f0BZp4oN7ev7CVgyYc5KRj3ta6tmZbFBGhteKh13rVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g0z/W14Am4jVSA4VR+raa5tvwS9PkXOjdNphKgEPGIhKegeTvUkafZPrd81cDDHaAbXb+EFBunH6CXyNyMQjWbPSQ2LOI/UwOr26O7ZG0oaX1NKXpZQ9jjUEdOg+hH0CCzle1RDWxcl/zl0mXNBTzCgnOaieD3eUVJZhHssBicw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p+SxS0OM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p+SxS0OM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19CA2C433C7;
	Tue, 23 Jan 2024 01:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971866;
	bh=f0BZp4oN7ev7CVgyYc5KRj3ta6tmZbFBGhteKh13rVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p+SxS0OMpW8SCC2j3Yss6O7sMsI5UE4JucCjdIr8JHLZ4Yimkt0djdDclHvNPjBQV
	 vg+xRd8oqIQ2niDwRGRF0o6tV2Ih5Z0dnhHoyWO10yAzwBj7wz4J35d3rNiIiC3h0x
	 SljWqvMkv8UQR9+FaYMGEShwB3h0btxIWYDGkvZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <2045gemini@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.10 226/286] Bluetooth: Fix atomicity violation in {min,max}_key_size_set
Date: Mon, 22 Jan 2024 15:58:52 -0800
Message-ID: <20240122235740.776998754@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gui-Dong Han <2045gemini@gmail.com>

commit da9065caa594d19b26e1a030fd0cc27bd365d685 upstream.

In min_key_size_set():
    if (val > hdev->le_max_key_size || val < SMP_MIN_ENC_KEY_SIZE)
        return -EINVAL;
    hci_dev_lock(hdev);
    hdev->le_min_key_size = val;
    hci_dev_unlock(hdev);

In max_key_size_set():
    if (val > SMP_MAX_ENC_KEY_SIZE || val < hdev->le_min_key_size)
        return -EINVAL;
    hci_dev_lock(hdev);
    hdev->le_max_key_size = val;
    hci_dev_unlock(hdev);

The atomicity violation occurs due to concurrent execution of set_min and
set_max funcs.Consider a scenario where setmin writes a new, valid 'min'
value, and concurrently, setmax writes a value that is greater than the
old 'min' but smaller than the new 'min'. In this case, setmax might check
against the old 'min' value (before acquiring the lock) but write its
value after the 'min' has been updated by setmin. This leads to a
situation where the 'max' value ends up being smaller than the 'min'
value, which is an inconsistency.

This possible bug is found by an experimental static analysis tool
developed by our team, BassCheck[1]. This tool analyzes the locking APIs
to extract function pairs that can be concurrently executed, and then
analyzes the instructions in the paired functions to identify possible
concurrency bugs including data races and atomicity violations. The above
possible bug is reported when our tool analyzes the source code of
Linux 5.17.

To resolve this issue, it is suggested to encompass the validity checks
within the locked sections in both set_min and set_max funcs. The
modification ensures that the validation of 'val' against the
current min/max values is atomic, thus maintaining the integrity of the
settings. With this patch applied, our tool no longer reports the bug,
with the kernel configuration allyesconfig for x86_64. Due to the lack of
associated hardware, we cannot test the patch in runtime testing, and just
verify it according to the code logic.

[1] https://sites.google.com/view/basscheck/

Fixes: 18f81241b74f ("Bluetooth: Move {min,max}_key_size debugfs ...")
Cc: stable@vger.kernel.org
Signed-off-by: Gui-Dong Han <2045gemini@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_debugfs.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/net/bluetooth/hci_debugfs.c
+++ b/net/bluetooth/hci_debugfs.c
@@ -994,10 +994,12 @@ static int min_key_size_set(void *data,
 {
 	struct hci_dev *hdev = data;
 
-	if (val > hdev->le_max_key_size || val < SMP_MIN_ENC_KEY_SIZE)
+	hci_dev_lock(hdev);
+	if (val > hdev->le_max_key_size || val < SMP_MIN_ENC_KEY_SIZE) {
+		hci_dev_unlock(hdev);
 		return -EINVAL;
+	}
 
-	hci_dev_lock(hdev);
 	hdev->le_min_key_size = val;
 	hci_dev_unlock(hdev);
 
@@ -1022,10 +1024,12 @@ static int max_key_size_set(void *data,
 {
 	struct hci_dev *hdev = data;
 
-	if (val > SMP_MAX_ENC_KEY_SIZE || val < hdev->le_min_key_size)
+	hci_dev_lock(hdev);
+	if (val > SMP_MAX_ENC_KEY_SIZE || val < hdev->le_min_key_size) {
+		hci_dev_unlock(hdev);
 		return -EINVAL;
+	}
 
-	hci_dev_lock(hdev);
 	hdev->le_max_key_size = val;
 	hci_dev_unlock(hdev);
 


