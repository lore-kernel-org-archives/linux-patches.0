Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00885426EC0;
	Tue, 31 Mar 2026 16:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975273; cv=none; b=UPb6eiqffu6/DhLml+13Q7yEXH2j5qmF1a2gZtg/8upNLXsM159wpm0r2ZZoJHvCZgDEvcnBjY7E6ZlFNCMuHMvn/6UAMy+7lQpC+56eiBsHGS2o11GBP0GLlflP3/Sc68sKp5WQsUma5sOQ0J9Kiy+c3/EMXflvnhP6h4vFUDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975273; c=relaxed/simple;
	bh=KWMsdIXKI6PIfFCWYWJ+DYpn7wQxxRijzydoYqGJcmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Psw5XDGJeu4GPkgc0JQjCufwm74bLm7vHHGSQZvJTFptTtt5k/D3UoLxxxoJCzHctzEP6Nqh+XNw58ZZJQxE6RP1L5m43fB7eoh35Z02qV2qne+PWtly5wYQmHW68w8AErzYSPomhsJ5qhyqlxStDQLvprD5VXWdlkWfbI54uNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vIKHj/sH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vIKHj/sH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CAD1C19423;
	Tue, 31 Mar 2026 16:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975272;
	bh=KWMsdIXKI6PIfFCWYWJ+DYpn7wQxxRijzydoYqGJcmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vIKHj/sHuYq+LaZxcmcuu0aES5hPBpHXHGHBv94iDAbsXjWYShaZBcfmheQW2nKZa
	 vA0NssHzYlYHzPW/NAqQs2AiYgIh6vRUOGLN/DC1ihb0BH6cddA9Yv9IMrVDy92rrF
	 qmMKH3pk3WgJUZh9K3q+Gx5LLFARqAUTcoVCBlpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Franz Schnyder <franz.schnyder@toradex.com>,
	Marco Felsch <m.felsch@pengutronix.de>,
	Ming Qian <ming.qian@oss.nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	stable@kernel.org,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.19 229/342] media: verisilicon: Fix kernel panic due to __initconst misuse
Date: Tue, 31 Mar 2026 18:21:02 +0200
Message-ID: <20260331161807.394119899@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Qian <ming.qian@oss.nxp.com>

commit e8d97c270cb46a2a88739019d0f8547adc7d97da upstream.

Fix a kernel panic when probing the driver as a module:

  Unable to handle kernel paging request at virtual address
  ffffd9c18eb05000
  of_find_matching_node_and_match+0x5c/0x1a0
  hantro_probe+0x2f4/0x7d0 [hantro_vpu]

The imx8mq_vpu_shared_resources array is referenced by variant
structures through their shared_devices field. When built as a
module, __initconst causes this data to be freed after module
init, but it's later accessed during probe, causing a page fault.

The imx8mq_vpu_shared_resources is referenced from non-init code,
so keeping __initconst or __initconst_or_module here is wrong.

Drop the __initconst annotation and let it live in the normal .rodata
section.

A bug of __initconst called from regular non-init probe code
leading to bugs during probe deferrals or during unbind-bind cycles.

Reported-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Closes: https://lore.kernel.org/all/68ef934f-baa0-4bf6-93d8-834bbc441e66@kernel.org/
Reported-by: Franz Schnyder <franz.schnyder@toradex.com>
Closes: https://lore.kernel.org/all/n3qmcb62tepxltoskpf7ws6yiirc2so62ia23b42rj3wlmpl67@rvkbuirx7kkp/
Fixes: e0203ddf9af7 ("media: verisilicon: Avoid G2 bus error while decoding H.264 and HEVC")
Suggested-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Suggested-by: Marco Felsch <m.felsch@pengutronix.de>
Reviewed-by: Marco Felsch <m.felsch@pengutronix.de>
Signed-off-by: Ming Qian <ming.qian@oss.nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Cc: stable@kernel.org
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/verisilicon/imx8m_vpu_hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/verisilicon/imx8m_vpu_hw.c b/drivers/media/platform/verisilicon/imx8m_vpu_hw.c
index 6f8e43b7f157..fa4224de4b99 100644
--- a/drivers/media/platform/verisilicon/imx8m_vpu_hw.c
+++ b/drivers/media/platform/verisilicon/imx8m_vpu_hw.c
@@ -343,7 +343,7 @@ const struct hantro_variant imx8mq_vpu_variant = {
 	.num_regs = ARRAY_SIZE(imx8mq_reg_names)
 };
 
-static const struct of_device_id imx8mq_vpu_shared_resources[] __initconst = {
+static const struct of_device_id imx8mq_vpu_shared_resources[] = {
 	{ .compatible = "nxp,imx8mq-vpu-g1", },
 	{ .compatible = "nxp,imx8mq-vpu-g2", },
 	{ /* sentinel */ }
-- 
2.53.0



