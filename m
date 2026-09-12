Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7662F4D5A1;
	Sat, 12 Sep 2026 07:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198744; cv=none; b=HnOni09j74AthUAYz4jBfBsIorGOLSI3Eyvkq8KfXCiqIJMM6Uv91v1FU05a0xViOTftLXzmzUkZspeWxAtRVsZo7XfWKmA78q7UrPY/fTbznfxUaQlXua2YUJjjQgBb+myzTVfYkpNdK5TGliG30/iMph6K/j/8aY0AB//YTjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198744; c=relaxed/simple;
	bh=OhWPQqqpWxkpsZdhNCbHgbZ8VqGT+0MxG4Mis3s28WQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JapqIAYQxiO/ekxxhl3f2F2yEZl2I1L3JTKLV7soMHMbwGm0ucuAx9FC7gH0xcuaRDbBUk4SHdRk1cT/LN1baFZmKG+UGPoYD+v8R4uzDKobqrBxGtUzivx2pPqSjWPUP6rFeqaUw4mPX/5Fn1A1dw+hzMl+SbpySzJbAy7GMNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KriX5jKF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KriX5jKF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79C6F1F000FF;
	Sat, 12 Sep 2026 07:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198743;
	bh=K0jHyi6PSdUY2i0zcAyNQNJeKkQUdhM1hPHK+J98d+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KriX5jKFssoaufZMtN1wtc6EJrehMn1jaWvBa/N3Gvs2J9pv5VXjRZUrw1pqRJeId
	 gyyYo6yTaNZ5HM0CRy702Ut6rW3bo+5djNkP05B+icr65i91wytrgZNlO7/C8lbEHJ
	 g/GQSw0Se2NOwXYQPAlSpGCBPodKMAR2lsHuvats=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uday Khare <udaykhare77@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0442/1815] remoteproc: qcom: Fix glink->node reference leak in qcom_add_glink_subdev
Date: Sat, 12 Sep 2026 08:36:32 +0200
Message-ID: <20260912065659.267580267@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index e1a955476c9b3..5294e327f1587 100644
--- a/drivers/remoteproc/qcom_common.c
+++ b/drivers/remoteproc/qcom_common.c
@@ -253,8 +253,10 @@ void qcom_add_glink_subdev(struct rproc *rproc, struct qcom_rproc_glink *glink,
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



