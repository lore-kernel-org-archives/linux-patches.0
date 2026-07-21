Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7343434B1A6;
	Tue, 21 Jul 2026 22:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673310; cv=none; b=q6htE8r3LBIa4f/DPMrrjHpeC0A9TzvG7aPxIv3SXb/RqsHSin6a8DbSIB4bDPR7NCAdiRSDhdQnJDQB9OH5NV9B8My8JNG3EscRDhx9HldAW4CxHzM6FNyGWR0v9wIbIlKbFs4Zu+iWF72e1Oh8ev9o1XKnoCdk/3QULLV7FqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673310; c=relaxed/simple;
	bh=MizEuuU7WVKvRTUjACk1FKUNslOLSt6b3/FvTf5csgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AUzuTxSsLBINSlFsoWXesuYtkqYLxq3oj4YauuUkw7JW1QgyG2unzVxSjcscKMiY3KhqrdhJu7SB4OBKa6xYCzctrBE4abV2AdrHu3FxQ3Ib3FV0mfbCj/dkrVgKIWJbQYgUtJgPnZLdUKQd4plh/yq3mdKKUyh5kul92HFtITA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ma/ZxG80; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ma/ZxG80"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3C751F000E9;
	Tue, 21 Jul 2026 22:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673309;
	bh=75TvYnKGLHKi8ndtZ710/R6V5S4yUYujElDANddJFDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ma/ZxG80GQTRqS2POs6RPRlp97Qlkr1tUQxYuqkvougRrS1EFlu2NR+RrPltGy7+a
	 p9VW+1xYNXwq7vWx+D9RPcpEGSkmyj/1RjjHdjU+oxYPKicZeaPpA5nPqVpEqDS7wf
	 tJ305x82ZbA4kK7iB3Itbnadr8xm0/31FSNmxlm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Xu Rao <raoxu@uniontech.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5.10 113/699] USB: usb-storage: ene_ub6250: restore media-ready check
Date: Tue, 21 Jul 2026 17:17:52 +0200
Message-ID: <20260721152358.252561287@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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


