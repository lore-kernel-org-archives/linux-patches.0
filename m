Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FED327FD7A;
	Wed, 23 Apr 2025 15:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420532; cv=none; b=P1ZXKXyh1B73A29gOCXP2687Kar9+kdzjiN9Tj6oO3s8Cpf6dcOntuceeYhwL71ELjMks2Hil0TgNJwW0T8DDOO7ywUGTRgHZ8EwB1gWH8LuKnf+LEF6WNvJgNIbw4TjA8fRony7xes+eDvLeQue1CagX+6XF+4uRcswqOAg350=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420532; c=relaxed/simple;
	bh=4nEDYjELJxj3ldq2SCyA6/T+uY4YOKvRXOvyavJTBOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UNAeRX3aFk21G+6rLpm2b9CcwvkpL+PTc7DuOcCw95anhxKMgtSTB3II5nGfCl/++UJhY7zeGOybjURGHrCJ+7LTnM9IKG8nD4N8Sir3drMcEPtT+TaFIUhuSBHAutMfmZxjFb+xBbJdPQ6NKUInqry8UY6g6DXuYke00LePh1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aYYhOZzx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aYYhOZzx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45273C4CEE2;
	Wed, 23 Apr 2025 15:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420529;
	bh=4nEDYjELJxj3ldq2SCyA6/T+uY4YOKvRXOvyavJTBOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aYYhOZzxgaJL4+eWl3BNBjZFQaujkENEaVElY+o3/Z7/6RrB5MSftdAHwirvflNt6
	 7VOVeS989nPSiBcWpgxzQehv6d9I36vf4Ybc/db4Vlt7Dq9kJFaDyDO87CuI7X06S7
	 W1jpXqCYGQ9Xdu4/EmRZi6vYY1Nc9CkmSmOkXXW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sami Tolvanen <samitolvanen@google.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.14 100/241] rust: kbuild: Dont export __pfx symbols
Date: Wed, 23 Apr 2025 16:42:44 +0200
Message-ID: <20250423142624.661696388@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sami Tolvanen <samitolvanen@google.com>

commit c59026c0570a2a97ce2e7d5ae5e9c48fc841542b upstream.

With CONFIG_PREFIX_SYMBOLS, objtool adds __pfx prefix symbols
to claim the compiler emitted call padding bytes. When
CONFIG_X86_KERNEL_IBT is not selected, the symbols are added to
individual object files and for Rust objects, they end up being
exported, resulting in warnings with CONFIG_GENDWARFKSYMS as the
symbols have no debugging information:

warning: gendwarfksyms: symbol_print_versions: no information for symbol __pfx_rust_helper_put_task_struct
warning: gendwarfksyms: symbol_print_versions: no information for symbol __pfx_rust_helper_task_euid
warning: gendwarfksyms: symbol_print_versions: no information for symbol __pfx_rust_helper_readq_relaxed
...

Filter out the __pfx prefix from exported symbols similarly to
the existing __cfi and __odr_asan prefixes.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Cc: stable@vger.kernel.org
Fixes: ac61506bf2d1 ("rust: Use gendwarfksyms + extended modversions for CONFIG_MODVERSIONS")
Link: https://lore.kernel.org/r/20250318231815.917621-2-samitolvanen@google.com
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/rust/Makefile
+++ b/rust/Makefile
@@ -334,7 +334,7 @@ $(obj)/bindings/bindings_helpers_generat
 $(obj)/bindings/bindings_helpers_generated.rs: $(src)/helpers/helpers.c FORCE
 	$(call if_changed_dep,bindgen)
 
-rust_exports = $(NM) -p --defined-only $(1) | awk '$$2~/(T|R|D|B)/ && $$3!~/__cfi/ && $$3!~/__odr_asan/ { printf $(2),$$3 }'
+rust_exports = $(NM) -p --defined-only $(1) | awk '$$2~/(T|R|D|B)/ && $$3!~/__(pfx|cfi|odr_asan)/ { printf $(2),$$3 }'
 
 quiet_cmd_exports = EXPORTS $@
       cmd_exports = \


