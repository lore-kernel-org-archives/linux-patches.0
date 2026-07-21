Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6891747044A;
	Tue, 21 Jul 2026 20:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665290; cv=none; b=hqJ55vQIzEy7wbroTKWPcLCQbGZmXyAu+vYedxIDNaFEcckZGM+MX6oiAGNxk3GVj8yM3SSedRM63FF/yzcpP0mdLDa1JIcK43xwyt5t4V5UVp7SY1Fgp9pg/yEktQ+X7DDDOt6OLERwIJ9maMkTEkaAXPLyX9/5nU99fqPnUqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665290; c=relaxed/simple;
	bh=qk5mLyXnq9aN3afpyzyaRBHXxszNwLqfABtOiWXP/Co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PKdEd6bjfycZl8DseheNOlJrKxWDUCSjDRnxxz3HbS2PI+GwnA46FgxrT2o+Ic7qGgLqQm+QKGFElRj+D9eil5jVhRWFtNzX5tneX9kqx+YBSy+QxUKWaoxsOljkWoHsAO7PRJ/MYZr/exfkfrBNHGSZSoBDr50/t8u5oBaTS3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sk9lGwX8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sk9lGwX8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEDC01F000E9;
	Tue, 21 Jul 2026 20:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665289;
	bh=LA9kZ3i+o1jVvqChsf8VrGkXTtULjoXxqf0D41fZyOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sk9lGwX8JcmBs/hPzY4pewi07yl/0pqq7jeRRmjC0CFYK2ENuIn/VI0OOIshGTQrK
	 8MKwGe1X7ONdizo0iRwPkP50GsCp/0ZVZrfBnkpJr5hIDuL3Lqf8zCsPPaP8LLQCrE
	 kCynWoCCeApZ8e1kyl//u7sXSik5R42y5JmVR2yQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Xu Rao <raoxu@uniontech.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.6 0248/1266] USB: usb-storage: ene_ub6250: restore media-ready check
Date: Tue, 21 Jul 2026 17:11:25 +0200
Message-ID: <20260721152447.362901745@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Rao <raoxu@uniontech.com>

commit 5fc3f333c001f1e308bbcdeecdec0d054d24338b upstream.

Commit 1892bf90677a ("USB: usb-storage: Fix use of bitfields for
hardware data in ene_ub6250.c") converted the media status fields from
bitfields to bit masks.

The original ene_transport() test called ene_init() only when neither
media type was ready:

        !(sd_ready || ms_ready)

The converted test became:

        !sd_ready || ms_ready

This is not equivalent. Restore the original semantics by testing that
both ready bits are clear before calling ene_init().

Fixes: 1892bf90677a ("USB: usb-storage: Fix use of bitfields for hardware data in ene_ub6250.c")
Cc: stable <stable@kernel.org>
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/F42641386E32404F+20260626070607.4119527-1-raoxu@uniontech.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/ene_ub6250.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/storage/ene_ub6250.c
+++ b/drivers/usb/storage/ene_ub6250.c
@@ -2306,7 +2306,8 @@ static int ene_transport(struct scsi_cmn
 
 	/*US_DEBUG(usb_stor_show_command(us, srb)); */
 	scsi_set_resid(srb, 0);
-	if (unlikely(!(info->SD_Status & SD_Ready) || (info->MS_Status & MS_Ready)))
+	if (unlikely(!(info->SD_Status & SD_Ready) &&
+		     !(info->MS_Status & MS_Ready)))
 		result = ene_init(us);
 	if (result == USB_STOR_XFER_GOOD) {
 		result = USB_STOR_TRANSPORT_ERROR;


