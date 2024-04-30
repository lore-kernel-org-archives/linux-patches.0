Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C6212CDAE;
	Tue, 30 Apr 2024 11:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476082; cv=none; b=ucR+rcdr89rnoKgIwz1xHwIvcR+m/xGA5WuUFcGaf8pDDtYVJABCJg+SgKNfEaa2bgIG79ycg05zrQjB0V3jKFL4jEF/BFVGrH6fYvOtvCTu4Ql3udlzm3RawzzAOV/u2ylpcKIjMRvZsrsneoF3oDbDEEmEXJ7ND7Eafk85Vpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476082; c=relaxed/simple;
	bh=57I9rpAInKosPvD+P9LDZb0dYJfsYLKz/3BRx7+Pha0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eqf5PYRhERSnHYHafZ8rTAXO9ntv1Gr86iuoiajiVlmZxMwuhis30U+PdchODpAZ79SmbMJu19sjpIheBRvSPNhhqhWvCZyCvnRoPPMiv1AeuPKNSEtOJs3EZVfb9Q7TlhHZHpFobk3Ga6eFnvd3xIgdZEJvchYLCMTx6nB0YxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gIQUi4k5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gIQUi4k5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ADDEC2BBFC;
	Tue, 30 Apr 2024 11:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476081;
	bh=57I9rpAInKosPvD+P9LDZb0dYJfsYLKz/3BRx7+Pha0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gIQUi4k5atsYhMqSpo4vKYVzpTWqtbvvsSHuXsFNzXk5R6jzva8Q+Sb6+oLrBuX8I
	 WNGJ1u413Bxf00udWeL3HZdW5TsdD56kMeKQ80FDMZMAGoAb+Su9UNvnfec24xJ6O1
	 eGq3R2p9pX6f06LQAI4FcWCZQRdj0AuXuHgpyRy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Douglas Anderson <dianders@chromium.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 028/107] clk: Remove prepare_lock hold assertion in __clk_release()
Date: Tue, 30 Apr 2024 12:39:48 +0200
Message-ID: <20240430103045.493204740@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103044.655968143@linuxfoundation.org>
References: <20240430103044.655968143@linuxfoundation.org>
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
index 67051ca60920a..85a043e8a9d57 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -3883,8 +3883,6 @@ static void __clk_release(struct kref *ref)
 {
 	struct clk_core *core = container_of(ref, struct clk_core, ref);
 
-	lockdep_assert_held(&prepare_lock);
-
 	clk_core_free_parent_map(core);
 	kfree_const(core->name);
 	kfree(core);
-- 
2.43.0



