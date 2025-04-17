Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCFF41DE3A8;
	Thu, 17 Apr 2025 18:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913077; cv=none; b=GkSt76Z6W85RoJlQk5kz/PHPfRPBIla+m07boXDfeRyzLGGGCaRHJZ91klga6e4SvjdFTzKycJMk28VNzaEKShYpNYVLgEEIGqPZP+12SSYbFPLhdyY9axJh9dgoHDquGPL1/5nxroyQ5hhHHCuu5wKesq2IOLRL9pC1yOmhwH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913077; c=relaxed/simple;
	bh=vrSo6axG+StzuQxNRIccw2NbiDcIonr1WJuT1P76uNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D9XvO3NeBYsC/cW0Z3Bkj648anrs3LgM4iXPmaoilp7LQkjsevJVaFuk4z/3cg/GYDvrGT8GDwnXaQ55HX2Jr1YPFh2/qstl/DE+UjaWU9PeDTtAj5c5P+t1oIwtoWAYgBh/E3xZrbKWHkn7BO8Lq8JrPVrzG54GxH9mau7kPCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dg+JKk7r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dg+JKk7r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC276C4CEE7;
	Thu, 17 Apr 2025 18:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913077;
	bh=vrSo6axG+StzuQxNRIccw2NbiDcIonr1WJuT1P76uNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dg+JKk7r7qFoUz3frQp9NwQAas3tUyenRYHTIRbgUugtcc17vQ6fszQsftgF5XCWY
	 DM8lXxL5UnHtenlAepfcyJAvkR1i5Riw1S63PGq3/T7/omHsssI96d+WGJHLCbzNcf
	 o5OBu5SYVaL/iPZE/m5CjxgOfTJjpXomxtDAQL9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.14 219/449] media: mediatek: vcodec: Fix a resource leak related to the scp device in FW initialization
Date: Thu, 17 Apr 2025 19:48:27 +0200
Message-ID: <20250417175126.785873661@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiasheng Jiang <jiashengjiangcool@gmail.com>

commit 4936cd5817af35d23e4d283f48fa59a18ef481e4 upstream.

On Mediatek devices with a system companion processor (SCP) the mtk_scp
structure has to be removed explicitly to avoid a resource leak.
Free the structure in case the allocation of the firmware structure fails
during the firmware initialization.

Fixes: 53dbe0850444 ("media: mtk-vcodec: potential null pointer deference in SCP")
Cc: stable@vger.kernel.org
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/mediatek/vcodec/common/mtk_vcodec_fw_scp.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/media/platform/mediatek/vcodec/common/mtk_vcodec_fw_scp.c
+++ b/drivers/media/platform/mediatek/vcodec/common/mtk_vcodec_fw_scp.c
@@ -79,8 +79,11 @@ struct mtk_vcodec_fw *mtk_vcodec_fw_scp_
 	}
 
 	fw = devm_kzalloc(&plat_dev->dev, sizeof(*fw), GFP_KERNEL);
-	if (!fw)
+	if (!fw) {
+		scp_put(scp);
 		return ERR_PTR(-ENOMEM);
+	}
+
 	fw->type = SCP;
 	fw->ops = &mtk_vcodec_rproc_msg;
 	fw->scp = scp;


