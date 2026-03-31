Received: from n169-110.mail.139.com (n169-110.mail.139.com [120.232.169.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 277193C873A
	for <patches@lists.linux.dev>; Tue, 31 Mar 2026 07:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=120.232.169.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774942634; cv=none; b=KG3jjtfW47saaJqa7BV84qq4qKsVz8C1vz4TpsWwgwCGMxy9qlIEn24ZOjUUrARXhd8fwjDuPNa5CtK5xlr9TBDI1DlB1Dwpla1rbPZ6+v34BCMgny7mLjn4FnRO2dWSZbr3YCxXLMiKZ5TqlCEGi+pdGjxYwuXkjSrmznJbXKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774942634; c=relaxed/simple;
	bh=YBP/TtPYT+hb8wz5QxnOXfzm1eFRzpJ9lgiP2xy99P4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DP5XTaLycPVUa6lCe8p4KlAX/ZMispp22TpIfuRKv4U41xtCIGsTM0+6ZhB2SnXwMaoQkK9W+xOXNenhLXYb+lZ5gWXIKlXftCAT+AJT2kOT5U6lAQMRZfe18rAKGZaZNHmmShoBj4fmd/i5XKOfCsG20+Ar8SZzR1KgJtpm5rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com; spf=pass smtp.mailfrom=139.com; dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b=vIEXjM98; arc=none smtp.client-ip=120.232.169.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=139.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b="vIEXjM98"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=139.com; s=dkim; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=vIEXjM98q4aEqI6MCekX8/1EuxSy4cG6Hmr20/WKaZ6G7gVlVnKoz+Y5d3yJl1dQxKlMhzLHJo1dr
	 +IRDYhzCIThBVVdp0+1/4c1+Hq/3NGNaoJp6Uc1klrW//Be5uGfLg3+D/NJbwXe6avgn1ABbGTPI6i
	 SW/5y9XJQHi3kE34=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM:                                                                                        
X-RM-SPAM-FLAG:00000000
Received:from NTT-kernel-dev (unknown[60.247.85.88])
	by rmsmtp-lg-appmail-09-12087 (RichMail) with SMTP id 2f3769cb799bb1b-00b2a;
	Tue, 31 Mar 2026 15:37:01 +0800 (CST)
X-RM-TRANSID:2f3769cb799bb1b-00b2a
From: Li hongliang <1468888505@139.com>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	ming.lei@redhat.com
Cc: patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	yi.zhang@redhat.com,
	kbusch@kernel.org,
	axboe@fb.com,
	hch@lst.de,
	sagi@grimberg.me,
	hare@suse.de,
	kch@nvidia.com,
	linux-nvme@lists.infradead.org
Subject: [PATCH 6.6.y] nvme: fix admin queue leak on controller reset
Date: Tue, 31 Mar 2026 15:36:59 +0800
Message-Id: <20260331073659.3136206-1-1468888505@139.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit b84bb7bd913d8ca2f976ee6faf4a174f91c02b8d ]

When nvme_alloc_admin_tag_set() is called during a controller reset,
a previous admin queue may still exist. Release it properly before
allocating a new one to avoid orphaning the old queue.

This fixes a regression introduced by commit 03b3bcd319b3 ("nvme: fix
admin request_queue lifetime").

Cc: Keith Busch <kbusch@kernel.org>
Fixes: 03b3bcd319b3 ("nvme: fix admin request_queue lifetime").
Reported-and-tested-by: Yi Zhang <yi.zhang@redhat.com>
Closes: https://lore.kernel.org/linux-block/CAHj4cs9wv3SdPo+N01Fw2SHBYDs9tj2M_e1-GdQOkRy=DsBB1w@mail.gmail.com/
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Li hongliang <1468888505@139.com>
---
 drivers/nvme/host/core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index f09ebcbe1179..215aa871092d 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4287,6 +4287,13 @@ int nvme_alloc_admin_tag_set(struct nvme_ctrl *ctrl, struct blk_mq_tag_set *set,
 	if (ret)
 		return ret;
 
+	/*
+	 * If a previous admin queue exists (e.g., from before a reset),
+	 * put it now before allocating a new one to avoid orphaning it.
+	 */
+	if (ctrl->admin_q)
+		blk_put_queue(ctrl->admin_q);
+
 	ctrl->admin_q = blk_mq_init_queue(set);
 	if (IS_ERR(ctrl->admin_q)) {
 		ret = PTR_ERR(ctrl->admin_q);
-- 
2.34.1


