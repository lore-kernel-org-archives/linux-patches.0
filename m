Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678A63AFD15;
	Sat, 12 Sep 2026 09:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206619; cv=none; b=KnEAWZ+beNqhKvE05FJfjT2KJqfeOSIZeKPjG05IhLK4kSkwfPNakjPCSIAX+rauPr4tpK9z8QknecyOPVHy+OEigcNpw5u9KARbdslalWQLAJeVZ/uUfUBwWSnoVvFdx2UA8zXUPugRU5LYiEK9xcmBeSg5YQyWH/1TO+pKCrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206619; c=relaxed/simple;
	bh=8PA8YP8zQxdce4J6BZnlmDnirv3svMgjxDlXnzpYD3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jiTUx2m5hZ3//e3RlrAHCTLc+OqrsrJAVqaPOnvvjMkKtIZE2AjYakAOj1zWtyEskbTRarudmidBugVf1+r9vIadT9+jfqgQ8r/kO3jDTVGspKcx4IxvUNu4OE1sPjf8oh/cFFYFx06SqTmCHHfauQ+oPMzUDbIclrcK7pozSuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hTSZ7n4R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hTSZ7n4R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E88E1F000FF;
	Sat, 12 Sep 2026 09:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206618;
	bh=crk7bY8dYk3iUtAFGaE9X/IwLmsEu0ETEuS93KXrdh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hTSZ7n4RNizFAUnOgR67OS6kz29zFyKBeBfVqRM5fUJ1WoYD8p5botajTYdD3gyjt
	 iMuokxNfHuUOEoD52JCeqKaEA9+XBjNzeGKauL6guytWPVoledxL+pQDglO7Gms5ln
	 7cjD8KqSZSbUCPCJuFW6sfTa1RyRSph3bp4txix0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Malaya Kumar Rout <malayarout91@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0245/1518] timers/migration: Fix memory leak in tmigr_setup_groups() error path
Date: Sat, 12 Sep 2026 08:40:14 +0200
Message-ID: <20260912065629.023167876@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Malaya Kumar Rout <malayarout91@gmail.com>

[ Upstream commit eddfded4196542deda7cb2da3d7ebef83f7ccfa4 ]

When the WARN_ON_ONCE(i >= tmigr_hierarchy_levels) assertion triggers,
the function returns -EINVAL without freeing the 'stack' memory allocated
via kzalloc_objs() at the beginning of the function.

Add kfree(stack) before returning to prevent the memory leak.

Fixes: 6c181b5667ee ("timers/migration: Convert "while" loops to use "for"")
Signed-off-by: Malaya Kumar Rout <malayarout91@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260704085533.87098-1-malayarout91@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/timer_migration.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/time/timer_migration.c b/kernel/time/timer_migration.c
index 76d896a99d7b0..32f338052bc4f 100644
--- a/kernel/time/timer_migration.c
+++ b/kernel/time/timer_migration.c
@@ -1667,8 +1667,10 @@ static int tmigr_setup_groups(unsigned int cpu, unsigned int node,
 	}
 
 	/* Assert single root without parent */
-	if (WARN_ON_ONCE(i >= tmigr_hierarchy_levels))
+	if (WARN_ON_ONCE(i >= tmigr_hierarchy_levels)) {
+		kfree(stack);
 		return -EINVAL;
+	}
 
 	for (; i >= start_lvl; i--) {
 		group = stack[i];
-- 
2.53.0



