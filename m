Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15AFA2561AE;
	Tue, 15 Jul 2025 13:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586754; cv=none; b=HCe0bkdY5kFXrBzAnpnVqPH6Bt94Q8saadBj1l5CezjWuRIALlXdzrRt7of+59vhJbeFhIk+DDmrTweG1Edp7L36/3qvX+4EK69EtAI5r3bhggoYvFZPgSzqKdlcyx8Mfky5SLPy89oFz56RF5K87DE2RYHuQ5s6Z+6fPKsJljg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586754; c=relaxed/simple;
	bh=bjB5TloB9pmY+wGxm+VNMinRJMHynef/qQdtKIdSA44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lVamdBgh4Vx3/F918QID9zOzavD4w3h2r6nkYlRewMOnYeR4E6ihjsIXJ7TEhIK9ZrE71MbaYxEUq5C6o+94kISJAityPAgYm5dI/ayX7OvXGznPVMLhHD6A7HrccyxguERQ/ldspAAGtl/SBqqv8PMMnGGaOFe1jcWSy8+tikg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j3IO3gCl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j3IO3gCl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A07A3C4CEE3;
	Tue, 15 Jul 2025 13:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586754;
	bh=bjB5TloB9pmY+wGxm+VNMinRJMHynef/qQdtKIdSA44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j3IO3gClNscMM8IrSziAY+kkWs/X9RnyGg9tCU7vTq1xrA7xkvcQPSVpMBNMHVHRv
	 8aj0g6czJGd3QKbogfTq49Fp5bZooczmymyuSr7zJNwWjelG2Y7lRED0KQGDQ1bqBc
	 tdTcQfxulf1NBwLV2ey+SUmDeepyPFtKkF19XSi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Daniel Gomez <da.gomez@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 036/192] module: Fix memory deallocation on error path in move_module()
Date: Tue, 15 Jul 2025 15:12:11 +0200
Message-ID: <20250715130816.305559220@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Pavlu <petr.pavlu@suse.com>

[ Upstream commit ca3881f6fd8e9b6eb2d51e8718d07d3b8029d886 ]

The function move_module() uses the variable t to track how many memory
types it has allocated and consequently how many should be freed if an
error occurs.

The variable is initially set to 0 and is updated when a call to
module_memory_alloc() fails. However, move_module() can fail for other
reasons as well, in which case t remains set to 0 and no memory is freed.

Fix the problem by initializing t to MOD_MEM_NUM_TYPES. Additionally, make
the deallocation loop more robust by not relying on the mod_mem_type_t enum
having a signed integer as its underlying type.

Fixes: c7ee8aebf6c0 ("module: add stop-grap sanity check on module memcpy()")
Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Daniel Gomez <da.gomez@samsung.com>
Link: https://lore.kernel.org/r/20250618122730.51324-2-petr.pavlu@suse.com
Signed-off-by: Daniel Gomez <da.gomez@samsung.com>
Message-ID: <20250618122730.51324-2-petr.pavlu@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/module/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/module/main.c b/kernel/module/main.c
index 9861c2ac5fd50..9d8a845d94665 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -2615,7 +2615,7 @@ static int find_module_sections(struct module *mod, struct load_info *info)
 static int move_module(struct module *mod, struct load_info *info)
 {
 	int i;
-	enum mod_mem_type t = 0;
+	enum mod_mem_type t = MOD_MEM_NUM_TYPES;
 	int ret = -ENOMEM;
 	bool codetag_section_found = false;
 
@@ -2694,7 +2694,7 @@ static int move_module(struct module *mod, struct load_info *info)
 	return 0;
 out_err:
 	module_memory_restore_rox(mod);
-	for (t--; t >= 0; t--)
+	while (t--)
 		module_memory_free(mod, t);
 	if (codetag_section_found)
 		codetag_free_module_sections(mod);
-- 
2.39.5



