Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B552472A2;
	Mon, 23 Jun 2025 13:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686205; cv=none; b=qs6kIoafkoRvTpLltJZeFL/8M5yFk+FvFLE41wVz+zJtzDU98gqJFKC4V4IbcKc9fEwqTAV/0LP9dNKU7+dw03x3yAL0rkxZp2qcH7DxFzcFdlpw3YFMAN5fixFinpjddv0CIGFDlyX3X5463UO97No7ySBptmx6ndwlWWopG5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686205; c=relaxed/simple;
	bh=5GnFsoZ6zKVOvEvInc74nLiYMhEg5mgixQ4GyWMEMDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h+9C+22EI/OyW41eaLLjQXe9RWodDSJCH7knFXNSv4OvmZYh9j0vQNTS8TE/YhJBgXy5SLyB1pN5OE06lWAe6UF59UownE6RIJxeVXKvIa1hofZi7YIHJoY8lNSLwiAmrHzkdcv/2MaycKdrzU6wsQGtD1eRZT37CU8q/YgpZp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PVRsgEMh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PVRsgEMh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11318C4CEEA;
	Mon, 23 Jun 2025 13:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750686205;
	bh=5GnFsoZ6zKVOvEvInc74nLiYMhEg5mgixQ4GyWMEMDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PVRsgEMhc07qnf7OCxpm0aDYQ9dCpD6lNh72PCfmIwUA+ttCF1avdfWpYnF5Vdj6w
	 N2FhwPqIjlhDSCDaqeEtlAiBcaEGFcwG2XlgBq2HUcaEgcFJG2k5MM1EclmJ+1JcTd
	 VS45bEcK77++o6y446tDu86QI8ogHm929PLRgVpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nas Chung <nas.chung@chipsnmedia.com>,
	Sebastian Fricke <sebastian.fricke@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 309/592] media: qcom: venus: Fix uninitialized variable warning
Date: Mon, 23 Jun 2025 15:04:27 +0200
Message-ID: <20250623130707.759875648@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nas Chung <nas.chung@chipsnmedia.com>

[ Upstream commit 8e172e38a623ce284baf2514f963b29e4d47c62e ]

Avoid uninitialized variable when both V4L2_TYPE_IS_OUTPUT() and
V4L2_TYPE_IS_CAPTURE() return false.

Signed-off-by: Nas Chung <nas.chung@chipsnmedia.com>
Signed-off-by: Sebastian Fricke <sebastian.fricke@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/vdec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
index 9f82882b77bcc..39d0556d7237d 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -154,14 +154,14 @@ find_format_by_index(struct venus_inst *inst, unsigned int index, u32 type)
 		return NULL;
 
 	for (i = 0; i < size; i++) {
-		bool valid;
+		bool valid = false;
 
 		if (fmt[i].type != type)
 			continue;
 
 		if (V4L2_TYPE_IS_OUTPUT(type)) {
 			valid = venus_helper_check_codec(inst, fmt[i].pixfmt);
-		} else if (V4L2_TYPE_IS_CAPTURE(type)) {
+		} else {
 			valid = venus_helper_check_format(inst, fmt[i].pixfmt);
 
 			if (fmt[i].pixfmt == V4L2_PIX_FMT_QC10C &&
-- 
2.39.5



