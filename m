Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ABFA367B67;
	Thu, 30 Jul 2026 15:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424550; cv=none; b=JihBnIoOx01/1ZVSbS5gOIa607PM/a1Y0pr/bDWareGB2rviTu6Ua1yEGvyIVWxBQSBWupMNDqlve6i3FXREzNnsAZo/Ac1s7EAiQ2ITbWIp29re2NatuPFOSIGLGcBiwj3I0msj49zwl2Hp91ye2sgTP6qhEX0yTLoSVbRRLRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424550; c=relaxed/simple;
	bh=VsHQW97zsU9BCcRxiU+9NUbmbFtMBM3CKbVEmK6bpbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uU4XJqeVv45rbo8ROdCbNGJh+A7vsIf11/gyhmgeWhtlEBt2GDvpi2zVtM0N+DA0O7UljqiVU/3uDLLK2WO+AgwcrqPe6ydRh0U2pRjVdx8rynHCtAA93moksFHqhSCf+RU6ZH6qPoX287rccEBdjfhiZO2D+9UCeDTUrxtUKB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KQhmhNU1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KQhmhNU1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D70CD1F00A3A;
	Thu, 30 Jul 2026 15:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424549;
	bh=5dZJfBrkJ8kbyz6m0/fgiioZdHj4iDynzAVAXsFyvKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KQhmhNU1uVAY+eyt36jdBD2KUYI+CTR9YFPkuxJ01j3t++Ce/N5waKGfISXrrqFkC
	 wqpSCE/cdF7kMkZ2ydJj9tKSrQ0MAmAZTiVVEhsY+UzDbpghPBLAbBF+6M7hwVt9W6
	 JwXH4x6d/IOnWnev/kl+83IcUtoyo+lsO5DDEXUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Hungyu Lin <dennylin0707@gmail.com>
Subject: [PATCH 6.18 433/675] media: tegra-video: vi: fix invalid u32 return value in format lookup
Date: Thu, 30 Jul 2026 16:12:43 +0200
Message-ID: <20260730141454.343383647@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Hungyu Lin <dennylin0707@gmail.com>

commit d5b50055338e131a1a99f923ebb0361974a00f36 upstream.

tegra_get_format_fourcc_by_idx() returns a u32 but uses -EINVAL to
signal an out-of-bounds index. This results in a large unsigned
value being returned, which may be interpreted as a valid fourcc.

Returning 0 is not a valid fourcc either. This condition should
never happen, so use WARN_ON_ONCE() to catch unexpected out-of-bounds
access and return a valid fallback format instead.

Suggested-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Fixes: 3d8a97eabef0 ("media: tegra-video: Add Tegra210 Video input driver")
Cc: stable@vger.kernel.org
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/tegra-video/vi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/staging/media/tegra-video/vi.c
+++ b/drivers/staging/media/tegra-video/vi.c
@@ -80,8 +80,8 @@ static int tegra_get_format_idx_by_code(
 static u32 tegra_get_format_fourcc_by_idx(struct tegra_vi *vi,
 					  unsigned int index)
 {
-	if (index >= vi->soc->nformats)
-		return -EINVAL;
+	if (WARN_ON_ONCE(index >= vi->soc->nformats))
+		return vi->soc->video_formats[0].fourcc;
 
 	return vi->soc->video_formats[index].fourcc;
 }


