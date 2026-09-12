Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C9A9299920;
	Sat, 12 Sep 2026 10:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208553; cv=none; b=O9nQZCOPE9z1J9RQBEo6wIyE2RRsPl7yHxxoBx099zl9iHkURpSAsQkBdu6hNDa9SvI+5oEJpGXkvcAJm9uYQQHxNkhJUeEa677MumQ1DreU+PUQx1tafBGvWz0BDkBvogUbq+GqpdWEZBlp7GTJR/ChYT/NenR7cRi68eGKDOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208553; c=relaxed/simple;
	bh=9C4N4+sdeczPkgdr668zpas18GRPDA7KPaQRzQ6z0Ek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LRygJCmV0rZh4FfkGVlfHYYTSS+O+BFD7ukb8tZIKjbGWACOm/xndGA2r0Ogp2Xfr8gbChefp08o/38UhqLYZw1T7py5YP2D/kjTnASY+Hn06sIGyD80s7yWnvmleUehbMku2RONK3bGwvkfQO4ZLpfqldVSZa6sUUZhbjssK/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B+Zs9Xid; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B+Zs9Xid"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D9481F000FF;
	Sat, 12 Sep 2026 10:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208549;
	bh=dpG1H7OkLN12zqPL9SntcQifxrKQq22/hWmc+e3Vuns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B+Zs9XideDytbgV48IEno8Bwh/YS6PoJdhJ1Z+PAEV+ZahB/d7f/DBqzZAGULgC5b
	 7AVMDB2QL7uyo+dCeyK57Q300V4L1pba2+vb+9owfzfGz4JcVe6bGlo82NcEfmoua/
	 wW6heH31jyj7domO6vEYTglnk77UovSNt84dpN9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0638/1518] media: qcom: iris: handle runtime PM resume failure in core deinit
Date: Sat, 12 Sep 2026 08:46:47 +0200
Message-ID: <20260912065637.863214203@linuxfoundation.org>
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

From: Hungyu Lin <dennylin0707@gmail.com>

[ Upstream commit 75d79879ec3cbfd288144b0ae4c3e3fa7700c5fc ]

Check the return value of pm_runtime_resume_and_get() in
iris_core_deinit().

If runtime PM resume fails, skip hardware power-off operations but
still perform software teardown and state transition. Also skip the
corresponding pm_runtime_put_sync() call to avoid unbalanced runtime
PM references.

Fixes: bb8a95aa038e ("media: iris: implement power management")
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/iris/iris_core.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/qcom/iris/iris_core.c b/drivers/media/platform/qcom/iris/iris_core.c
index 8406c48d635b6..e337f8b7e6f07 100644
--- a/drivers/media/platform/qcom/iris/iris_core.c
+++ b/drivers/media/platform/qcom/iris/iris_core.c
@@ -12,18 +12,24 @@
 
 void iris_core_deinit(struct iris_core *core)
 {
-	pm_runtime_resume_and_get(core->dev);
+	int ret;
+
+	ret = pm_runtime_resume_and_get(core->dev);
 
 	mutex_lock(&core->lock);
 	if (core->state != IRIS_CORE_DEINIT) {
 		iris_fw_unload(core);
-		iris_vpu_power_off(core);
+
+		if (!ret)
+			iris_vpu_power_off(core);
+
 		iris_hfi_queues_deinit(core);
 		core->state = IRIS_CORE_DEINIT;
 	}
 	mutex_unlock(&core->lock);
 
-	pm_runtime_put_sync(core->dev);
+	if (!ret)
+		pm_runtime_put_sync(core->dev);
 }
 
 static int iris_wait_for_system_response(struct iris_core *core)
-- 
2.53.0



