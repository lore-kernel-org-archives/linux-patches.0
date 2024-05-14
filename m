Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B72D4205D;
	Tue, 14 May 2024 11:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687357; cv=none; b=dZiU1WqC0Okoll2rmJMcwQ0dIqFsUZmDglgLar3aZQR4dCWSaLRs/3tGwqgKGobKerixZGaauMEdjagOm+tmsE4SsLjHbADrW07aCzEGcJKh7XgnhSQg5oyf9zSxtdsCJuf5kL69HIrOYy7hNV1ImheRbmltulvvi/+V6kQPwDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687357; c=relaxed/simple;
	bh=CjCXHmK5Y/80c/JMBTsI+4Cq+dpC9ntJxtanQegUi4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RfAAwGXAaiJ5Dlj3mpIKIXX2MvHKf+OsXuydhtoqec+MgE5dK3Q62+FSgRSJaBAkNRpxQMlwF1FcxvNTo8Uj0HLVxPlcl/5g9B+GJw23ofC2UFd9Lpl/IM/jDUXgZo6Eb7naz9etI0j2qNZSXvqku30AGt3ghS9J9y4YfOo0hTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=upjX8x1D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="upjX8x1D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D50B3C2BD10;
	Tue, 14 May 2024 11:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687357;
	bh=CjCXHmK5Y/80c/JMBTsI+4Cq+dpC9ntJxtanQegUi4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=upjX8x1Dx/5qtxLOIi6Xe7cLrpMq7X7SxD6fZlDqyok5Sj7S3P2mBUdXsC8R5qtsK
	 5fVKthkP7gU1I6n+3rOLx8/RT/nQSZoO7TEl2i7UTmmjOUu1XbpY460k+QoZDbIPOS
	 njqrQVhYVOv/57NuRaSHDg1lf5RUgAOMc2NkkHh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 069/111] clk: Dont hold prepare_lock when calling kref_put()
Date: Tue, 14 May 2024 12:20:07 +0200
Message-ID: <20240514100959.756405995@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100957.114746054@linuxfoundation.org>
References: <20240514100957.114746054@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a0927c7f83d60..7dc3b0cca252a 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -4186,7 +4186,8 @@ void clk_unregister(struct clk *clk)
 	if (ops == &clk_nodrv_ops) {
 		pr_err("%s: unregistered clock: %s\n", __func__,
 		       clk->core->name);
-		goto unlock;
+		clk_prepare_unlock();
+		return;
 	}
 	/*
 	 * Assign empty clock ops for consumers that might still hold
@@ -4220,11 +4221,10 @@ void clk_unregister(struct clk *clk)
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
 
@@ -4387,13 +4387,11 @@ void __clk_put(struct clk *clk)
 	    clk->max_rate < clk->core->req_rate)
 		clk_core_set_rate_nolock(clk->core, clk->core->req_rate);
 
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



