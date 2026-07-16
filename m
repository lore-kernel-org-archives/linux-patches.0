Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62FCB42A15E;
	Thu, 16 Jul 2026 13:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209803; cv=none; b=sS4ZcM2qz6Wic6bkse/YILujhMZYgpngudiJShADQxrjbf8wf5L7a3cQ8VWAbTJ3HWX2BfBiyhDssuRgv4nmpfIKdsdFL5G0kufwni3O9kZHt/zdStS/rV1vFOWOc3vfsxY+Dlf1Ajd4qoCchNoqw9VNQA6+7n/DPLkKqqLXlfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209803; c=relaxed/simple;
	bh=6bxN9V4q/o5uZZv+g5t3xH6STpkOeoR0L8V4czKNL3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QShjbwznNsR6RyUujgDWNiJ/Z7LAut7abOT4vlTssD1S6Gqvx0hOd3Hb0re7b5kWkgkd7BGsdEpyvfcDL+XxtwE8EnJgGK12Rzw7QAdMJO47aVRj/+/56exnvX8pj43mYozSlqIeXO7aT/n5locLVtg7oMt5Yj9/eWCXj747nWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IZj1+Xdp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IZj1+Xdp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B100F1F00A3A;
	Thu, 16 Jul 2026 13:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209802;
	bh=QoV7YqLZRbaDnyBwPVRupYaEkioOwOTTZWDsbSurWWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IZj1+XdpOBduI5A0neymEy/5fPEYcMFirQvl7chLMdidUwDEG33T8dbMzRpDbQYim
	 1Nli4LopG+3k1Nx+PKZaUifzPzVzVzAOs7EYLzXAtfJE+ReSlo3ztpPruo9jCLHyxq
	 VzVLtl8Bxphp6wm1RCX/LdlxBXo7x+nhUNKxqi7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Xu Rao <raoxu@uniontech.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 7.1 324/518] USB: usb-storage: ene_ub6250: restore media-ready check
Date: Thu, 16 Jul 2026 15:29:52 +0200
Message-ID: <20260716133054.906221127@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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
@@ -2305,7 +2305,8 @@ static int ene_transport(struct scsi_cmn
 
 	/*US_DEBUG(usb_stor_show_command(us, srb)); */
 	scsi_set_resid(srb, 0);
-	if (unlikely(!(info->SD_Status & SD_Ready) || (info->MS_Status & MS_Ready)))
+	if (unlikely(!(info->SD_Status & SD_Ready) &&
+		     !(info->MS_Status & MS_Ready)))
 		result = ene_init(us);
 	if (result == USB_STOR_XFER_GOOD) {
 		result = USB_STOR_TRANSPORT_ERROR;


