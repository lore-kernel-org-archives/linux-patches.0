Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E78386425;
	Tue, 10 Mar 2026 11:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141184; cv=none; b=FDi0PTISS3XPUIRutbOsdtoJy5WdJ7BxgjT4sTH3Z+NFC7B8/CKQLxfQGL/Lwk9OCSSS/Hvt59ksylxZs36moPEv580JmHoSGkZUXupY9zZqYLCOt01RxgsKXFaQW5whIuIOE1lrYQpWFi8b2htFQw9weSTpmwot4NUSYDdG1ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141184; c=relaxed/simple;
	bh=Tyz4uX2BYc/dvn5UGTpYuJz3ahxS/N6IYyZtieIovG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AKJCZzRUdSIVBCvybjD4fQq+hT/WdaN7aDq1WuvhKsrhQI9bMzKzvtOWgNYHNq4zlsGaWjDT2MwadPCUbwlqalMeIqPGHXibYjWlNbGvG6LaOeK0PAPJV0Ld/F+gED8Mb7dhD4M6cJbj5llpVHjor48rkVe0bBfNw4I72wdAZWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LoW6nuUJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LoW6nuUJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2977DC2BC86;
	Tue, 10 Mar 2026 11:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141184;
	bh=Tyz4uX2BYc/dvn5UGTpYuJz3ahxS/N6IYyZtieIovG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LoW6nuUJtLiCYk1JYJgOdeVkdDS5SoAZ6VyuPU4Q4ukaTaViT8QbK4R2XbsL8Wg8K
	 2x5q3cooSk9LousNnX16/jBZbOGZRFV8yzPZ9C/Sq1gcyMbuWmyiEX6fS96KLaemdK
	 TNXiX8GIxB3+mb9OJxkam3YgIW7k3jtJIjHly/Zp44HbCakSowj82zQ4j82twUaa9F
	 Ksh9OSgbGCEpie0aqqeVUZb2EQVc8lRwSAbPjlrYgGBwzjCbR91D9GzLeqvbBAwhPq
	 jK9GBXmjqmBMuVuH7nEWVmH36jRAGiHKQfVj+EjjYflRnmjxDJAi24WVddFSp5hn3Y
	 F28kKb1NjRblg==
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
Subject: [PATCH 6.19 185/311] module: Remove duplicate freeing of lockdep classes
Date: Tue, 10 Mar 2026 07:03:52 -0400
Message-ID: <4585ee419eb109cb51b331e7cd0ad5295101bd7a.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
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
index 710ee30b3beab..bcd259505c8b3 100644
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

