Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C2647D930;
	Thu, 20 Aug 2026 16:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243256; cv=none; b=ZxCFrYd06TXGbCdhszvRl9I8jNMUjx63gqEbM6AwFSWYz3H5AAdQamzO4I/7z2l7zYMALlsMWBCcgiSHvVm4K/Ppz60JMU5FwjmByosV+WgNMLzM5UvCT8MW/2qT29U3rwaq3IKPLhODBh/ogQErzIQl7V1DiouAKQDftGZjsKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243256; c=relaxed/simple;
	bh=kRvfWYc6ASVwnnFvOl7tvbJJkAYhyvDcyBqwvdzIfKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DzPPXr7IHq+P9CNYMZdn39eFCuHZvGFqOrpUTHT+oZKHSFWHFZBvF9MpzBgA6vsCYbdBYITwMn7E4JBJzzAdgxtfa0kUHvX7hzwedqDjwMYN9g9pguaMQWdffZtH61LYijkgIByIcBHCQWCLFHrVtTKg+00pMoptI6iVB0Ls/Es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nJt+SFyu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nJt+SFyu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B0251F000E9;
	Thu, 20 Aug 2026 16:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243251;
	bh=3x01jKLJJbWvXCT9arPe6m6XJRbsLz1fMahegJPIum4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nJt+SFyuKJuW1vjVj+3P9d6kYSv5ZMw/ZU6QdZbpbFktDI75lbxhCwUZ0N2L1Vdoi
	 3Y/+UkdUNQG7EBvZxGqBxkFYk6QN6Lz0SUQuDM9TqOtL75CioDuCDLqHS4+C2XbAks
	 CQ5oZgJwBxsfvI4eekcuOu7zVkIoptx9uXqqRUNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Andrey Troshin <drtrosh@yandex-team.ru>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 003/272] media: mediatek: vcodec: Fix a resource leak related to the scp device in FW initialization
Date: Thu, 20 Aug 2026 16:53:07 +0200
Message-ID: <20260820145231.339684482@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

From: Jiasheng Jiang <jiashengjiangcool@gmail.com>

[ Upstream commit 4936cd5817af35d23e4d283f48fa59a18ef481e4 ]

On Mediatek devices with a system companion processor (SCP) the mtk_scp
structure has to be removed explicitly to avoid a resource leak.
Free the structure in case the allocation of the firmware structure fails
during the firmware initialization.

Fixes: 53dbe0850444 ("media: mtk-vcodec: potential null pointer deference in SCP")
Cc: stable@vger.kernel.org
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
[Andrey Troshin: backport fixs from
 drivers/media/platform/mediatek/vcodec/common/mtk_vcodec_fw_scp.c
 to drivers/media/platform/mtk-vcodec/mtk_vcodec_fw_scp.c]
Signed-off-by: Andrey Troshin <drtrosh@yandex-team.ru>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mtk-vcodec/mtk_vcodec_fw_scp.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_fw_scp.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_fw_scp.c
index 27f08b1d34d1..199a64c853bc 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_fw_scp.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_fw_scp.c
@@ -65,8 +65,11 @@ struct mtk_vcodec_fw *mtk_vcodec_fw_scp_init(struct mtk_vcodec_dev *dev)
 	}
 
 	fw = devm_kzalloc(&dev->plat_dev->dev, sizeof(*fw), GFP_KERNEL);
-	if (!fw)
+	if (!fw) {
+		scp_put(scp);
 		return ERR_PTR(-ENOMEM);
+	}
+
 	fw->type = SCP;
 	fw->ops = &mtk_vcodec_rproc_msg;
 	fw->scp = scp;
-- 
2.53.0



