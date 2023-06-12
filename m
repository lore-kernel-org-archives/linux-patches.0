Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87583DF4F
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:51:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E6BAC433EF;
	Mon, 12 Jun 2023 10:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686567085;
	bh=/4jC9wN7Ti7pVJlnkhXEhbVX9W7/1Y3g8dKtZDXVJM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m4r0jtnrVR1tYO+oQGcKQyvWC80ii/ob5zbKnd6PhiUIU6Mt3hQWx+1Z8fgZaFuhu
	 SxNtBWo7gW+6hTW02nhOFASi14U/UyORt/NO2RwlTbR5AMyOJuBKHHmEuQwxFaaJwU
	 Y3k8ChPUQsiig2QWhU9wAt5bl6Ys6KbiJdza25R4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruihan Li <lrh2000@pku.edu.cn>,
	David Hildenbrand <david@redhat.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: [PATCH 6.3 116/160] mm: page_table_check: Make it dependent on EXCLUSIVE_SYSTEM_RAM
Date: Mon, 12 Jun 2023 12:27:28 +0200
Message-ID: <20230612101720.370502304@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101715.129581706@linuxfoundation.org>
References: <20230612101715.129581706@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ruihan Li <lrh2000@pku.edu.cn>

commit 81a31a860bb61d54eb688af2568d9332ed9b8942 upstream.

Without EXCLUSIVE_SYSTEM_RAM, users are allowed to map arbitrary
physical memory regions into the userspace via /dev/mem. At the same
time, pages may change their properties (e.g., from anonymous pages to
named pages) while they are still being mapped in the userspace, leading
to "corruption" detected by the page table check.

To avoid these false positives, this patch makes PAGE_TABLE_CHECK
depends on EXCLUSIVE_SYSTEM_RAM. This dependency is understandable
because PAGE_TABLE_CHECK is a hardening technique but /dev/mem without
STRICT_DEVMEM (i.e., !EXCLUSIVE_SYSTEM_RAM) is itself a security
problem.

Even with EXCLUSIVE_SYSTEM_RAM, I/O pages may be still allowed to be
mapped via /dev/mem. However, these pages are always considered as named
pages, so they won't break the logic used in the page table check.

Cc: <stable@vger.kernel.org> # 5.17
Signed-off-by: Ruihan Li <lrh2000@pku.edu.cn>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Link: https://lore.kernel.org/r/20230515130958.32471-4-lrh2000@pku.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/mm/page_table_check.rst |   19 +++++++++++++++++++
 mm/Kconfig.debug                      |    1 +
 2 files changed, 20 insertions(+)

--- a/Documentation/mm/page_table_check.rst
+++ b/Documentation/mm/page_table_check.rst
@@ -52,3 +52,22 @@ Build kernel with:
 
 Optionally, build kernel with PAGE_TABLE_CHECK_ENFORCED in order to have page
 table support without extra kernel parameter.
+
+Implementation notes
+====================
+
+We specifically decided not to use VMA information in order to avoid relying on
+MM states (except for limited "struct page" info). The page table check is a
+separate from Linux-MM state machine that verifies that the user accessible
+pages are not falsely shared.
+
+PAGE_TABLE_CHECK depends on EXCLUSIVE_SYSTEM_RAM. The reason is that without
+EXCLUSIVE_SYSTEM_RAM, users are allowed to map arbitrary physical memory
+regions into the userspace via /dev/mem. At the same time, pages may change
+their properties (e.g., from anonymous pages to named pages) while they are
+still being mapped in the userspace, leading to "corruption" detected by the
+page table check.
+
+Even with EXCLUSIVE_SYSTEM_RAM, I/O pages may be still allowed to be mapped via
+/dev/mem. However, these pages are always considered as named pages, so they
+won't break the logic used in the page table check.
--- a/mm/Kconfig.debug
+++ b/mm/Kconfig.debug
@@ -98,6 +98,7 @@ config PAGE_OWNER
 config PAGE_TABLE_CHECK
 	bool "Check for invalid mappings in user page tables"
 	depends on ARCH_SUPPORTS_PAGE_TABLE_CHECK
+	depends on EXCLUSIVE_SYSTEM_RAM
 	select PAGE_EXTENSION
 	help
 	  Check that anonymous page is not being mapped twice with read write


