Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23091172B
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:05:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34D6FC433C8;
	Mon, 11 Sep 2023 15:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444741;
	bh=sSM4F90MkeR0yXTbGUhT7FzGFlzsDUbt//6++fTZxoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1s8IGtC1byv0RZjmVFexQUIpz/lhA+m2r6WlojmwBjU8mgqhgFi0D+ZrOjeg5aKLl
	 1IzHmI3v26S9P6F5uLaGymn6oozN6QfqukIt6kWao91gIOW/ILg3B21qFC1WiPD2wp
	 3Qane0QQbHuy28qhZaVXmPSWpCI0fW32llzs31S4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viktor Malik <vmalik@redhat.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 6.1 100/600] tools/resolve_btfids: Fix setting HOSTCFLAGS
Date: Mon, 11 Sep 2023 15:42:13 +0200
Message-ID: <20230911134636.555343455@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viktor Malik <vmalik@redhat.com>

commit edd75c802855271c8610f58a2fc9e54aefc49ce5 upstream.

Building BPF selftests with custom HOSTCFLAGS yields an error:

    # make HOSTCFLAGS="-O2"
    [...]
      HOSTCC  ./tools/testing/selftests/bpf/tools/build/resolve_btfids/main.o
    main.c:73:10: fatal error: linux/rbtree.h: No such file or directory
       73 | #include <linux/rbtree.h>
          |          ^~~~~~~~~~~~~~~~

The reason is that tools/bpf/resolve_btfids/Makefile passes header
include paths by extending HOSTCFLAGS which is overridden by setting
HOSTCFLAGS in the make command (because of Makefile rules [1]).

This patch fixes the above problem by passing the include paths via
`HOSTCFLAGS_resolve_btfids` which is used by tools/build/Build.include
and can be combined with overridding HOSTCFLAGS.

[1] https://www.gnu.org/software/make/manual/html_node/Overriding.html

Fixes: 56a2df7615fa ("tools/resolve_btfids: Compile resolve_btfids as host program")
Signed-off-by: Viktor Malik <vmalik@redhat.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/bpf/20230530123352.1308488-1-vmalik@redhat.com
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/bpf/resolve_btfids/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/bpf/resolve_btfids/Makefile
+++ b/tools/bpf/resolve_btfids/Makefile
@@ -67,7 +67,7 @@ $(BPFOBJ): $(wildcard $(LIBBPF_SRC)/*.[c
 LIBELF_FLAGS := $(shell $(HOSTPKG_CONFIG) libelf --cflags 2>/dev/null)
 LIBELF_LIBS  := $(shell $(HOSTPKG_CONFIG) libelf --libs 2>/dev/null || echo -lelf)
 
-HOSTCFLAGS += -g \
+HOSTCFLAGS_resolve_btfids += -g \
           -I$(srctree)/tools/include \
           -I$(srctree)/tools/include/uapi \
           -I$(LIBBPF_INCLUDE) \
@@ -76,7 +76,7 @@ HOSTCFLAGS += -g \
 
 LIBS = $(LIBELF_LIBS) -lz
 
-export srctree OUTPUT HOSTCFLAGS Q HOSTCC HOSTLD HOSTAR
+export srctree OUTPUT HOSTCFLAGS_resolve_btfids Q HOSTCC HOSTLD HOSTAR
 include $(srctree)/tools/build/Makefile.include
 
 $(BINARY_IN): fixdep FORCE prepare | $(OUTPUT)


