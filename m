Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BDB413D880;
	Tue, 14 May 2024 10:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683426; cv=none; b=QAWL6v6vyiriw7eWcPq0SOpgOz+E79U/5VmCC1eiVvIJyg2h4UdFkcZ0KGH2EA6/ukORDbxtRpYGcSnGKSY7ipAWuQ84H35TD+RfV24vSeWs3ZDbgGKgA95Fv1i4BhClYLtwCNVOGm2vFSy9Nh+SxUm/GlpM4THe1XCC4P+oFw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683426; c=relaxed/simple;
	bh=CsmfO8fn1coRVRqTKjw4QaHuBS7gEa5/Wd1zL8zgiJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KBxBkMm96poW1UfzloiWOm8gy3LMA0lgJptjicfhsMmswzQYxkrsOIAuLVU34SUIzP+EoVjW32jQnG50jcSa2Ya+DcX0c92ToVUEXDf/b6gHoSprkkMkhn5q0mOzVQUZHcpugWbewzFzHfw8h5xJkYayyL+j6+L0NntPhZBobgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xGLOO1hM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xGLOO1hM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9468CC2BD10;
	Tue, 14 May 2024 10:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683426;
	bh=CsmfO8fn1coRVRqTKjw4QaHuBS7gEa5/Wd1zL8zgiJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xGLOO1hMNhv1/G2r9NVIisPoyFC1EwZAMKeG82UzTCBz9tUa0dTaEfERqVLKcWLdY
	 6nMe1oSxm698gwa50mZzM89Vli5fGk3L0diGcMgc+SL2wN4WIYqcNa1OFvGhlK3zXZ
	 WEgiQR2zBLQQeOeAAkKdR+RUGXsPRfaX2cEKMueQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 184/336] clk: Dont hold prepare_lock when calling kref_put()
Date: Tue, 14 May 2024 12:16:28 +0200
Message-ID: <20240514101045.549216279@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Boyd <sboyd@kernel.org>

[ Upstream commit 6f63af7511e7058f3fa4ad5b8102210741c9f947 ]

We don't need to hold the prepare_lock when dropping a ref on a struct
clk_core. The release function is only freeing memory and any code with
a pointer reference has already unlinked anything pointing to the
clk_core. This reduces the holding area of the prepare_lock a bit.

Note that we also don't call free_clk() with the prepare_lock held.
There isn't any reason to do that.

Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Link: https://lore.kernel.org/r/20240325184204.745706-3-sboyd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index cf1fc0edfdbca..260e901d0ba70 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -4552,7 +4552,8 @@ void clk_unregister(struct clk *clk)
 	if (ops == &clk_nodrv_ops) {
 		pr_err("%s: unregistered clock: %s\n", __func__,
 		       clk->core->name);
-		goto unlock;
+		clk_prepare_unlock();
+		return;
 	}
 	/*
 	 * Assign empty clock ops for consumers that might still hold
@@ -4586,11 +4587,10 @@ void clk_unregister(struct clk *clk)
 	if (clk->core->protect_count)
 		pr_warn("%s: unregistering protected clock: %s\n",
 					__func__, clk->core->name);
+	clk_prepare_unlock();
 
 	kref_put(&clk->core->ref, __clk_release);
 	free_clk(clk);
-unlock:
-	clk_prepare_unlock();
 }
 EXPORT_SYMBOL_GPL(clk_unregister);
 
@@ -4749,13 +4749,11 @@ void __clk_put(struct clk *clk)
 	if (clk->min_rate > 0 || clk->max_rate < ULONG_MAX)
 		clk_set_rate_range_nolock(clk, 0, ULONG_MAX);
 
-	owner = clk->core->owner;
-	kref_put(&clk->core->ref, __clk_release);
-
 	clk_prepare_unlock();
 
+	owner = clk->core->owner;
+	kref_put(&clk->core->ref, __clk_release);
 	module_put(owner);
-
 	free_clk(clk);
 }
 
-- 
2.43.0



