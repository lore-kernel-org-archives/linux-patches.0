Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4FD0456DE1;
	Sat, 12 Sep 2026 11:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210891; cv=none; b=PLV9A+JEF8clylzPTdm16JfAG6NYPBFHNtKGUhegFBHje0NLYMZtxcllFJqE/3wVMvGkZ6vnNG+14yyTr4HM9NpEGtndYRPVGcrwiaTXxQQVwimKRJYhpg7k1ZyVfK7gVJF4YNCzihUH746hPJlvPG/H+mg2+DwmEF3lt9BfLs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210891; c=relaxed/simple;
	bh=K6Y7FikbB+DbCBaIMhNobTfB5hdrNK5/BoJep6x7Uxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NIMfcG/LYbjk+ZsQ6mmPWJTlVeNG6LhhbZYtO5/RiXZw016Obq9RrHakSSUtc3Kxyp92K9La0dvDwQS0vhG0lRU67gsyaaKpuajQfVgpiG4x6gbQd1sw92BntP5HgiqTtZsyjPLdZbJBIVCzByiXVfsKbhXLgk5YA+ZsCkEOoPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kcVwZjhH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kcVwZjhH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FE9B1F000FF;
	Sat, 12 Sep 2026 11:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210889;
	bh=2KzmNkpbXtgof6CCDffcBuHA/n3LpAQhux7Wl8iGqUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kcVwZjhHQxZKySSElw1/b0cRylhxO86sVRmQ6qZyuCoixwXhUmbLiUi/wCnoL28M3
	 GzjEi+YQjy69lEFw2XUtApsqd896aBu7XUJ0thYF3BgJheByy7X/OjcqJ+KNqoS9KG
	 rAdIJwVCzrShufmb/2Scgh6CudouL0Xl84yMBWzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Peisach <jpeisach@ubuntu.com>,
	Janne Grunau <j@jannau.net>,
	Nick Chan <towinchenmi@gmail.com>,
	Sven Peter <sven@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1119/1518] nvme: Add a quirk for page aligned admin queue buffers
Date: Sat, 12 Sep 2026 08:54:48 +0200
Message-ID: <20260912065648.765985302@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Sven Peter <sven@kernel.org>

[ Upstream commit 69d22a6b2f6984200d92dac689f8b00cc3d7d736 ]

Apple controllers seem to require any queue buffers on the admin queue
to be aligned to the NVMe controller page size. Weirdly, this constraint
does not apply to the i/o queue where any alignment is fine. This has
always been required on pre-M1 controllers and is required starting with
macOS 15 firmware or post-M4 controllers again. On M1/M2/M3 we only got
away with this because there was a chicken bit to disable this
requirement. Let's add a quirk that enforces this alignment.

Tested-by: Joshua Peisach <jpeisach@ubuntu.com>
Tested-by: Janne Grunau <j@jannau.net>
Tested-by: Nick Chan <towinchenmi@gmail.com>
Signed-off-by: Sven Peter <sven@kernel.org>
Stable-dep-of: ea2160c7b781 ("nvme-apple: Require page aligned buffers on the admin queue")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 5 ++++-
 drivers/nvme/host/nvme.h | 7 +++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 7d475e298baaf..dcf729aacb1f7 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2057,7 +2057,10 @@ static void nvme_set_ctrl_limits(struct nvme_ctrl *ctrl,
 	lim->max_integrity_segments = ctrl->max_integrity_segments;
 	lim->virt_boundary_mask = ctrl->ops->get_virt_boundary(ctrl, is_admin);
 	lim->max_segment_size = UINT_MAX;
-	lim->dma_alignment = 3;
+	if (is_admin && (ctrl->quirks & NVME_QUIRK_ADMIN_PAGE_ALIGN))
+		lim->dma_alignment = NVME_CTRL_PAGE_SIZE - 1;
+	else
+		lim->dma_alignment = 3;
 }
 
 static bool nvme_update_disk_info(struct nvme_ns *ns, struct nvme_id_ns *id,
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 0b8b91506b1f4..ec03a07617af1 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -178,6 +178,11 @@ enum nvme_quirks {
 	 * Align dma pool segment size to 512 bytes
 	 */
 	NVME_QUIRK_DMAPOOL_ALIGN_512		= (1 << 22),
+
+	/*
+	 * Admin queue DMA buffers must be page aligned
+	 */
+	NVME_QUIRK_ADMIN_PAGE_ALIGN		= (1 << 23),
 };
 
 static inline char *nvme_quirk_name(enum nvme_quirks q)
@@ -229,6 +234,8 @@ static inline char *nvme_quirk_name(enum nvme_quirks q)
 		return "broken_msi";
 	case NVME_QUIRK_DMAPOOL_ALIGN_512:
 		return "dmapool_align_512";
+	case NVME_QUIRK_ADMIN_PAGE_ALIGN:
+		return "admin_page_align";
 	}
 
 	return "unknown";
-- 
2.53.0



