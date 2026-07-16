Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 330CB30677E;
	Thu, 16 Jul 2026 14:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211126; cv=none; b=E3jcWKrp4lTeKxsn2+WttIiZKxXhLRWUOWekJ88L34f77O4/uD3ifvkpt1hfyuJLuj4MiJs9vfk7HG16mCKk4bVR0fWcbIchIcBHSYeZwEq4fQoh6Ay+t926NgpUbxEnOobSTlULzJDi5H48fViXtS7l+I38sxKYiMM+P9TtDqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211126; c=relaxed/simple;
	bh=KuTTha8Mow8lCR4jnrwljpaiQ93R2otDm6moQJoXVaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NUb6IEyeHaZgqWdh8GBiOU60kOAFbCqqn1Dis6ARw+Stt3T8+Xzr1qkt4WvYHDeo9bTeW2zyb42btGsscjVBHP4urlGbKGmXYjYY0sIlZgaTHYTZAzcvuH/Nq6UGQY5YBB0x46jq0B6KCKJmxZ2+fB48QO67U1tenMtQCDE3Gg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ys/+umss; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ys/+umss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 993451F00A3A;
	Thu, 16 Jul 2026 14:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211125;
	bh=2XQox0973Y6tpaEqERVlspJFGGZD9fLNyCenYIvNovM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ys/+umssiXZqUGSKoub/T9J77POmDnEcIF9XhKFvjVcTvD7LI7HSC8GY6fqUSZcjg
	 PC5I9f7PTYR9cdjeznBKbU8GAPnENjVYmjD1W6e2YgPT7kFid5rpF88rHLzbzjY83x
	 /6N9x0kxB6s5T0x0Cqk9eVIewVDBfU03bnUVKZu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Xu Rao <raoxu@uniontech.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.18 308/480] USB: usb-storage: ene_ub6250: restore media-ready check
Date: Thu, 16 Jul 2026 15:30:55 +0200
Message-ID: <20260716133051.483699372@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


