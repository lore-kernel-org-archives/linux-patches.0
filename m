Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B67D7882B
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 15:05:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A0FDC4339B;
	Fri, 10 Mar 2023 15:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678460725;
	bh=7xCiwiWeGGaIpq33g3xQRNNgdg8WLSw2sqC6ZUt2cTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uXyL4mxJvibaO+DbJQjJK/oa3sF9GMmI07LVuVBoEdnGDKACQLsJ/vD9yPri7gdt6
	 iUbYc8uuyESlO6MtJQSBRkITUlWCGrHSWNPbroLSq48ePeANBkgT6f/XysTYiswMbN
	 qnqauUe5LxGbNEAbLEL/T3ape3NHVZA8555Rckik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Palus <jpalus+gnu@fastmail.com>,
	Dmitry Goncharov <dgoncharov@users.sf.net>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.10 430/529] kbuild: Port silent mode detection to future gnu make.
Date: Fri, 10 Mar 2023 14:39:33 +0100
Message-Id: <20230310133824.869974385@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dmitry Goncharov <dgoncharov@users.sf.net>

commit 4bf73588165ba7d32131a043775557a54b6e1db5 upstream.

Port silent mode detection to the future (post make-4.4) versions of gnu make.

Makefile contains the following piece of make code to detect if option -s is
specified on the command line.

ifneq ($(findstring s,$(filter-out --%,$(MAKEFLAGS))),)

This code is executed by make at parse time and assumes that MAKEFLAGS
does not contain command line variable definitions.
Currently if the user defines a=s on the command line, then at build only
time MAKEFLAGS contains " -- a=s".
However, starting with commit dc2d963989b96161472b2cd38cef5d1f4851ea34
MAKEFLAGS contains command line definitions at both parse time and
build time.

This '-s' detection code then confuses a command line variable
definition which contains letter 's' with option -s.

$ # old make
$ make net/wireless/ocb.o a=s
  CALL    scripts/checksyscalls.sh
  DESCEND objtool
$ # this a new make which defines makeflags at parse time
$ ~/src/gmake/make/l64/make net/wireless/ocb.o a=s
$

We can see here that the letter 's' from 'a=s' was confused with -s.

This patch checks for presence of -s using a method recommended by the
make manual here
https://www.gnu.org/software/make/manual/make.html#Testing-Flags.

Link: https://lists.gnu.org/archive/html/bug-make/2022-11/msg00190.html
Reported-by: Jan Palus <jpalus+gnu@fastmail.com>
Signed-off-by: Dmitry Goncharov <dgoncharov@users.sf.net>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/Makefile
+++ b/Makefile
@@ -93,9 +93,16 @@ endif
 
 # If the user is running make -s (silent mode), suppress echoing of
 # commands
+# make-4.0 (and later) keep single letter options in the 1st word of MAKEFLAGS.
 
-ifneq ($(findstring s,$(filter-out --%,$(MAKEFLAGS))),)
-  quiet=silent_
+ifeq ($(filter 3.%,$(MAKE_VERSION)),)
+silence:=$(findstring s,$(firstword -$(MAKEFLAGS)))
+else
+silence:=$(findstring s,$(filter-out --%,$(MAKEFLAGS)))
+endif
+
+ifeq ($(silence),s)
+quiet=silent_
 endif
 
 export quiet Q KBUILD_VERBOSE


