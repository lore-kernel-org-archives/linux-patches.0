Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42C9C1A76A5;
	Mon, 14 Oct 2024 15:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918629; cv=none; b=UMYozhtUZOYYPueWfFg8ztZN8aduTHkbmR7aIL9LRKsFyCOIfdjZIGICAntmSI8lJxxhDyiW93Yl+nsm0d7tIl/7AByLi9+vqdzbFY+umrolTjzdYiDT1P0jNH0DpVKNactd6Dg1kBTdtHPlalM4oDSNEDIYxyYhTfJZxzm5CrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918629; c=relaxed/simple;
	bh=08LqgoMGhEdf7NgOESEXf4q2BSXc0j79lqvvXvYdagI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nO56TSsZ9AIhw8yaZdQm215jN/BRClc66NuLSbLEGSYALlp952s1RY6U7PPsuSEkk7PZ5bRubkzZHl9cPaK+AoBNLGbNqiuFKRxCWGr8WNR4AwslPgQsBI8D/crCscZQzsfsfV6a8zxQYhxwEnCmnZYYZ+iJpiiPi2IMgZXPN98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FgXFHQ6Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FgXFHQ6Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A69D3C4CEC3;
	Mon, 14 Oct 2024 15:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918629;
	bh=08LqgoMGhEdf7NgOESEXf4q2BSXc0j79lqvvXvYdagI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FgXFHQ6YOxWLiXe7DOIKrXLI38VXkEaGj3vo8ttt/M4C//++I5tf2L9/1DmejEHit
	 P1fF+rqPAivwcrl1FPWm03S1hD5GscGXR8zlhGOFOMEJ3e4Xarr/yDi0YMRjiS3wOG
	 5+QSNwQsS4DdprIbDY1mV16MqTpd7/paEA6aesAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 377/798] static_call: Handle module init failure correctly in static_call_del_module()
Date: Mon, 14 Oct 2024 16:15:31 +0200
Message-ID: <20241014141232.764443548@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 4b30051c4864234ec57290c3d142db7c88f10d8a ]

Module insertion invokes static_call_add_module() to initialize the static
calls in a module. static_call_add_module() invokes __static_call_init(),
which allocates a struct static_call_mod to either encapsulate the built-in
static call sites of the associated key into it so further modules can be
added or to append the module to the module chain.

If that allocation fails the function returns with an error code and the
module core invokes static_call_del_module() to clean up eventually added
static_call_mod entries.

This works correctly, when all keys used by the module were converted over
to a module chain before the failure. If not then static_call_del_module()
causes a #GP as it blindly assumes that key::mods points to a valid struct
static_call_mod.

The problem is that key::mods is not a individual struct member of struct
static_call_key, it's part of a union to save space:

        union {
                /* bit 0: 0 = mods, 1 = sites */
                unsigned long type;
                struct static_call_mod *mods;
                struct static_call_site *sites;
	};

key::sites is a pointer to the list of built-in usage sites of the static
call. The type of the pointer is differentiated by bit 0. A mods pointer
has the bit clear, the sites pointer has the bit set.

As static_call_del_module() blidly assumes that the pointer is a valid
static_call_mod type, it fails to check for this failure case and
dereferences the pointer to the list of built-in call sites, which is
obviously bogus.

Cure it by checking whether the key has a sites or a mods pointer.

If it's a sites pointer then the key is not to be touched. As the sites are
walked in the same order as in __static_call_init() the site walk can be
terminated because all subsequent sites have not been touched by the init
code due to the error exit.

If it was converted before the allocation fail, then the inner loop which
searches for a module match will find nothing.

A fail in the second allocation in __static_call_init() is harmless and
does not require special treatment. The first allocation succeeded and
converted the key to a module chain. That first entry has mod::mod == NULL
and mod::next == NULL, so the inner loop of static_call_del_module() will
neither find a module match nor a module chain. The next site in the walk
was either already converted, but can't match the module, or it will exit
the outer loop because it has a static_call_site pointer and not a
static_call_mod pointer.

Fixes: 9183c3f9ed71 ("static_call: Add inline static call infrastructure")
Closes: https://lore.kernel.org/all/20230915082126.4187913-1-ruanjinjie@huawei.com
Reported-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Jinjie Ruan <ruanjinjie@huawei.com>
Link: https://lore.kernel.org/r/87zfon6b0s.ffs@tglx
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/static_call_inline.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/kernel/static_call_inline.c b/kernel/static_call_inline.c
index dc5665b628140..075194d9cbf5b 100644
--- a/kernel/static_call_inline.c
+++ b/kernel/static_call_inline.c
@@ -400,6 +400,17 @@ static void static_call_del_module(struct module *mod)
 
 	for (site = start; site < stop; site++) {
 		key = static_call_key(site);
+
+		/*
+		 * If the key was not updated due to a memory allocation
+		 * failure in __static_call_init() then treating key::sites
+		 * as key::mods in the code below would cause random memory
+		 * access and #GP. In that case all subsequent sites have
+		 * not been touched either, so stop iterating.
+		 */
+		if (!static_call_key_has_mods(key))
+			break;
+
 		if (key == prev_key)
 			continue;
 
-- 
2.43.0



