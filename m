Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D584B66F7;
	Mon, 31 Aug 2026 13:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184398; cv=none; b=IB4cU1F+rRdhYMS+1FXSqw4WEuGH8MEjnEkSPefUw1/FDn27RUMC1IgDT7JdclMvyv0d0xiTkFr+1AWzz9P3rt5xlwn0mO5Mh5/JNUW0VeJf/h2PWD96Q0c6+EF/1P8VY3e3RND1C03bViCg7EjUfIX5reHUTv53GcCiUcsRl4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184398; c=relaxed/simple;
	bh=zV3qjFTXOM0UjiHALh7GcbEWtx8ePi0f4lx1SWaEDmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a670rsB2yTaPOL65pqUrdF7+LsMm1XuZwdYcrJISwKhG1+EBSDgVOGMMVEK72JwSH8hIymeyzSE30NIj2/GQL0NnjrybZBa/CfXUXpA1AtyGlhLUIIjZ7Rdq/n4CTVvcjoAtAOc7UH7VhgB4Hs0LA6co8iapcMxjMdO74o86/4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0M3Czr4Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0M3Czr4Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B85F1F000E9;
	Mon, 31 Aug 2026 13:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184397;
	bh=ZwXtZTArcLCRSGfIHZIhpikG4nazY+ZSw/MrmzDg9RU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0M3Czr4Zoif/93k84H01m7sA07LaHOie9pg639Ow6m4p73N8o+gBDN2QdNPLMT7rZ
	 bIivz+fRgDMO/K05CIYyzURVBJS4U6bLUpGwDrmqaSGDaU/v9x3r1E5+QU4VzLrxNI
	 fNwujDws4XC2keM94ngmdD2RIZ5Dev7OPra2oTIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Griffin Kroah-Hartman <griffin@kroah.com>
Subject: [PATCH 6.12 92/99] usb: core: Strengthen error handling in hub_hub_status()
Date: Mon, 31 Aug 2026 15:35:01 +0200
Message-ID: <20260831133404.340742611@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.740409777@linuxfoundation.org>
References: <20260831133359.740409777@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -997,10 +997,12 @@ static int hub_hub_status(struct usb_hub
 
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


