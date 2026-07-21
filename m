Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9CDF46C4D9;
	Tue, 21 Jul 2026 16:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649733; cv=none; b=ZCbl25fcLSgXQylv8yxpWp22BQEBn2zLSODed8ZX/SIUG6vI69Y5sjEaMM2wkWk8d8ruDiDZ06c8cWvFajDpwMWGoA1jgIyG+aaGLuSfSN6WDJuNTbS4m8AVLG7Pbn6ncWzN+I9xxjcxaAEISsFfrNZS1jWzHiWsCBApHPkwukA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649733; c=relaxed/simple;
	bh=J41xeem3HYMGZrY5FtypFZKH7O2rnj4E29M+mFh5zsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ONUGme12C2HZswRxPwXx4zE6aNuTtD4JO7N7DoxMZntpkXIoYcmrMQ11mYLdXaPwQXLWqwwiFr42qrKX0U74MeZRA8Rsx1Kd6q5UV4j4DxsHMcKppOYywz9ukkIMgw+Jh4L7LjdKV8zDyYLE/viVdhKmSQwgpA4e90lyxiGizMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QvOhMoIC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QvOhMoIC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A2B1F000E9;
	Tue, 21 Jul 2026 16:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649731;
	bh=16JS23yVqgZ5O5zTFPb5NucrES8NyZYvLEAeR1ATDRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QvOhMoICbeLib23zgnIB3kiopxy2Rmuk8RgXQ659Ru23Y2OpbuVfaux25F7OZ50dV
	 cYu251vYe+tI7b4U5ET1BFuQ2iZWR/qoNcZhS/SQqhzBldDK0RNwkIPSTeL9J0olsm
	 Yl/UvzgB3OdRdnyc6IwNrUV9Zqhge4cL3JxA1Wrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Moelius <sam.moelius@trailofbits.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0685/2077] Bluetooth: vhci: validate devcoredump state before side effects
Date: Tue, 21 Jul 2026 17:05:58 +0200
Message-ID: <20260721152608.952895183@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Moelius <sam.moelius@trailofbits.com>

[ Upstream commit 88c2404a3c59c3126453919388dbd5ed98ed01bd ]

The VHCI force_devcoredump debugfs hook accepts a small test record from
userspace. It validates the requested terminal state only after
registering, initializing and appending a Bluetooth devcoredump.

As a result, an invalid state returns -EINVAL but still leaves queued
devcoredump work behind. With a non-zero timeout field, the rejected
write can still emit a devcoredump after the timeout expires.

Reject unsupported states before allocating the skb or changing the HCI
devcoredump state machine.

Fixes: ab4e4380d4e1 ("Bluetooth: Add vhci devcoredump support")
Assisted-by: Codex:gpt-5.5-cyber-preview
Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_vhci.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/bluetooth/hci_vhci.c b/drivers/bluetooth/hci_vhci.c
index 2762eacf7f20ed..eddb32b30539ff 100644
--- a/drivers/bluetooth/hci_vhci.c
+++ b/drivers/bluetooth/hci_vhci.c
@@ -337,7 +337,17 @@ static ssize_t force_devcd_write(struct file *file, const char __user *user_buf,
 	if (copy_from_user(&dump_data, user_buf, count))
 		return -EFAULT;
 
+	switch (dump_data.state) {
+	case HCI_DEVCOREDUMP_DONE:
+	case HCI_DEVCOREDUMP_ABORT:
+	case HCI_DEVCOREDUMP_TIMEOUT:
+		break;
+	default:
+		return -EINVAL;
+	}
+
 	data_size = count - offsetof(struct devcoredump_test_data, data);
+
 	skb = alloc_skb(data_size, GFP_ATOMIC);
 	if (!skb)
 		return -ENOMEM;
-- 
2.53.0



