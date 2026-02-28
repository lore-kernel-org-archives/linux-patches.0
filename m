Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E58FC35BDBC
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300910; cv=none; b=C1b1QwNeLRkygpX06Yy+QI4UIjPBt5TGJ3KGsT0GAVALJjVK2yrfJfJz2TVA4txeERXVCin4/InjaCGNeDTVE0R9guKmELxR3rZK30hDYF/KlR6W1TwRj9+XQvqZ2gZnxe5YQDYOShfgaFmfpSJmc96O1nQ6ObEFX9wexCmg1Z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300910; c=relaxed/simple;
	bh=EY/BGeOOCFFP9d7pnNT8svYATTIHoqhTE4sX02nGVNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iTQcvQ8dhk7Qn1Pl1+Lb67ixU2MpGp1mn/K0C0ghuM4p47UsVmqWDWGv9/kEict1aW6HVrQ/qIvGSXEjM0dcOVYNrH1V+C/s6hkg1uqdAYjId5UQDy7oxW5WbTczW7Jo2/4gjqkEwkXRK19/6jO7L0KglavPDG7b4mmCqFXGY7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jnuJ0M7G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jnuJ0M7G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54A2FC19424;
	Sat, 28 Feb 2026 17:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300909;
	bh=EY/BGeOOCFFP9d7pnNT8svYATTIHoqhTE4sX02nGVNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jnuJ0M7G8T06v7wG17bOW87rNaKaUNegExyivkPLwprIULZ/avnA/3YfucHiw2Jlw
	 /37ClW8Jhz6CwcJKiRJQ0IapPKISDbbu5XLaM/UhLpCcPUZNRcykdvFrvz+BMg8Lr4
	 JpTbKBlVP/KEgUtzrnBPdEWKBHIt2sNvMcUP1NZVjawoG/+0qnVM+8eylqZ5Iz3gT/
	 D/mwZaB6L/WkjC6c2ALAaqCdKsU3ZGD6vU+pb3J45ATyhbTXSEbtnG6nAi4iuB+Ltl
	 Edzd8VqcACwuyH/91pG/LqawV2wKv8kTxMVId9HGMiC2p3CPVEVkkNXQ0V6cMewR6a
	 uQ681Hf2m3Fdg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jeffrey Bencteux <jeff@bencteux.fr>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 024/752] audit: add fchmodat2() to change attributes class
Date: Sat, 28 Feb 2026 12:35:35 -0500
Message-ID: <20260228174750.1542406-24-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jeffrey Bencteux <jeff@bencteux.fr>

[ Upstream commit 4f493a6079b588cf1f04ce5ed6cdad45ab0d53dc ]

fchmodat2(), introduced in version 6.6 is currently not in the change
attribute class of audit. Calling fchmodat2() to change a file
attribute in the same fashion than chmod() or fchmodat() will bypass
audit rules such as:

-w /tmp/test -p rwa -k test_rwa

The current patch adds fchmodat2() to the change attributes class.

Signed-off-by: Jeffrey Bencteux <jeff@bencteux.fr>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/asm-generic/audit_change_attr.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/asm-generic/audit_change_attr.h b/include/asm-generic/audit_change_attr.h
index cc840537885fb..ddd90bbe40dfc 100644
--- a/include/asm-generic/audit_change_attr.h
+++ b/include/asm-generic/audit_change_attr.h
@@ -26,6 +26,9 @@ __NR_fremovexattr,
 __NR_fchownat,
 __NR_fchmodat,
 #endif
+#ifdef __NR_fchmodat2
+__NR_fchmodat2,
+#endif
 #ifdef __NR_chown32
 __NR_chown32,
 __NR_fchown32,
-- 
2.51.0

