Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2DD1A76A5;
	Tue, 30 Jul 2024 17:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359727; cv=none; b=kwqUKsYUnn00MIG5nuT2HTg6jJgJyAKh2zezb5fb11m7ASmnBo/Ju98WiwK6TzXCzH7S5LvgaAjVRem8eBpk0ju9H4QgRIsSv9u1sNsmhiT4554faB5euI9dSY4CXwm9jk/CPeNu+yONA5sf/FL+R6nmbuoWAsB490aOUZgbN4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359727; c=relaxed/simple;
	bh=QmH7f82sVTl6RXgBmSLaQNNIUY09s089bw3i5DYjg8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IgSShfDw3piCCfM4uIHyQxN3oq1IaICbqDQoPKHJ1XqREXoMnU+cNZyeShY+Bz5OV1heqAL0YisMd06ubKz/ybDDeS7Fi2RM2jhnakaJ9NE4bo35pHO0HOHn/yXvL7JzVeA8UUT+2kPNpTctjLHDAqWWaLItSJgxamWJHu6lTl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ExYAuKKb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ExYAuKKb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E75CBC4AF0A;
	Tue, 30 Jul 2024 17:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359727;
	bh=QmH7f82sVTl6RXgBmSLaQNNIUY09s089bw3i5DYjg8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ExYAuKKbbzVeNE1ivCKexEkRbuYPgjceh7o4rytPYgm/0/zGMEtIbzvNxbVB45DKp
	 lymV7wt6h0ubopUm1u/SOWj17cqv0C5y3t0jwAxI4RaMvMkyjGbW0FaXTTMe8UXedA
	 2fMudiboRJNiufUhkQVUKukDKU7vkXFY4PyOZdXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 528/568] kbuild: avoid build error when single DTB is turned into composite DTB
Date: Tue, 30 Jul 2024 17:50:35 +0200
Message-ID: <20240730151700.795259349@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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
index 68d0134bdbf9d..e702552fb131a 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -395,8 +395,12 @@ cmd_dtc = $(HOSTCC) -E $(dtc_cpp_flags) -x assembler-with-cpp -o $(dtc-tmp) $< ;
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



