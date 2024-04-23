Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0056614388D;
	Tue, 23 Apr 2024 21:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908500; cv=none; b=Rg9dCvftnZZQDrmcuaOf6R46+XiNMuEHeVuqwkSB56dUdcA0spVPh9y0VL573s3uxBtWWCF/h6eqdUlXE8WpV2V3qshI/DMr0aIyqLGJ6Cct78QyZLp5RvVdKXXYOOPUqtCqPOJUHwzD99D4wP50UkRsFrqvmQZEOVFohsTGluI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908500; c=relaxed/simple;
	bh=77XTrRJEjhfx/hs4eY9GIlCFHL8IZ6lHXuoghBBZNOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=awJyYlRRVTngtfybhd9l1H5bPV44g4jPs/i02kqcwS1bG5kg1dbe+BYDEU5SBhji0Y73Zfwbd1UsIDPOg/hLczieuhHGgur6pH5oQKJdsJZo8uig2vKDEkf2KSZ7uz1SP6WoHzeT6Qr3D+wHPblv3SDmUre4aBmAwn6S02x/00g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lJlRCJs5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lJlRCJs5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0429C116B1;
	Tue, 23 Apr 2024 21:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908499;
	bh=77XTrRJEjhfx/hs4eY9GIlCFHL8IZ6lHXuoghBBZNOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lJlRCJs5i9vFquFjYUiHGWNORnJT6GrqxAelKTdaXfyXe3drRHTT9QWZ/hGVxZU0h
	 1MN/bn5vR6VibnfJV/aJQ+yoPhicm9HkeQKAmD71/tlAFlfSvKOIieyVYbq7JdH8ga
	 1hyitNCNVUpHY41WT2mnCkaRVhn+AAriMz5wo3ws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Douglas Anderson <dianders@chromium.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 078/158] clk: Remove prepare_lock hold assertion in __clk_release()
Date: Tue, 23 Apr 2024 14:38:20 -0700
Message-ID: <20240423213858.484937700@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

[ Upstream commit 8358a76cfb47c9a5af627a0c4e7168aa14fa25f6 ]

Removing this assertion lets us move the kref_put() call outside the
prepare_lock section. We don't need to hold the prepare_lock here to
free memory and destroy the clk_core structure. We've already unlinked
the clk from the clk tree and by the time the release function runs
nothing holds a reference to the clk_core anymore so anything with the
pointer can't access the memory that's being freed anyway. Way back in
commit 496eadf821c2 ("clk: Use lockdep asserts to find missing hold of
prepare_lock") we didn't need to have this assertion either.

Fixes: 496eadf821c2 ("clk: Use lockdep asserts to find missing hold of prepare_lock")
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Link: https://lore.kernel.org/r/20240325184204.745706-2-sboyd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 20c4b28fed061..c6928dce50f23 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -4356,8 +4356,6 @@ static void __clk_release(struct kref *ref)
 {
 	struct clk_core *core = container_of(ref, struct clk_core, ref);
 
-	lockdep_assert_held(&prepare_lock);
-
 	clk_core_free_parent_map(core);
 	kfree_const(core->name);
 	kfree(core);
-- 
2.43.0



