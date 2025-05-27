Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7462027FD7F;
	Tue, 27 May 2025 16:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364605; cv=none; b=dyARPN/atEUroGGjlGyHkwehpVBo1Y9GJ+IcM52rjau74+QRM0AlZsbo91sVPXH41TUbX7MZWKuK8UlIokRixcN3p7Nv8DztD1D43omT5icVsoc7XgLCjHZyQAVm4sRH/brwETCpH+614UxunUIpdNEkWyCF/xHNDVVRl7jS3IM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364605; c=relaxed/simple;
	bh=wTJJGUhD/mrtpUb+FbE7hINK7nwMQJEVZUfG5fx883E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jBm3EPVh45hHWCXoT/uKqppuoUmpcHT/PDTasLIe1OJ10itQbRJJpyallcqosYtqWX7Yb/YqATkpEbCnvj1cVaHdsqsvRVaxH0TZ290y6tcffZ/6srjRjp5KWs7AhjFxLLdRMzL2qyG5ayCl14zeQpEofpI1Ul51AoisUz3W9jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nn6itlJu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nn6itlJu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02997C4CEE9;
	Tue, 27 May 2025 16:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364605;
	bh=wTJJGUhD/mrtpUb+FbE7hINK7nwMQJEVZUfG5fx883E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nn6itlJuQusHKRfU7v+MBIMl54KhXYMnH2PI6nLm3op1k3BXmyc91YRZb7GV8nhSG
	 3Tu/87qfTvDkXhh2UCN8jgV3NdzJrP/bBHW0xWg9ne5h27i+VOXmZ9va6VkW75JFnl
	 kosE8XE3cgp4JGGKpi/LFQtPBzC5eKKsK+42F4wM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ingo Molnar <mingo@kernel.org>,
	Brian Gerst <brgerst@gmail.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Uros Bizjak <ubizjak@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 108/626] x86/stackprotector/64: Only export __ref_stack_chk_guard on CONFIG_SMP
Date: Tue, 27 May 2025 18:20:01 +0200
Message-ID: <20250527162449.429382128@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 58e3124ee2b42..5b96249734ada 100644
--- a/arch/x86/entry/entry.S
+++ b/arch/x86/entry/entry.S
@@ -63,7 +63,7 @@ THUNK warn_thunk_thunk, __warn_thunk
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



