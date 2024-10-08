Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 857B21DE885;
	Tue,  8 Oct 2024 12:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389488; cv=none; b=NiGSZN3VFxfzIfwD3egdkab0xkm0Q8g+cRuTXOoaZ57hpgdoRB+9B6hV39c6llExCr5gk+6gd7+Iplvz/9gw83BhWpnwHxXWBm6eq+zV4lGs1xZdGhi40r9Zb8e6jQMB7jrDV7O8zFxCvDFGumeb+EfYJmrQ83TE8yrmWcrOlts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389488; c=relaxed/simple;
	bh=t9qAE7FxVf6VIHY+hu1qKwE4vSSKyYK0pwF9leqyfTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sOkS3pwLWK4cX3R40LH8lyyyn3Lvj7m7sWIHpboknL29UBwL0ONVfKB8+rK/B6GsG/8+mhqA8EYCrzvU/f2rOfKT3vG21TOfSN3ZywSmK7/dRReopU0l+6Vd7JAwk6g1mqKQPUkJcnLWGTBCoVsfzd3Nuh2cmB+Kut81f3Mm3uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gjTFht0f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gjTFht0f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E4AFC4CECD;
	Tue,  8 Oct 2024 12:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389488;
	bh=t9qAE7FxVf6VIHY+hu1qKwE4vSSKyYK0pwF9leqyfTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gjTFht0fAvzuyNRWSuRPBdpndWUQgY8dZavfWjxwvZc6XPSm/kl43MbroMD6zObsH
	 EDXrNKb0xOIohcx45hJPH09Sdfg0moIbM2UOvhjKJcgANJYBdeR7dscH6CU3IiOeVq
	 5JS6DTEWfSnyq4dVwK3xS3ocn1rQmxk1vYSw5Gd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 001/482] static_call: Handle module init failure correctly in static_call_del_module()
Date: Tue,  8 Oct 2024 14:01:04 +0200
Message-ID: <20241008115648.348265383@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 639397b5491ca..7bb0962b52291 100644
--- a/kernel/static_call_inline.c
+++ b/kernel/static_call_inline.c
@@ -411,6 +411,17 @@ static void static_call_del_module(struct module *mod)
 
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



