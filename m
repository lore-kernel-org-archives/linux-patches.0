Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFE9A442FC1;
	Tue, 21 Jul 2026 21:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671181; cv=none; b=LSaDlr7rcFdgpiFQHjIcGcAsCbwWeO7G/31HFjLCJOtNX9VmLlSckjgV9/qyOgO0TA7dpbD2EWDgMihii7gHJd1SkfOu+ghYqINDJlF3U/Q6MDHucSJg6yaEZ/5mdUtvM1ryhoxAceOr8y+OBQ3zKL3HAR+m1GcV1Tfm7WnfLoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671181; c=relaxed/simple;
	bh=F6nQ20TQQVHaLYI9bEEBAW3emO+OQ/YIJmJ+FpU9DBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eim+pw8+SOBHoxgOK0QdgTokqL04UmOxIa8Q0KUMF8htxuZsvTj2ggohpeLYfkqMUSmxj28jvEsetnAeZKg+liI0/HQQ+3FO43TlKon4Wjaubkwzh/dIDZayIaXoZDQ/qQzC0xN8vYJ+FceeO4CV4NhBXUfcZmY4s/MR4yUrGew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ja6etyUE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ja6etyUE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D56841F000E9;
	Tue, 21 Jul 2026 21:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671180;
	bh=6DSxeVtg0NKrzbvKMnjV7eNjcZrZlrvQUqI5x6qGHN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ja6etyUE+22QkzNJaDZlSUfLJFhF0AYp9a+2QSslYRY9ideKXdPKRW1w3zgzQ9ckc
	 E6KYJXC28KcHK+Tt4WN+xcpQmUDDBhW+buheesIDv35V58kMxWOKBeN1V0JytY0+Ga
	 FhCMR7xmRHCJUhCSTMFGlVmXwUbqAdbG5NmURliw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Xu Rao <raoxu@uniontech.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5.15 149/843] USB: usb-storage: ene_ub6250: restore media-ready check
Date: Tue, 21 Jul 2026 17:16:24 +0200
Message-ID: <20260721152409.364069456@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


