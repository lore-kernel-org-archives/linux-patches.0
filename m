Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F00157048;
	Mon, 29 Jan 2024 17:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548059; cv=none; b=SRqQIci3ypuSDVqjlMAcse8bzCjOqoSNqG9Kk4xb3bK3F9iD58tTBWE6rJXZR+kaAYjPjXkG7D/7x+uFF0T3b/G39lFXhNhJtC5OSNk5qaIsJPR9a8UX2gfH3o/7pavkBAPWXuo2VKoDiRtZQCed5CTS/Cu1tvSMHI4WKij34fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548059; c=relaxed/simple;
	bh=H8fNHJC+rmHUwlMZKM/2xasJ0KE+azG82AQ1uw6GeDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ffc5gPQKIZuwzdt5p5Knr7t+1sS3rIdFHpVD5zGrPw+vUz/7GAO27aHkyo/1XlfV0ZvzJ/7zgDamO3NyCY7c8Q6EXxUCOLpBFxuHvuS2vI+HwZvnkH4wZW0Bmy+XcIAYyzGPjpb/HeJ8QmeBi3UOMs7v3w0JpENGRHc5w7BotzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XjQbqNwn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XjQbqNwn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E24BC433C7;
	Mon, 29 Jan 2024 17:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548059;
	bh=H8fNHJC+rmHUwlMZKM/2xasJ0KE+azG82AQ1uw6GeDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XjQbqNwnVp+7ahon9ngRMBk5RTeMY3utjHvdR6f36ElrGS2Xk7eprYDCSEl4qPxwL
	 liBlL7YWV2yvigNafqRK9zkN4rlHkzv7OF0F8mhmcDeHdxYpaInufXu19XlmhWcV4M
	 hWRrK1uCwvdny8H1k0JuL2cudNAmW608jEWy9dhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlie Jenkins <charlie@rivosinc.com>,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Julia Lawall <julia.lawall@inria.fr>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 056/346] riscv: Fix module loading free order
Date: Mon, 29 Jan 2024 09:01:27 -0800
Message-ID: <20240129170018.043387164@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charlie Jenkins <charlie@rivosinc.com>

[ Upstream commit 78996eee79ebdfe8b6f0e54cb6dcc792d5129291 ]

Reverse order of kfree calls to resolve use-after-free error.

Signed-off-by: Charlie Jenkins <charlie@rivosinc.com>
Fixes: d8792a5734b0 ("riscv: Safely remove entries from relocation list")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/r/202312132019.iYGTwW0L-lkp@intel.com/
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Julia Lawall <julia.lawall@inria.fr>
Closes: https://lore.kernel.org/r/202312120044.wTI1Uyaa-lkp@intel.com/
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/20240104-module_loading_fix-v3-1-a71f8de6ce0f@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/module.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/module.c b/arch/riscv/kernel/module.c
index 862834bb1d64..5cf3a693482d 100644
--- a/arch/riscv/kernel/module.c
+++ b/arch/riscv/kernel/module.c
@@ -723,8 +723,8 @@ static int add_relocation_to_accumulate(struct module *me, int type,
 
 			if (!bucket) {
 				kfree(entry);
-				kfree(rel_head);
 				kfree(rel_head->rel_entry);
+				kfree(rel_head);
 				return -ENOMEM;
 			}
 
-- 
2.43.0



