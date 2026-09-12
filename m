Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949944078E8;
	Sat, 12 Sep 2026 08:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203047; cv=none; b=l91zPOTFTmIqkAqe7qOPeEx5FiaCPsqLDst1P7eNavtAoAsYHmsUbF+jsz+T+ZV9+HJFlz4xeW9eFYo9EiaU2xJJ/O9qj2Y1WSUlaQ3Umy8eMvA7h/Rv3c2pTBBbW/X5vtrWqwg7a7da/wtpo321GQoaxbb8bZ1iQfb8/n4JRTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203047; c=relaxed/simple;
	bh=ELzW81aPjejolsK84KT9TUWPFESbaxgAgw2JWIqbQ38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VYM/ABD/1VCs5IoH+dQtdQ0dQVCmRcY00QVx94vXA+CVu6PO/ipXfe036hkwuO5DnyZiwXn8OE3YYw4ZE5mkKIO3xbrPQkK/VSVymc/pEkXz89j5zJmsPJrm+dwybBJE+kHksm2hN+Jc1WDxoC/DErmAj/OSt2QpVVTk5a8mWh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IWYc2fzb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IWYc2fzb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04C841F00899;
	Sat, 12 Sep 2026 08:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203044;
	bh=QOFwzm9edeqHfIEOfVtcjn/TFgby0OM6rR6R8Gw4tMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IWYc2fzbRyB2GbzUXMGIG56h+zpCZIorr6/LttsV9bBk6MFHklfONiHEZ/ijNmxrD
	 g2vFGAy0CBCcWAHSjtI8fS3aqyA7z4whfDqMzCkguH8pl+8357PNquNNona5KjgSZz
	 wJPrGdVbrZ6F9N7gmqmhChnrQe55JSxOukLkWu10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabrice Derepas <fabrice.derepas@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1285/1815] apparmor: fix integer overflow in verify_tags() bounds check
Date: Sat, 12 Sep 2026 08:50:35 +0200
Message-ID: <20260912065719.181463885@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabrice Derepas <fabrice.derepas@canonical.com>

[ Upstream commit 465946d3c560c0137e6a180ba054dddc4d049f5a ]

verify_tags() validates the tagset table unpacked from a policy blob.
For each set it reads a count and checks that advancing the index by
that count stays inside sets.table[]:

	u32 cnt = tags->sets.table[i];

	if (i+cnt >= tags->sets.size) {

i, cnt and sets.size are all u32, so i+cnt is evaluated modulo 2^32.
sets.table[] is filled by unpack_tagsets() with aa_unpack_u32(), so
every entry is a raw unbounded 32-bit word taken from the policy blob,
and verify_tags() is the function that is supposed to validate it.  A
count close to U32_MAX makes the sum wrap to a small value, the guard
passes, and the inner loop then walks sets.table[++i] past the end of
the kcalloc(size, sizeof(u32)) allocation.

Note that sets.size is bounded by 65535, because unpack_tagsets() reads
it with aa_unpack_array() as a u16, so the wrap cannot be reached by
growing the table; it is reached purely through the attacker-supplied
count.

With sets.size = 2 and sets.table = { 0, 0xffffffff }:

  i = 0: cnt = 0, guard 0 + 0 >= 2 is false, inner loop does not run
  i = 1: cnt = 0xffffffff, guard (1 + 0xffffffff) mod 2^32 == 0 >= 2 is
         false, so the guard is bypassed and the inner loop reads
         sets.table[2] -- one element past a two element allocation

The walk continues until an out-of-bounds value happens to be >=
hdrs.size or the access faults, so a crafted policy yields an
out-of-bounds read on the policy load path
(aa_replace_profiles -> aa_unpack -> unpack_policydb -> unpack_tags ->
verify_tags).  unpack_tags() runs before the perms and DFA tables are
unpacked, so no other table needs to be well formed to reach it.

Policy load is gated by aa_may_manage_policy(), which checks
CAP_MAC_ADMIN relative to the subject's own user namespace rather than
the init user namespace, so with the default
unprivileged_userns_apparmor_policy=1 the path is reachable from an
unprivileged task in a matched-level nested namespace, not only by a
globally privileged one.

Perform the addition in u64 so that it cannot wrap, restoring the
intended i + cnt < sets.size guarantee.

Fixes: 3d28e2397af7 ("apparmor: add support loading per permission tagging")
Signed-off-by: Fabrice Derepas <fabrice.derepas@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/policy_unpack.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/apparmor/policy_unpack.c b/security/apparmor/policy_unpack.c
index d9dcff167c480..15b5e9270c0fa 100644
--- a/security/apparmor/policy_unpack.c
+++ b/security/apparmor/policy_unpack.c
@@ -730,7 +730,7 @@ static bool verify_tags(struct aa_tags_struct *tags, const char **info)
 		/* count followed by count indexes into hdrs */
 		u32 cnt = tags->sets.table[i];
 
-		if (i+cnt >= tags->sets.size) {
+		if ((u64)i + cnt >= tags->sets.size) {
 			AA_DEBUG(DEBUG_UNPACK,
 				 "tagset too large %d+%d > sets.table[%d]",
 				 i, cnt, tags->sets.size);
-- 
2.53.0



