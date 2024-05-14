Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A6C54F87;
	Tue, 14 May 2024 11:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687746; cv=none; b=gNXtTlZjBK76j62Pjl9CHWCOF2wk8a0wmKufG5vCt3AVCrxfTndb7KiWpJyx1yDkaIZr5AMTsuSf6MdfGeUbghqqlDcKXM4vpMnUmN/TYoQHVd4mR9kY4yFJoTfd0U129utrm7EeGiY5+E2sV7Mf1DnFvW74G54Sn/c+nzbOZos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687746; c=relaxed/simple;
	bh=5LGHAdNH2gehhgEWY01PI/xqxbunqXgRdWWXO50zIMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nGyO/1B1I4ElHdhBrljFc67WLKSg8EovI4gu1gHsVJ+bmGTZrOxVcnQKusfyoRRd8lYtHnq4NrGzAZpwcWDM99XkMQXni+nKSYA5YVVdaLdjqJzgoMrhSXbJCmjjnFoYUGuSePoYvxVLmwQWjsvZMEouXgiWeesNUJnlZtfkkls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=apZPwS4w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="apZPwS4w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5279CC2BD10;
	Tue, 14 May 2024 11:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687746;
	bh=5LGHAdNH2gehhgEWY01PI/xqxbunqXgRdWWXO50zIMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=apZPwS4woUQ2oB5j/IL/CF4yQ8ZTvLiG55Dp7qDAZrr9USv506p/cYtSHAuqks3PK
	 j7ImPsh8qza+9djnnWGfAMpEGUnCdaV+dftweIv86pKgxZPa8FJ+IEqyAdcWETrO9y
	 V58+HQ99IDEfI0LB2rv3MJBr3mceJwXZgu4O4XDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 091/168] clk: Dont hold prepare_lock when calling kref_put()
Date: Tue, 14 May 2024 12:19:49 +0200
Message-ID: <20240514101010.126149536@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a05b5bca64250..dc2bcf58fc107 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -4227,7 +4227,8 @@ void clk_unregister(struct clk *clk)
 	if (ops == &clk_nodrv_ops) {
 		pr_err("%s: unregistered clock: %s\n", __func__,
 		       clk->core->name);
-		goto unlock;
+		clk_prepare_unlock();
+		return;
 	}
 	/*
 	 * Assign empty clock ops for consumers that might still hold
@@ -4261,11 +4262,10 @@ void clk_unregister(struct clk *clk)
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
 
@@ -4471,13 +4471,11 @@ void __clk_put(struct clk *clk)
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



