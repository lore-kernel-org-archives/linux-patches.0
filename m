Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 158B71F92C;
	Mon,  4 Mar 2024 21:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587623; cv=none; b=rwHc9FQpEp2QIx0FiJHkvQNh6B+gM3VYxflKYJwW3tr2nEbqMeCof4k0SdA8CF9503fFRJTViC2P6GGsKmVEuFi0q6B4+kO3M4Y5qA1XcnCMqgzLvxcjH8NSMY71G5i3k+aROExver6xUVRRjqy52c+NpQiU/vPD38v9C92w5Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587623; c=relaxed/simple;
	bh=cAmTemXLgoGYQEjXU5H2GBUOLz3xYy0MZNdrYpJvWpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d0wSHa/6+axZUYvi4FzqALUY4ujdNLa9qI4/uOs65krNTB+HXpAsgiG9znkMCZ9hh3vvHrGrpk1e1643yPSi+hyqSxBURqBrs/TqI8p3XaM9eux3XqJfn8zs6RVo0j8pNXA4pbkTryF82ahXaVrxCVrfHleaGYEkdR/5eHUzO4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UKm3TNP5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UKm3TNP5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D487C433C7;
	Mon,  4 Mar 2024 21:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587623;
	bh=cAmTemXLgoGYQEjXU5H2GBUOLz3xYy0MZNdrYpJvWpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UKm3TNP5w76xry3zv/fKNGvfcRZ+a+QlLFZLckSBgtR8gUPX7/krwnLE1XipW6Tdo
	 CudGsaLr158IDANGXAOKku4TuqVm8sLaEAOHRXc6kzjbe45juLmK/QegdeW/uLqeop
	 N21X/z80QbiFuFTSvA/JKzRZxcem9GJ6H2uo5JqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Clancy Shang <clancy.shang@quectel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 027/162] Bluetooth: hci_sync: Fix accept_list when attempting to suspend
Date: Mon,  4 Mar 2024 21:21:32 +0000
Message-ID: <20240304211552.702178520@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit e5469adb2a7e930d96813316592302d9f8f1df4e ]

During suspend, only wakeable devices can be in acceptlist, so if the
device was previously added it needs to be removed otherwise the device
can end up waking up the system prematurely.

Fixes: 3b42055388c3 ("Bluetooth: hci_sync: Fix attempting to suspend with unfiltered passive scan")
Signed-off-by: Clancy Shang <clancy.shang@quectel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 39ccbb1be24c3..b90ee68bba1d6 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -2274,8 +2274,11 @@ static int hci_le_add_accept_list_sync(struct hci_dev *hdev,
 
 	/* During suspend, only wakeable devices can be in acceptlist */
 	if (hdev->suspended &&
-	    !(params->flags & HCI_CONN_FLAG_REMOTE_WAKEUP))
+	    !(params->flags & HCI_CONN_FLAG_REMOTE_WAKEUP)) {
+		hci_le_del_accept_list_sync(hdev, &params->addr,
+					    params->addr_type);
 		return 0;
+	}
 
 	/* Select filter policy to accept all advertising */
 	if (*num_entries >= hdev->le_accept_list_size)
-- 
2.43.0



