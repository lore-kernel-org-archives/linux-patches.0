Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5022A1172B
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:05:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B35AC433C7;
	Mon, 11 Sep 2023 15:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444733;
	bh=8sxP00e9HMglcyLaSTtGp5BGwcoX/sQ2UqqoD8eQ8SQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PQH6SG3DT9UDJNjBbTpD6Aa3rSYXToG7Uw+vonpcvJ+bsTKBTREKlHnfsUw31DAdp
	 p6ZqKhTRZSIxQnw52lBJLEHAXgzV3riUYBEg5o9ZPHlpczZ7S+t3IL96WZt6b2jurA
	 OB37Ed0hcp7MrWv6kUbgGe35bwPgJ0Q1nYvBx7rE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Ian Rogers <irogers@google.com>
Subject: [PATCH 6.1 097/600] tools/resolve_btfids: Compile resolve_btfids as host program
Date: Mon, 11 Sep 2023 15:42:10 +0200
Message-ID: <20230911134636.468796670@linuxfoundation.org>
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

From: Jiri Olsa <jolsa@kernel.org>

commit 56a2df7615fa050cc67b89245b2a482849077939 upstream.

Making resolve_btfids to be compiled as host program so
we can avoid cross compile issues as reported by Nathan.

Also we no longer need HOST_OVERRIDES for BINARY target,
just for 'prepare' targets.

Fixes: 13e07691a16f ("tools/resolve_btfids: Alter how HOSTCC is forced")
Reported-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Ian Rogers <irogers@google.com>
Link: https://lore.kernel.org/bpf/20230202112839.1131892-1-jolsa@kernel.org
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/bpf/resolve_btfids/Build    |    4 +++-
 tools/bpf/resolve_btfids/Makefile |    9 ++++++---
 2 files changed, 9 insertions(+), 4 deletions(-)

--- a/tools/bpf/resolve_btfids/Build
+++ b/tools/bpf/resolve_btfids/Build
@@ -1,3 +1,5 @@
+hostprogs := resolve_btfids
+
 resolve_btfids-y += main.o
 resolve_btfids-y += rbtree.o
 resolve_btfids-y += zalloc.o
@@ -7,4 +9,4 @@ resolve_btfids-y += str_error_r.o
 
 $(OUTPUT)%.o: ../../lib/%.c FORCE
 	$(call rule_mkdir)
-	$(call if_changed_dep,cc_o_c)
+	$(call if_changed_dep,host_cc_o_c)
--- a/tools/bpf/resolve_btfids/Makefile
+++ b/tools/bpf/resolve_btfids/Makefile
@@ -22,6 +22,9 @@ HOST_OVERRIDES := AR="$(HOSTAR)" CC="$(H
 		  EXTRA_CFLAGS="$(HOSTCFLAGS) $(KBUILD_HOSTCFLAGS)"
 
 RM      ?= rm
+HOSTCC  ?= gcc
+HOSTLD  ?= ld
+HOSTAR  ?= ar
 CROSS_COMPILE =
 
 OUTPUT ?= $(srctree)/tools/bpf/resolve_btfids/
@@ -64,7 +67,7 @@ $(BPFOBJ): $(wildcard $(LIBBPF_SRC)/*.[c
 LIBELF_FLAGS := $(shell $(HOSTPKG_CONFIG) libelf --cflags 2>/dev/null)
 LIBELF_LIBS  := $(shell $(HOSTPKG_CONFIG) libelf --libs 2>/dev/null || echo -lelf)
 
-CFLAGS += -g \
+HOSTCFLAGS += -g \
           -I$(srctree)/tools/include \
           -I$(srctree)/tools/include/uapi \
           -I$(LIBBPF_INCLUDE) \
@@ -73,11 +76,11 @@ CFLAGS += -g \
 
 LIBS = $(LIBELF_LIBS) -lz
 
-export srctree OUTPUT CFLAGS Q
+export srctree OUTPUT HOSTCFLAGS Q HOSTCC HOSTLD HOSTAR
 include $(srctree)/tools/build/Makefile.include
 
 $(BINARY_IN): fixdep FORCE prepare | $(OUTPUT)
-	$(Q)$(MAKE) $(build)=resolve_btfids $(HOST_OVERRIDES)
+	$(Q)$(MAKE) $(build)=resolve_btfids
 
 $(BINARY): $(BPFOBJ) $(SUBCMDOBJ) $(BINARY_IN)
 	$(call msg,LINK,$@)


