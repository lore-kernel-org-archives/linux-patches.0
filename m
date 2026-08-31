Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6902D499F1C;
	Mon, 31 Aug 2026 14:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788185278; cv=none; b=cK3Y2NQKdjhMRi0nsWcaAQ2IAklt2KHK5NltbmlMgn6UsXWKAiUR7IDDHEOxosYKhGEPeWxS2/DFRDrv3S0dMBc6YaVJYOiHP88ebvTlnQBrLq6pt+8ClmPIF6tKpq1kuVV0POfhqlQSUItsZObulqtKM80U7TpatOKOY4BA1S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788185278; c=relaxed/simple;
	bh=EfAud/6/T7QUOzHbAUZpgJCl3u8u3xno1SBGt6hS/hE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FBiIJgkCdmaYES7zZ9VGKhHKP5JigjtjkiexD7he2Ksg4y/KdvJV11PMtiNv8EG0YD9LBbpB9qIZh+n3F1LRMFV1sAShYRWViFvKa9//C3Uwm3UF6/3rquerqhnkNdKLijYyDpiKkN1pud74nJo7HNjJQgi5cHX9sTW4khbOQ+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EzPc9hlK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EzPc9hlK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C36531F000E9;
	Mon, 31 Aug 2026 14:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788185277;
	bh=9CkguLUlTvE1AvFdLBOxAsB7E+oU5SPFpY3DRr3uM7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EzPc9hlKdrqYlAlRQASFgiNPjymO65EOWrl9DYSEQUS2r3Pz8ohM9OyR/BuoOWFAl
	 /VIHuw6XXkpQ+VbX44OOpu3W5DuYPFJP/0TxFyrmX/yiXUVC205XjhoNzRZ/dpt2+E
	 VYXtaExAnlbYa/2872wGbzjvCVmPrEeUW8LeJIiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Griffin Kroah-Hartman <griffin@kroah.com>
Subject: [PATCH 5.10 38/43] usb: core: Strengthen error handling in hub_hub_status()
Date: Mon, 31 Aug 2026 15:35:46 +0200
Message-ID: <20260831133400.482777387@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133358.571886287@linuxfoundation.org>
References: <20260831133358.571886287@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -955,10 +955,12 @@ static int hub_hub_status(struct usb_hub
 
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


