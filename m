Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D97852222B6;
	Mon,  2 Jun 2025 14:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873209; cv=none; b=sorgR+0dpIyZEC1I4oFgLqIQAxZSoQBVI9Ck9RoiGNhK0z2hJXBqexbWJFtZMNwkkS1jmdrrB8QPMFHjzQJa6WAc2BuvVAqScu3pR/SPDLARvNPFqSY+hm0jbfqUDb5ppfThTvPS3UfreEQBh3AZWbflGwY3E41I5w4aX9ZYJ+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873209; c=relaxed/simple;
	bh=ZLHzcl93aexg0ZS96XyUhERacvm5ek+7GjpA8UMvSIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZBk/iZT4WnWQRH3EGwRYUIjqYQxFeORzChf9heQXilDfEGcnaK/Ouy0j2E6mdiKxjZetqZ3uCE+ChtvYzeMaWCfDIvNKaHz/lgbkwFRzRbz4JVlTsMck8ATHeA78ZQNKNucn/kjRJ96lJsIZ3ESKILLViZhSXdMqyUs6oZDUCnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QsTGZAxv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QsTGZAxv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BC97C4CEEB;
	Mon,  2 Jun 2025 14:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873209;
	bh=ZLHzcl93aexg0ZS96XyUhERacvm5ek+7GjpA8UMvSIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QsTGZAxv8NL3BmXarW8D2IAW5iXhE3UzYL4oymyGI44yaSSJqAx4atb7DrRyVfejQ
	 VEMrA2JFmm4FtPmtKkD6dH62YpN/BW7qV+49POColRdkiaf8rq8R1p+05Ulhjhr9j9
	 NeWJmr9jC6Bb4lNhFgZkyQ9wovEN1CPXFW/3MgjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ingo Molnar <mingo@kernel.org>,
	Brian Gerst <brgerst@gmail.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Uros Bizjak <ubizjak@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 071/444] x86/stackprotector/64: Only export __ref_stack_chk_guard on CONFIG_SMP
Date: Mon,  2 Jun 2025 15:42:15 +0200
Message-ID: <20250602134343.793740591@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ingo Molnar <mingo@kernel.org>

[ Upstream commit 91d5451d97ce35cbd510277fa3b7abf9caa4e34d ]

The __ref_stack_chk_guard symbol doesn't exist on UP:

  <stdin>:4:15: error: ‘__ref_stack_chk_guard’ undeclared here (not in a function)

Fix the #ifdef around the entry.S export.

Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Uros Bizjak <ubizjak@gmail.com>
Link: https://lore.kernel.org/r/20250123190747.745588-8-brgerst@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/entry/entry.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/entry/entry.S b/arch/x86/entry/entry.S
index 78fd2442b49dc..ad292c0d971a3 100644
--- a/arch/x86/entry/entry.S
+++ b/arch/x86/entry/entry.S
@@ -59,7 +59,7 @@ EXPORT_SYMBOL_GPL(mds_verw_sel);
  * entirely in the C code, and use an alias emitted by the linker script
  * instead.
  */
-#ifdef CONFIG_STACKPROTECTOR
+#if defined(CONFIG_STACKPROTECTOR) && defined(CONFIG_SMP)
 EXPORT_SYMBOL(__ref_stack_chk_guard);
 #endif
 #endif
-- 
2.39.5



