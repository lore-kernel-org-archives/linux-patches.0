Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4DF612AAF7;
	Tue, 14 May 2024 11:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685482; cv=none; b=H6NB1WDeM5oAbBGNpYmZ4K+Kr/82s32E0QNSF50UIeD8RbhymHAdzQbNxG1DOZHk+fAuFDm2xNLbFrujAc61LjAAHQoqOqZgPb3CY8Y2tGj7Pauctp30Dcgf72HqPDjNZqMm2HdMyj71K7MZXFrvXqojO1D01JNYJpI3AEWNbL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685482; c=relaxed/simple;
	bh=gxxphhWjOPuPb7TNGFYgBnJ9dP758CzgsORz0Qn/wmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mJr5DgzMPjVZleBsk5QrQWQDQzmBiiSmtcU60W38BCkcOkLn5Naw5piiVkCihzu1xbsStgsEJvsKz5zdIv/yZqc2LxKjErSF6WujfZLFknebdTNe/wtR5YDHwcsEZDwuCdbyT9BrCh9veFpjOe//35c+mOlI54a/Ber63w9uh/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qKPNLr1r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qKPNLr1r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8563BC2BD10;
	Tue, 14 May 2024 11:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685482;
	bh=gxxphhWjOPuPb7TNGFYgBnJ9dP758CzgsORz0Qn/wmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qKPNLr1r993P92uCiE3CgzhRB/PkuhgTcNKP+GjCWits9l/a/WfenOLJDbICE8ams
	 ziVc1Qt+2xzDHZ+OSwUWekFUfVcqfXPCgaa9XQzkJUa4WYSFSC2vp3N6ZF94XnB8cb
	 Qk7C+0bS7rbaBfjUITJHaB5QPtV+0zo32JYxx55Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 165/301] clk: Dont hold prepare_lock when calling kref_put()
Date: Tue, 14 May 2024 12:17:16 +0200
Message-ID: <20240514101038.486874775@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4a67c0d4823cf..f8776065ad1f1 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -4523,7 +4523,8 @@ void clk_unregister(struct clk *clk)
 	if (ops == &clk_nodrv_ops) {
 		pr_err("%s: unregistered clock: %s\n", __func__,
 		       clk->core->name);
-		goto unlock;
+		clk_prepare_unlock();
+		return;
 	}
 	/*
 	 * Assign empty clock ops for consumers that might still hold
@@ -4557,11 +4558,10 @@ void clk_unregister(struct clk *clk)
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
 
@@ -4720,13 +4720,11 @@ void __clk_put(struct clk *clk)
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



