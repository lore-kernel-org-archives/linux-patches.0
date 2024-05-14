Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8BE1E495;
	Tue, 14 May 2024 11:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687076; cv=none; b=fZH4EBQIulbUCqbcFslvSne/RMoVZRBS2nsFhFH9D92q1j3xdsI/vYZDg3yFP8s3kG+Tnef2DMgot7cbQEYjlIs9xV/AABjY1sURfhuMQCu2bVc33qbUl7HEOINx3/TlAJK3x2BnaQJOD7+1czx+OkWzXcqfK1Qa4NURASTZqEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687076; c=relaxed/simple;
	bh=D1/cY61IFYrfjKGAzPD0hOd7sEkndVRAj+zorc6eXO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rx4035AwbGgY79zMi1wEGdqmUkPV2jCThwK8z/Rcka+CX6nXf+mOUvHFFD1TuDq6UBYeqitEnl1tiyxmlKqShJCUnbwil7uf+F2Xq+HnjuNE2SCi6WHMe/CnTFXHPKoQaHBJDeah7657ChOhGWMCMBwSpJZAR0Xza6JPl6csZio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HaJOhApK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HaJOhApK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45E75C2BD10;
	Tue, 14 May 2024 11:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687076;
	bh=D1/cY61IFYrfjKGAzPD0hOd7sEkndVRAj+zorc6eXO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HaJOhApKE0NolhijiQEBpeR1gtv2OZsBG8xlKWvpLYxZZUbZbJNzlexja4IDTIS0V
	 09ImDvKYYv4nNt6MlR+OUA6nDfIOt5yNe1H8BqK9iV5390nkNgkVEgQfHSt2wGSKuU
	 9Of0RVuop2Dc3acYXYvFByQFBeyELCh9I6pzNQcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 56/84] clk: Dont hold prepare_lock when calling kref_put()
Date: Tue, 14 May 2024 12:20:07 +0200
Message-ID: <20240514100953.793703351@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100951.686412426@linuxfoundation.org>
References: <20240514100951.686412426@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 59a77587da47b..56be3f97c265a 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -4061,7 +4061,8 @@ void clk_unregister(struct clk *clk)
 	if (clk->core->ops == &clk_nodrv_ops) {
 		pr_err("%s: unregistered clock: %s\n", __func__,
 		       clk->core->name);
-		goto unlock;
+		clk_prepare_unlock();
+		return;
 	}
 	/*
 	 * Assign empty clock ops for consumers that might still hold
@@ -4092,11 +4093,10 @@ void clk_unregister(struct clk *clk)
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
 
@@ -4258,13 +4258,11 @@ void __clk_put(struct clk *clk)
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



