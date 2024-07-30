Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99BC5154C18;
	Tue, 30 Jul 2024 17:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360615; cv=none; b=LGx0H9pI68VoIqbtXAF20oafCjLHrYy0npf8F8xoGJxLrryD7qjYX2UjZ354ihOl9wg2U0nOyf9UvEVB2EP//arudQGx7igdQjlNcWo0lPBlnA6UeSx1NvO68Xu72LVl05Wr9j+08UcPLhIjiqsPkCw5Ob/OPB3WVbRssRTnNBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360615; c=relaxed/simple;
	bh=6wBzsSjShDuJ7JzXCEXMcT/weETxZ2p6GlCz0pxASoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W8hdrvTchR6PWzO1h0VWNB3ZT6qlObZsKvXv8OKSsPMF/SFR7jaXBS3auDcTnd1sAObbNUZkEVYWXtUt2EOBHgk9xfF12GtgjSnnxCLuMiLPhoAXuQnl161RVr2K6sOnhVdC9QNyo1T3A47kDa9dbd/OIuwJBmLjP1PfBFR4NpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ldbBeUhD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ldbBeUhD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20291C4AF0A;
	Tue, 30 Jul 2024 17:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360615;
	bh=6wBzsSjShDuJ7JzXCEXMcT/weETxZ2p6GlCz0pxASoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ldbBeUhDS2wozT0yjZPOU8DyqXQlPOev1sa8RSZaZpl+HyofxMbs6RASWGTIUDoIN
	 x5nJ/6bHtJ1W9MoxvH95j/j7bFIsl7FXeLAwmiG8HCLMHRZwgf5pIIm9QcxYSSfrh0
	 MVf2sxSzb2MelD3P/vpgkdoUzQju8uIRM5+at9Mk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 753/809] kbuild: avoid build error when single DTB is turned into composite DTB
Date: Tue, 30 Jul 2024 17:50:29 +0200
Message-ID: <20240730151754.698495633@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 712aba5543b88996bc4682086471076fbf048927 ]

As commit afa974b77128 ("kbuild: add real-prereqs shorthand for
$(filter-out FORCE,$^)") explained, $(real-prereqs) is not just a list
of objects when linking a multi-object module. If a single-object module
is turned into a multi-object module, $^ (and therefore $(real-prereqs)
as well) contains header files recorded in the *.cmd file. Such headers
must be filtered out.

Now that a DTB can be built either from a single source or multiple
source files, the same issue can occur.

Consider the following scenario:

First, foo.dtb is implemented as a single-blob device tree.

The code looks something like this:

[Sample Code 1]

  Makefile:

      dtb-y += foo.dtb

  foo.dts:

    #include <dt-bindings/gpio/gpio.h>
    /dts-v1/;
    / { };

When it is compiled, .foo.dtb.cmd records that foo.dtb depends on
scripts/dtc/include-prefixes/dt-bindings/gpio/gpio.h.

Later, foo.dtb is split into a base and an overlay. The code looks
something like this:

[Sample Code 2]

  Makefile:

      dtb-y += foo.dtb
      foo-dtbs := foo-base.dtb foo-addon.dtbo

  foo-base.dts:

    #include <dt-bindings/gpio/gpio.h>
    /dts-v1/;
    / { };

  foo-addon.dtso:

    /dts-v1/;
    /plugin/;
    / { };

If you rebuild foo.dtb without 'make clean', you will get this error:

    Overlay 'scripts/dtc/include-prefixes/dt-bindings/gpio/gpio.h' is incomplete

$(real-prereqs) contains not only foo-base.dtb and foo-addon.dtbo but
also scripts/dtc/include-prefixes/dt-bindings/gpio/gpio.h, which is
passed to scripts/dtc/fdtoverlay.

Fixes: 15d16d6dadf6 ("kbuild: Add generic rule to apply fdtoverlay")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/Makefile.lib | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 9f06f6aaf7fcb..7f8ec77bf35c9 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -407,8 +407,12 @@ cmd_dtc = $(HOSTCC) -E $(dtc_cpp_flags) -x assembler-with-cpp -o $(dtc-tmp) $< ;
 		-d $(depfile).dtc.tmp $(dtc-tmp) ; \
 	cat $(depfile).pre.tmp $(depfile).dtc.tmp > $(depfile)
 
+# NOTE:
+# Do not replace $(filter %.dtb %.dtbo, $^) with $(real-prereqs). When a single
+# DTB is turned into a multi-blob DTB, $^ will contain header file dependencies
+# recorded in the .*.cmd file.
 quiet_cmd_fdtoverlay = DTOVL   $@
-      cmd_fdtoverlay = $(objtree)/scripts/dtc/fdtoverlay -o $@ -i $(real-prereqs)
+      cmd_fdtoverlay = $(objtree)/scripts/dtc/fdtoverlay -o $@ -i $(filter %.dtb %.dtbo, $^)
 
 $(multi-dtb-y): FORCE
 	$(call if_changed,fdtoverlay)
-- 
2.43.0



