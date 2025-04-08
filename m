Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14BCB26B2C0;
	Tue,  8 Apr 2025 12:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114076; cv=none; b=ooith4IKqGZdhdhL2056/kuW0edkXdhEo27FRuWFLE3Ian+RJR654j7PQLTafI5XBJdzrkYZMiTl/BdJfq9Tu4uVz0W8BoE6RgOLG9FRKnkkCYRyE5zRKJFy3mur4FWeyRok53KDQhMJltaec/SQHJE4woKrEC9rtn9MOP9X54s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114076; c=relaxed/simple;
	bh=UU5gzc+7Lf5aoIdqwhDRuowtJ4ABN91c2j557tUrGqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JBpDNUSZcmwxoHO2gogY/Aj/zSGbUJKkIVkZWxsWn/Womdc+fW12a72gpENS47oTMN0wSZrlCN+pj+AviXmesGQqw/DzsDxyn51ZgzIDc+Ir2uic6W2TwysbflW/6urO4UbYld7+hb7yvjOXJ4X1Kyg8RClqwpvY4s/opdWkDzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wxuyIxWZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wxuyIxWZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9501FC4CEE7;
	Tue,  8 Apr 2025 12:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114075;
	bh=UU5gzc+7Lf5aoIdqwhDRuowtJ4ABN91c2j557tUrGqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wxuyIxWZ1/4iWFOzIYOZ88pKIwDqbJzx19BeP123GhrC6ay/kkx/+X/laA4UNdLvo
	 KKWsqYhwufYJ0BiZjDd0aCmtjwnXB79D//2E3RiTHTYoH4UuMJNN/na14SH1U8o99+
	 rc+tHpI68xzFIvmF/UnJGRelZeMpITuaUE19I22k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 128/154] sched/smt: Always inline sched_smt_active()
Date: Tue,  8 Apr 2025 12:51:09 +0200
Message-ID: <20250408104819.411805759@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit 09f37f2d7b21ff35b8b533f9ab8cfad2fe8f72f6 ]

sched_smt_active() can be called from noinstr code, so it should always
be inlined.  The CONFIG_SCHED_SMT version already has __always_inline.
Do the same for its !CONFIG_SCHED_SMT counterpart.

Fixes the following warning:

  vmlinux.o: error: objtool: intel_idle_ibrs+0x13: call to sched_smt_active() leaves .noinstr.text section

Fixes: 321a874a7ef8 ("sched/smt: Expose sched_smt_present static key")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/1d03907b0a247cf7fb5c1d518de378864f603060.1743481539.git.jpoimboe@kernel.org
Closes: https://lore.kernel.org/r/202503311434.lyw2Tveh-lkp@intel.com/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched/smt.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/sched/smt.h b/include/linux/sched/smt.h
index 59d3736c454cf..737b50f40137b 100644
--- a/include/linux/sched/smt.h
+++ b/include/linux/sched/smt.h
@@ -12,7 +12,7 @@ static __always_inline bool sched_smt_active(void)
 	return static_branch_likely(&sched_smt_present);
 }
 #else
-static inline bool sched_smt_active(void) { return false; }
+static __always_inline bool sched_smt_active(void) { return false; }
 #endif
 
 void arch_smt_update(void);
-- 
2.39.5



