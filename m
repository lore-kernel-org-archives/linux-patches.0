Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03F294BAA12;
	Mon, 31 Aug 2026 14:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184930; cv=none; b=amWo9aGmLr/GGkKPFTJ8YNHzjJwbbGFOeCvxdSxytun69cLZCwism0028uCHtzMahOPNrVAOjZecTLKNF5KvD5eMES51gitwFnLweP7hCGU7PpKYBex8LQWyV8C7OviojPS1qS9l8cxR3pJpAH3ApscZ6IcYWbXZtVg2tHgaI7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184930; c=relaxed/simple;
	bh=pi25EwUHEznkCBFpHWWmoOQDhyl3icyQn6thCwV7XTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F76VEMJK3x5iE9JG1Pa0Lt8GdMxv90TWxo7asl3LoWp3vtC3jsQ1ku5nNusp3LYgC+ndS/En3FakPfyarUGmxphmrilJPmirX0y4XVMfsgIYADukItHJcy8s45SRKJZYl1/0N7zmaGXGPtde0bbm9Qxvql6A6XQp2xnv7vGfNvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vJZxzlaq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vJZxzlaq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CC801F00ACA;
	Mon, 31 Aug 2026 14:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184927;
	bh=UbVJ6MGIxYQDTyREPKTx0QseD4dQLmIB2RDN0FVz5uA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vJZxzlaqzebZXUYoBbox9iIwIMMYFcEJ13K7WTxNm4GrJgsoY2GRC2Fv8O656nlVq
	 MFaJxrP3Ebv/QNrCiGYb+4McFdctYxPflDuziq7UYa65RV6G7fCozB7JX9DMJDIi7w
	 04NTxVNqIQpYF2+DPFs2FaoUHfqerCc9BFiaXTBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Griffin Kroah-Hartman <griffin@kroah.com>
Subject: [PATCH 6.1 86/92] usb: core: Strengthen error handling in hub_hub_status()
Date: Mon, 31 Aug 2026 15:35:24 +0200
Message-ID: <20260831133403.931134156@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.482388899@linuxfoundation.org>
References: <20260831133359.482388899@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Griffin Kroah-Hartman <griffin@kroah.com>

commit a29496745aa335d97f617385809583241e118610 upstream.

Add additional error handling after the call to get_hub_status() in
hub_hub_status().

get_hub_status() uses usb_control_msg() which does not verify that the
message is the correct length, substituting it for
usb_control_msg_recv() would also solve this issue but increase memory
allocations.

Instead, error handling is copied from the method used in
hub_ext_port_status(), which shares the same flow of logic as
hub_hub_status().

Assisted-by: gkh_clanker_t1000
Signed-off-by: Griffin Kroah-Hartman <griffin@kroah.com>
Link: https://patch.msgid.link/20260722-usb_core_patches_2-v3-1-87622252bfdd@kroah.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hub.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -968,10 +968,12 @@ static int hub_hub_status(struct usb_hub
 
 	mutex_lock(&hub->status_mutex);
 	ret = get_hub_status(hub->hdev, &hub->status->hub);
-	if (ret < 0) {
+	if (ret < (int)sizeof(hub->status->hub)) {
 		if (ret != -ENODEV)
 			dev_err(hub->intfdev,
 				"%s failed (err = %d)\n", __func__, ret);
+		if (ret >= 0)
+			ret = -EIO;
 	} else {
 		*status = le16_to_cpu(hub->status->hub.wHubStatus);
 		*change = le16_to_cpu(hub->status->hub.wHubChange);


