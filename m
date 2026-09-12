Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D8C1EB5FD;
	Sat, 12 Sep 2026 08:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200259; cv=none; b=P+1/bb+rF/bfIyJj0+/oFgzvtin2J2diiLTkfQHjyvHkKXGz3pv+QDq2ctDtlh++ZTQnHK5/d5v1EMF8bnYL5LV7Ot1rmyEOX2+ipI0PEXA4ZyX+fnrKfEX9FLOGq2T+YtKKUDEsocD1QZb1mqr4mICa3wzpKSk8juW2mgJ5X6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200259; c=relaxed/simple;
	bh=yGcEDWD/XBy/qMTbYEf8zVHxmaSTulIKZZ3JEYJxkpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c7/FMvq4I2CnKcaY7sOWTfy07cklC7fH3Tw4dNuJvAUd8bwGny+pj1ahfalMvRPor7nPCHcrjiXvQyRH7csA9vPY2W8ITYiC/yxIwWw4x7squX6QGs+sUbATmA2HxTv4xgsNQVvdP2iVAHQhtBT8p0jXLFVWU7qibT3YySSYhsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l4XV1jTX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l4XV1jTX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D4CB1F000FF;
	Sat, 12 Sep 2026 08:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200258;
	bh=hV0S4aiMKsJCEZq6pKrbs/svo4vV3Z5fogY1Ov/eGTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l4XV1jTXyiU/zfo3ZxojmFN8hD8dKNDK3k0LYDY0c/LMcM+12ugptsPtkzk3d7ljr
	 btuk3La864EtfubeOGkYMZxe5o6tTABzyWfrGhVQidmuEIMN9GCUzegdB900wbqn/P
	 YoeQazE8h4Kixph8/z56lfUYydoOs3QNpzMg5QYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0753/1815] media: qcom: iris: handle runtime PM resume failure in core deinit
Date: Sat, 12 Sep 2026 08:41:43 +0200
Message-ID: <20260912065706.583635086@linuxfoundation.org>
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
index 52bf56e517f91..8c335dbfce166 100644
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



