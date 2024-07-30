Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD4018801A;
	Tue, 30 Jul 2024 16:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358584; cv=none; b=bHRrufYLd3NNPxOm9tS9nds0KwdyOFpXp5xCrAdjjCPnumLkK+8pVNS8y300joQ7jR+a3CxLvdsUHeYOTFt6vUFbD0hP84Bmkqscgescu+DKxUeJiFczHotCv6ugIDN6HZiZBxBOsRvheFxB44OFzc3PnFT6jbYWjjPby4of7Iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358584; c=relaxed/simple;
	bh=byM563PhxmBytqiq2D+vCBPCWNulBlQCQNo/tRfZaqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MsgjUP0EeXj9Cx/k9mucTtKcoH1rZijafyyuaHafSSWPunqPY/sAEMJ8CcCeRDawqBfezx2pEC58dkEUUTToSUOyVXyhOEyYcpqxj4DqDzohTftMMxJYsiNDtIHHHHa89YxgO8EHlNS44hanLJJEmFtJ1vLZmjgj1jVmqBX2U0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zo08a/2a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zo08a/2a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6989FC32782;
	Tue, 30 Jul 2024 16:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358584;
	bh=byM563PhxmBytqiq2D+vCBPCWNulBlQCQNo/tRfZaqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zo08a/2aar37W+X13QH61qnhDSIDlti3Mdb0mhXGexgU0QBNAZER40KelG1XOyCgs
	 7MXesJb3b9/LLyGKJ6RP246m9JfXWW2MNvtz7ozWWT9mU9L39Q7MMVJ2XUJlCeh9Aj
	 /LGeGdbaO37hHzo1jMY7OPRNRw5bbzOMTqItFPVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 404/440] kbuild: avoid build error when single DTB is turned into composite DTB
Date: Tue, 30 Jul 2024 17:50:37 +0200
Message-ID: <20240730151631.578911910@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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
index 3aa384cec76b8..d236e5658f9b1 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -382,8 +382,12 @@ cmd_dtc = $(HOSTCC) -E $(dtc_cpp_flags) -x assembler-with-cpp -o $(dtc-tmp) $< ;
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



