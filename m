Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E54427FB37;
	Sat, 12 Sep 2026 16:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229596; cv=none; b=p4LpCMe0LVwOv7votvOri/S7IWQ/uR06O4iwBVTh/MvEdw8gem+Nx04jDwK1ZPsq/LAR8dbxkSNSyrRbiEJ7CXI7bUiOq49i+oCshfKecslwAZeuUDWHcxK232RX7XKhM9R8FYrGAmKwXvbhoFjLqxjzk3yV3y5u3k5TqQ3ukyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229596; c=relaxed/simple;
	bh=Ldcxj7bHzEpGNeW3fad2MlCi/PnZxuzpkvb/TBXrzsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rDCdVnQP/Ofh5UL0w1iGgTiEU27DSgTa3zF61/xdiLs97JFRMZMx5J3I76er6x2hCt5EOepia72bX9D2lfuWNd64eJI2LODzG7Tj/nrkkeoxvFqWTdhvTuik3ZuW5UgsAuo59f6nx3PGKCJZ4vJPaCU5bomX8+b0z3wcqnwpnds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dIn42cbx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dIn42cbx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72CC31F000FF;
	Sat, 12 Sep 2026 16:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229595;
	bh=WRms4QGDafTSdfMbhoSrR0iIlSFHTM7vkv745RyCi5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dIn42cbx2wTSnToovNXGIhBHOEtN5tzlBM5Zic5WCX0SvkRzhpRoi5/ifIt3kROSh
	 eJPFzI2ntWTA2Ko+98GA6pWbcQbOtyCIlRCBdZYPW8VuA9FxzNSas+2MfwCBPC7Ptr
	 OXihTikZQbi0QzPI5YV54w6Khqd6n2aXhqzShXgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uday Khare <udaykhare77@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0622/1191] remoteproc: qcom: Fix glink->node reference leak in qcom_add_glink_subdev
Date: Sat, 12 Sep 2026 08:55:50 +0200
Message-ID: <20260912065602.220862281@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Uday Khare <udaykhare77@gmail.com>

[ Upstream commit 44f4911ab8e6f4d69afad5f2571bbd2da421c918 ]

In qcom_add_glink_subdev(), the device node reference acquired via
of_get_child_by_name() is stored in glink->node. If the subsequent
kstrdup_const() allocation for glink->ssr_name fails, the function
returns early without calling of_node_put() on glink->node, leaking
the reference count.

Fix this by adding of_node_put(glink->node) on the error path before
returning.

Fixes: cd9fc8f1b35b ("remoteproc: qcom: Pass ssr_name to glink subdevice")
Signed-off-by: Uday Khare <udaykhare77@gmail.com>
Link: https://lore.kernel.org/r/20260618132054.11010-1-udaykhare77@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_common.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/remoteproc/qcom_common.c b/drivers/remoteproc/qcom_common.c
index 9726b0bcf6334..11d2fa4e7394d 100644
--- a/drivers/remoteproc/qcom_common.c
+++ b/drivers/remoteproc/qcom_common.c
@@ -231,8 +231,10 @@ void qcom_add_glink_subdev(struct rproc *rproc, struct qcom_rproc_glink *glink,
 		return;
 
 	glink->ssr_name = kstrdup_const(ssr_name, GFP_KERNEL);
-	if (!glink->ssr_name)
+	if (!glink->ssr_name) {
+		of_node_put(glink->node);
 		return;
+	}
 
 	glink->dev = dev;
 	glink->subdev.start = glink_subdev_start;
-- 
2.53.0



