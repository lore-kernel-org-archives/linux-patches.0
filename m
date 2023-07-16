Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA5D9442
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 19:59:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC051C433C8;
	Sun, 16 Jul 2023 19:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537597;
	bh=q8pIUxaKfg2Nho1GIGs5F8+Q7Aded75fIWRJBbnU1Ws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UKhQFfvcFLykGbSeiWCPwRl5GZCvDL6+wcsiVoqQdDmHlRrp+QyFA7UXYD4WnJvcx
	 OygSDRfvEOe8lVc/kt5K0wyN8hhxAN0q5BqbRBWzQC6ayqNd0q9w9TA0Rz+euHUuI3
	 wGPls5OGJvawi5zu9UuXSOLQwIp24H5Pj+nWdaH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viktor Malik <vmalik@redhat.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 145/800] tools/resolve_btfids: Fix setting HOSTCFLAGS
Date: Sun, 16 Jul 2023 21:39:58 +0200
Message-ID: <20230716194952.462284605@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Viktor Malik <vmalik@redhat.com>

[ Upstream commit edd75c802855271c8610f58a2fc9e54aefc49ce5 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/resolve_btfids/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/bpf/resolve_btfids/Makefile b/tools/bpf/resolve_btfids/Makefile
index ac548a7baa73e..4b8079f294f65 100644
--- a/tools/bpf/resolve_btfids/Makefile
+++ b/tools/bpf/resolve_btfids/Makefile
@@ -67,7 +67,7 @@ $(BPFOBJ): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile) | $(LIBBPF_OU
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
-- 
2.39.2



