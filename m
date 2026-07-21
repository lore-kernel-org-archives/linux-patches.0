Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411A33C8716;
	Tue, 21 Jul 2026 21:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668474; cv=none; b=gS1fU2A44qGf0/R78bd2K/w7L3498Skox/UiFie/dqGGe/n3POIJMjcnfffXpucIx25Ir6aJDVpAOo4upxhuZGWoiIEAm4MhQaoAyw9rDm8HYahin3ncBhhVLPF5rzsalh9b6dWYliJzgMWchL5LA5DSx0k8fkwTMsC4jAB77zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668474; c=relaxed/simple;
	bh=IifNg57dsNau+SfVCfF4xL3/wfLWINO51hXQ6HfiyDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lAtWDS0QlcoBFT3FRJW/lMVG0uzYE+YWETOmDodSHQjHZJD4vKAwDoSUEO11jOdYkTMI1uc+JLEFIWZ6rsI5bE/MQAvvfiUC1qrFYzRsMR4aqRGX3vEeJi9ul2T9f5O19MRls3wFzteMrWStkRttmkgXjAG9jv4/mVRGKM/Bd3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ClX5Mb8j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ClX5Mb8j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A77801F00A3A;
	Tue, 21 Jul 2026 21:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668473;
	bh=52uXBBekyYdaijVt4I2L8r9CXL2+ixnbZ0TV+to0MPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ClX5Mb8jWkoVqwItKYqiQbSoVCJxHVFCr7siQ81Igy4k4Wp9arIC/OQJ6xDIfVwo1
	 Yr8P0EKI87OVAXMmpveH0IjnKouC63j2LJph3XE+UCHhPY84DP7Y12E0WAYzUMLr2B
	 faujw2f/WfazV/q2vpZWgfD+4bdsMZbR6880V4HQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Xu Rao <raoxu@uniontech.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.1 0187/1067] USB: usb-storage: ene_ub6250: restore media-ready check
Date: Tue, 21 Jul 2026 17:13:08 +0200
Message-ID: <20260721152428.778440177@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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


