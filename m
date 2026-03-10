Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34A83803CD;
	Tue, 10 Mar 2026 11:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142124; cv=none; b=iW8QcTSvOz9zIz/TRKg2LryHRuB8mO3PVupC6uD3TriMRk6wWL8KeVl7hH/6vYqYl4uMhKHvQlOr+tg9hgH/efuLjGapNLN7rKtDfQIHGw6UEyYosFIEdovpJXN+ck76qQ9W5dRHepMb6CPaS9o/eeDderK2kCol939/+Mjw3Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142124; c=relaxed/simple;
	bh=MyzS/2zTiVyH9c9PXpwu97i2vPpRZVKak8wrrWH96rc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TwUYvYw8rq4BJGr/PTpb33I43TEB6abiA8iedkBhCugtKKv12Swf4zRkvuBNdyvJu/gPY12Ov9N9GBvtYVoohsZHBc2XThfMnmpAtzZL00EfpAr06jIG19zgolNcWWVGaklhajoIseIa9BamSrc/LRMKspQFcw6LY6XhiA9mRy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=apih8iR5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="apih8iR5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E520CC2BC9E;
	Tue, 10 Mar 2026 11:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142123;
	bh=MyzS/2zTiVyH9c9PXpwu97i2vPpRZVKak8wrrWH96rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=apih8iR5dD1vPeRfzwnR3bXRL8jqapgIAozuJide32UNVbjhsaiXIczVQv1rrI/gL
	 yDhiZ6JK+seINnacr58PaRgMkcHhQx0nogNsJvwM345cuta6y/972eGB4HV39M1qLx
	 NUlFr6bE3lx2V47p+42YxrrQuH4puyYHNiw84Ylxu78T3sdOxAg7aqfAHoaebG0pKe
	 SJx1CocyYJeQOESrCFlFpZXhfmfwpEjY7MM1oCZnUFM3vpVntBwntLh2AhAHd8zguH
	 qAHgfMi2OASCcxXFonBT9pc2SqOfE6GqJ9RffvfDnLP0crl1ZVLkwWueFShZZDKlER
	 Fx+wzphfiAYhw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@samsung.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Song Liu <song@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 212/314] module: Remove duplicate freeing of lockdep classes
Date: Tue, 10 Mar 2026 07:17:51 -0400
Message-ID: <032a420535316c9dfa1e4b268e287d3ff2ac14db.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Petr Pavlu <petr.pavlu@suse.com>

[ Upstream commit a7b4bc094fbaa7dc7b7b91ae33549bbd7eefaac1 ]

In the error path of load_module(), under the free_module label, the
code calls lockdep_free_key_range() to release lock classes associated
with the MOD_DATA, MOD_RODATA and MOD_RO_AFTER_INIT module regions, and
subsequently invokes module_deallocate().

Since commit ac3b43283923 ("module: replace module_layout with
module_memory"), the module_deallocate() function calls free_mod_mem(),
which releases the lock classes as well and considers all module
regions.

Attempting to free these classes twice is unnecessary. Remove the
redundant code in load_module().

Fixes: ac3b43283923 ("module: replace module_layout with module_memory")
Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
Reviewed-by: Daniel Gomez <da.gomez@samsung.com>
Reviewed-by: Aaron Tomlin <atomlin@atomlin.com>
Acked-by: Song Liu <song@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/module/main.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/kernel/module/main.c b/kernel/module/main.c
index c66b261849362..a2c798d06e3f5 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -3544,12 +3544,6 @@ static int load_module(struct load_info *info, const char __user *uargs,
 	mutex_unlock(&module_mutex);
  free_module:
 	mod_stat_bump_invalid(info, flags);
-	/* Free lock-classes; relies on the preceding sync_rcu() */
-	for_class_mod_mem_type(type, core_data) {
-		lockdep_free_key_range(mod->mem[type].base,
-				       mod->mem[type].size);
-	}
-
 	module_memory_restore_rox(mod);
 	module_deallocate(mod, info);
  free_copy:
-- 
2.51.0

