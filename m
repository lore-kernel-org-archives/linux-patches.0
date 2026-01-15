Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75D63C1FC3;
	Thu, 15 Jan 2026 17:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499842; cv=none; b=LRPXJEAw1hLlL9SwuXQa3wkmv26Otz/CqK0JFSvtxtYRb1db5MILi2yvUGosC6DBPOuVe/5eAGB0I5KIVtu3l5WIkqm7IDLVi1rqxhdjMIB1SOnRufTFegs3dMggyjQHCc8Lwru2Go53PEXt6BuiPdPvbOCwnnMjpd3ULfmBsPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499842; c=relaxed/simple;
	bh=Bg732lv/b/7WOANzngCYpxh17lQLTfcuQC+50oIc6/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gVl+h8tGYuNFdYwpIFRiLSfJbMwL/+ARvdrMj9flkK7iFECYFxoRQblAV+xWBIpfJKshUg6AJWnv5b5HnD3UAPZzCsTJ0KZ2CpVCPu/U1k1kk5RtgArtimhpfSlpcC8xHcR1jBVJ1mQjNdrzbMnuOy0qNOKSBV0WSwE7KXlGg0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ctFISuTQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ctFISuTQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 512D8C116D0;
	Thu, 15 Jan 2026 17:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499842;
	bh=Bg732lv/b/7WOANzngCYpxh17lQLTfcuQC+50oIc6/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ctFISuTQgR2BQdBInPPM9Zyn9gNUTE/msnp4E+Az+Tc5gQUeP2jv+TsMqA1Z/Mff+
	 Fn7wpd9gLBcLy0PaTLlF1ugMuEpaEviuYYUhBLgwrqkg3lmqOWz2Oswnpp+/naT+zM
	 eYotURppl4Hwn9Duh0Mt+/WMf5lrULKFdBHOBqoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Vetter <daniel@ffwll.ch>,
	Peilin Ye <yepeilin.cs@gmail.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 341/451] console: Delete dummy con_font_set() and con_font_default() callback implementations
Date: Thu, 15 Jan 2026 17:49:02 +0100
Message-ID: <20260115164243.229839799@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

From: Peilin Ye <yepeilin.cs@gmail.com>

commit 259a252c1f4e19045b06660f81014fb51e17f3f6 upstream.

.con_font_set and .con_font_default callbacks should not pass `struct
console_font *` as a parameter, since `struct console_font` is a UAPI
structure.

We are trying to let them use our new kernel font descriptor, `struct
font_desc` instead. To make that work slightly easier, first delete all of
their no-op implementations used by dummy consoles.

This will make KD_FONT_OP_SET and KD_FONT_OP_SET_DEFAULT ioctl() requests
on dummy consoles start to fail and return `-ENOSYS`, which is intended,
since no user should ever expect such operations to succeed on dummy
consoles.

Suggested-by: Daniel Vetter <daniel@ffwll.ch>
Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/9952c7538d2a32bb1a82af323be482e7afb3dedf.1605169912.git.yepeilin.cs@gmail.com
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/sisusbvga/sisusb_con.c |   15 ---------------
 drivers/video/console/dummycon.c        |   14 --------------
 2 files changed, 29 deletions(-)

--- a/drivers/usb/misc/sisusbvga/sisusb_con.c
+++ b/drivers/usb/misc/sisusbvga/sisusb_con.c
@@ -1345,19 +1345,6 @@ static int sisusbdummycon_blank(struct v
 	return 0;
 }
 
-static int sisusbdummycon_font_set(struct vc_data *vc,
-				   struct console_font *font,
-				   unsigned int flags)
-{
-	return 0;
-}
-
-static int sisusbdummycon_font_default(struct vc_data *vc,
-				       struct console_font *font, char *name)
-{
-	return 0;
-}
-
 static const struct consw sisusb_dummy_con = {
 	.owner =		THIS_MODULE,
 	.con_startup =		sisusbdummycon_startup,
@@ -1370,8 +1357,6 @@ static const struct consw sisusb_dummy_c
 	.con_scroll =		sisusbdummycon_scroll,
 	.con_switch =		sisusbdummycon_switch,
 	.con_blank =		sisusbdummycon_blank,
-	.con_font_set =		sisusbdummycon_font_set,
-	.con_font_default =	sisusbdummycon_font_default,
 };
 
 int
--- a/drivers/video/console/dummycon.c
+++ b/drivers/video/console/dummycon.c
@@ -124,18 +124,6 @@ static int dummycon_switch(struct vc_dat
 	return 0;
 }
 
-static int dummycon_font_set(struct vc_data *vc, struct console_font *font,
-			     unsigned int flags)
-{
-	return 0;
-}
-
-static int dummycon_font_default(struct vc_data *vc,
-				 struct console_font *font, char *name)
-{
-	return 0;
-}
-
 /*
  *  The console `switch' structure for the dummy console
  *
@@ -154,7 +142,5 @@ const struct consw dummy_con = {
 	.con_scroll =	dummycon_scroll,
 	.con_switch =	dummycon_switch,
 	.con_blank =	dummycon_blank,
-	.con_font_set =	dummycon_font_set,
-	.con_font_default =	dummycon_font_default,
 };
 EXPORT_SYMBOL_GPL(dummy_con);


