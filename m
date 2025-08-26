Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5324229D26A;
	Tue, 26 Aug 2025 11:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207584; cv=none; b=qlBkz6mm/xb9MUL6sUBl3seK7837TsNL08SFJBUiTedROAJV4N06JJNvgOR3LfyrlsLFU+GIXaES1iTJQEt4KVmcMDe9lILmFlKxAU8Q1U0uTxTMCNSJYeXaqEgKsvPLOUSjiYVtbMKeFESx1l8DdjA3QcDjQVkE+4avqF6bk9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207584; c=relaxed/simple;
	bh=Cj0otSMwcpmLokhjG9KYRFKQBeJBKwGp8Z11+7Ai+IE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JF+J8nH0ZMOhMt4OYsM5t/YYIpG5eb9LdCazmr5YWiy9tIOKehd1PtJlI22VI2f8uhP+k5py+SLS9ZH/KomPGpFFyEzbdcvAcLfUzfFLi1kKeltwPzt925Qdbap4GHKt0W1MuZe37GoGoCXxwX9zKai9Pvbg7FRmk0OGzpXhcbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q+0ylaFR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q+0ylaFR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF91C4CEF1;
	Tue, 26 Aug 2025 11:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207584;
	bh=Cj0otSMwcpmLokhjG9KYRFKQBeJBKwGp8Z11+7Ai+IE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q+0ylaFRts2XIGlnaGs2O4ALLE6DT20qDLhqr94NzemAVlHI2/UEPUDr1rm3TztcL
	 maJ+BcX5eI4ynqGBxJh5uH3lPgOGcJfJ4TDYPgDico0Za35QTqtri0hjBK1qKhQI77
	 jKkI3VoWLfHBngbyXD1FIiFfKF1r24A5Zx98x4OU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Baoquan He <bhe@redhat.com>,
	Changyuan Lyu <changyuanl@google.com>,
	Coiby Xu <coxu@redhat.com>,
	Dave Vasilevsky <dave@vasilevsky.ca>,
	Eric Biggers <ebiggers@google.com>,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.16 238/457] kho: mm: dont allow deferred struct page with KHO
Date: Tue, 26 Aug 2025 13:08:42 +0200
Message-ID: <20250826110943.258052767@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pasha Tatashin <pasha.tatashin@soleen.com>

commit 8b66ed2c3f42cc462e05704af6b94e6a7bad2f5e upstream.

KHO uses struct pages for the preserved memory early in boot, however,
with deferred struct page initialization, only a small portion of memory
has properly initialized struct pages.

This problem was detected where vmemmap is poisoned, and illegal flag
combinations are detected.

Don't allow them to be enabled together, and later we will have to teach
KHO to work properly with deferred struct page init kernel feature.

Link: https://lkml.kernel.org/r/20250808201804.772010-3-pasha.tatashin@soleen.com
Fixes: 4e1d010e3bda ("kexec: add config option for KHO")
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baoquan He <bhe@redhat.com>
Cc: Changyuan Lyu <changyuanl@google.com>
Cc: Coiby Xu <coxu@redhat.com>
Cc: Dave Vasilevsky <dave@vasilevsky.ca>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/Kconfig.kexec | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/Kconfig.kexec b/kernel/Kconfig.kexec
index 2ee603a98813..1224dd937df0 100644
--- a/kernel/Kconfig.kexec
+++ b/kernel/Kconfig.kexec
@@ -97,6 +97,7 @@ config KEXEC_JUMP
 config KEXEC_HANDOVER
 	bool "kexec handover"
 	depends on ARCH_SUPPORTS_KEXEC_HANDOVER && ARCH_SUPPORTS_KEXEC_FILE
+	depends on !DEFERRED_STRUCT_PAGE_INIT
 	select MEMBLOCK_KHO_SCRATCH
 	select KEXEC_FILE
 	select DEBUG_FS
-- 
2.50.1



