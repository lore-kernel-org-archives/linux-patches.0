Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406AC149C4F;
	Tue, 25 Jun 2024 09:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309296; cv=none; b=WlKlXl4Fue9N9w6SCknN4a2y4j6Ul/cW95DGtRVc2m59V1WqyqJEnd9keboZ/X4i+wZksJhGZcDRZhv2f8EeF67uc6U46XrcFcVQGFv4J6xSmCR6aH2pVc+Ork+Xa8FkgLWRZZ4l9RdozCEqJtDj24Riymb82XflXNifG6C9D8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309296; c=relaxed/simple;
	bh=mTTegi7nXEgcyjDjFdD2+4jew8Y1MXqHP8RsmYd8Omg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JQ1RaibmV0cLYgGF+MuC8eOAwbc9jRztg0KlUt33C9BPzhvJYLRsqLhKahwZ1/1RwhD5H9NqB2P0qtafKwjpjSgr0q0srVvigFrncazf0xx1VPqQKrkXZ/fNFLntFS1h8cQf4TnZuI4JIB3SA3cCLUnR14Og7e8IvPxywxLbD+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PJC50kUq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PJC50kUq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB101C32781;
	Tue, 25 Jun 2024 09:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309296;
	bh=mTTegi7nXEgcyjDjFdD2+4jew8Y1MXqHP8RsmYd8Omg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PJC50kUqwmvYJIklSUr3BGtvi6CYWPdALiRmTyqABZik0akuSE1m3YWwoJIskKQh5
	 WNn8HvEH82oMtktaUr/OZetj90XCgS8vehpQB9IPUC9E3rQj7Mnc/2uWbzcevTbPev
	 18kjXGxuGdVvQTmZNDsbCZXp/drOzLIDtDaaAvtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rafael Aquini <aquini@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Heiko Carstens <hca@linux.ibm.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Petr Mladek <pmladek@suse.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 162/192] mm: mmap: allow for the maximum number of bits for randomizing mmap_base by default
Date: Tue, 25 Jun 2024 11:33:54 +0200
Message-ID: <20240625085543.380559048@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael Aquini <aquini@redhat.com>

commit 3afb76a66b5559a7b595155803ce23801558a7a9 upstream.

An ASLR regression was noticed [1] and tracked down to file-mapped areas
being backed by THP in recent kernels.  The 21-bit alignment constraint
for such mappings reduces the entropy for randomizing the placement of
64-bit library mappings and breaks ASLR completely for 32-bit libraries.

The reported issue is easily addressed by increasing vm.mmap_rnd_bits and
vm.mmap_rnd_compat_bits.  This patch just provides a simple way to set
ARCH_MMAP_RND_BITS and ARCH_MMAP_RND_COMPAT_BITS to their maximum values
allowed by the architecture at build time.

[1] https://zolutal.github.io/aslrnt/

[akpm@linux-foundation.org: default to `y' if 32-bit, per Rafael]
Link: https://lkml.kernel.org/r/20240606180622.102099-1-aquini@redhat.com
Fixes: 1854bc6e2420 ("mm/readahead: Align file mappings for non-DAX")
Signed-off-by: Rafael Aquini <aquini@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Samuel Holland <samuel.holland@sifive.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/Kconfig |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -1037,10 +1037,21 @@ config ARCH_MMAP_RND_BITS_MAX
 config ARCH_MMAP_RND_BITS_DEFAULT
 	int
 
+config FORCE_MAX_MMAP_RND_BITS
+	bool "Force maximum number of bits to use for ASLR of mmap base address"
+	default y if !64BIT
+	help
+	  ARCH_MMAP_RND_BITS and ARCH_MMAP_RND_COMPAT_BITS represent the number
+	  of bits to use for ASLR and if no custom value is assigned (EXPERT)
+	  then the architecture's lower bound (minimum) value is assumed.
+	  This toggle changes that default assumption to assume the arch upper
+	  bound (maximum) value instead.
+
 config ARCH_MMAP_RND_BITS
 	int "Number of bits to use for ASLR of mmap base address" if EXPERT
 	range ARCH_MMAP_RND_BITS_MIN ARCH_MMAP_RND_BITS_MAX
 	default ARCH_MMAP_RND_BITS_DEFAULT if ARCH_MMAP_RND_BITS_DEFAULT
+	default ARCH_MMAP_RND_BITS_MAX if FORCE_MAX_MMAP_RND_BITS
 	default ARCH_MMAP_RND_BITS_MIN
 	depends on HAVE_ARCH_MMAP_RND_BITS
 	help
@@ -1075,6 +1086,7 @@ config ARCH_MMAP_RND_COMPAT_BITS
 	int "Number of bits to use for ASLR of mmap base address for compatible applications" if EXPERT
 	range ARCH_MMAP_RND_COMPAT_BITS_MIN ARCH_MMAP_RND_COMPAT_BITS_MAX
 	default ARCH_MMAP_RND_COMPAT_BITS_DEFAULT if ARCH_MMAP_RND_COMPAT_BITS_DEFAULT
+	default ARCH_MMAP_RND_COMPAT_BITS_MAX if FORCE_MAX_MMAP_RND_BITS
 	default ARCH_MMAP_RND_COMPAT_BITS_MIN
 	depends on HAVE_ARCH_MMAP_RND_COMPAT_BITS
 	help


