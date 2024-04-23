Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BEAA143882;
	Tue, 23 Apr 2024 21:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908738; cv=none; b=nZLRIxoG1hD/3tA05h3tdzd4a9IUB7PhH+1sQW/3JnknZsZ2GDQuO8bipYKsdUUfOU/5aMdJW2dRnRYEZf89uShwQc3I8xltD2ddiMMU/oRg1kslMUFCc1UcRblcCg6x4QQX9UlWfmQ6mrhamjuvKSo2KlxDjO76k3s/855kIk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908738; c=relaxed/simple;
	bh=Jd3Zg8FsQlVWHidA6i+Z4Ax1rvZUZAadq4tRIGE127k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VNihtAraO+u5Sn/8m89+ApfE4kg96RtRVOefkKOybgXLJA0g6SWxZIbuSv92wTMc2DX9SaJoGgPWcNAprWVppMBzu7VsgYpPdL19VB0a5JdvuKVCbUvzl91b29v1Q0f3FagH0EyhTNRrgUtxCCHmbnagfF6c+OVrYhSBbPzvx38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RTKQmPrJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RTKQmPrJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18A30C116B1;
	Tue, 23 Apr 2024 21:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908738;
	bh=Jd3Zg8FsQlVWHidA6i+Z4Ax1rvZUZAadq4tRIGE127k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RTKQmPrJa+azZ1cwAN+xAbTtKBhcWoiu/ArE+Bx6NW/48yhZhGd18twMz2tsJkEZ+
	 R4DSDxhB671tBztOa9NEJ5WmyChyHlVYewGFguUONu3soWCIIr4t6BsoNm5eta2A8P
	 mztkjEqRUQt2+/DprrE895WqNAc3/cGNpy5qYJrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Douglas Anderson <dianders@chromium.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 083/141] clk: Remove prepare_lock hold assertion in __clk_release()
Date: Tue, 23 Apr 2024 14:39:11 -0700
Message-ID: <20240423213855.864887822@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9004e07182259..ad40913d80a8b 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -4230,8 +4230,6 @@ static void __clk_release(struct kref *ref)
 {
 	struct clk_core *core = container_of(ref, struct clk_core, ref);
 
-	lockdep_assert_held(&prepare_lock);
-
 	clk_core_free_parent_map(core);
 	kfree_const(core->name);
 	kfree(core);
-- 
2.43.0



