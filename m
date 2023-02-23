Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9587C258F
	for <patches@lists.linux.dev>; Thu, 23 Feb 2023 13:12:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DE08C433D2;
	Thu, 23 Feb 2023 13:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677157969;
	bh=vzlfLceev4QBwj+xrqm8tZ72fgYCcH9eeZriUxW7jRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GaeTy69uB2Y7ygl+Kn9uQXfto/c0QO9geb1ve/RaP4IePdMX3zoZiWmMtk2U3gaO5
	 91GADI48od6anct6hKbn2rx9FDjlEG8H3dRmxgew1J0Y78Ep898XH09n86OUm4DxBN
	 fq3Fip6B58IAN93/5GTvDLAj7PctrJJ2D6ozYbfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Matthias Maennich <maennich@google.com>
Subject: [PATCH 5.15 32/36] kbuild: Add CONFIG_PAHOLE_VERSION
Date: Thu, 23 Feb 2023 14:07:08 +0100
Message-Id: <20230223130430.530329211@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130429.072633724@linuxfoundation.org>
References: <20230223130429.072633724@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nathan Chancellor <nathan@kernel.org>

commit 613fe169237785a4bb1d06397b52606b2967da53 upstream.

There are a few different places where pahole's version is turned into a
three digit form with the exact same command. Move this command into
scripts/pahole-version.sh to reduce the amount of duplication across the
tree.

Create CONFIG_PAHOLE_VERSION so the version code can be used in Kconfig
to enable and disable configuration options based on the pahole version,
which is already done in a couple of places.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20220201205624.652313-3-nathan@kernel.org
Signed-off-by: Matthias Maennich <maennich@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 MAINTAINERS               |    1 +
 init/Kconfig              |    4 ++++
 scripts/pahole-version.sh |   13 +++++++++++++
 3 files changed, 18 insertions(+)
 create mode 100755 scripts/pahole-version.sh

--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3407,6 +3407,7 @@ F:	net/sched/act_bpf.c
 F:	net/sched/cls_bpf.c
 F:	samples/bpf/
 F:	scripts/bpf_doc.py
+F:	scripts/pahole-version.sh
 F:	tools/bpf/
 F:	tools/lib/bpf/
 F:	tools/testing/selftests/bpf/
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -91,6 +91,10 @@ config CC_HAS_ASM_INLINE
 config CC_HAS_NO_PROFILE_FN_ATTR
 	def_bool $(success,echo '__attribute__((no_profile_instrument_function)) int x();' | $(CC) -x c - -c -o /dev/null -Werror)
 
+config PAHOLE_VERSION
+	int
+	default $(shell,$(srctree)/scripts/pahole-version.sh $(PAHOLE))
+
 config CONSTRUCTORS
 	bool
 
--- /dev/null
+++ b/scripts/pahole-version.sh
@@ -0,0 +1,13 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+#
+# Usage: $ ./pahole-version.sh pahole
+#
+# Prints pahole's version in a 3-digit form, such as 119 for v1.19.
+
+if [ ! -x "$(command -v "$@")" ]; then
+	echo 0
+	exit 1
+fi
+
+"$@" --version | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/'


