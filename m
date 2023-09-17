Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C886A7469
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:21:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34C9BC433CA;
	Sun, 17 Sep 2023 20:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982109;
	bh=sWpKXylqcFkkezFYz4XDXRzJMq3jHPzFmu++q3HImUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MY5OFSMYtT5Q/RhM0fsriZtP6GDq4o3Sp0yAGWJrHzOpJaVZj/5wqFl7dqDluZ1d7
	 XFUZD0jySktgT0Kr8SDfPNDZ3vcU52kvu/BYymFF7H+BN79qbPlpSzo+EPOezleZli
	 ZwJgVH8HqgJxjnnKL9ZZpUXMKmbCA6+s7lo+XF7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Tucker <guillaume.tucker@collabora.com>,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	"kernelci.org bot" <bot@kernelci.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.1 218/219] MIPS: Only fiddle with CHECKFLAGS if `need-compiler
Date: Sun, 17 Sep 2023 21:15:45 +0200
Message-ID: <20230917191048.820844783@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
References: <20230917191040.964416434@linuxfoundation.org>
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

From: Maciej W. Rozycki <macro@orcam.me.uk>

commit 4fe4a6374c4db9ae2b849b61e84b58685dca565a upstream.

We have originally guarded fiddling with CHECKFLAGS in our arch Makefile
by checking for the CONFIG_MIPS variable, not set for targets such as
`distclean', etc. that neither include `.config' nor use the compiler.

Starting from commit 805b2e1d427a ("kbuild: include Makefile.compiler
only when compiler is needed") we have had a generic `need-compiler'
variable explicitly telling us if the compiler will be used and thus its
capabilities need to be checked and expressed in the form of compilation
flags.  If this variable is not set, then `make' functions such as
`cc-option' are undefined, causing all kinds of weirdness to happen if
we expect specific results to be returned, most recently:

cc1: error: '-mloongson-mmi' must be used with '-mhard-float'

messages with configurations such as `fuloong2e_defconfig' and the
`modules_install' target, which does include `.config' and yet does not
use the compiler.

Replace the check for CONFIG_MIPS with one for `need-compiler' instead,
so as to prevent the compiler from being ever called for CHECKFLAGS when
not needed.

Reported-by: Guillaume Tucker <guillaume.tucker@collabora.com>
Closes: https://lore.kernel.org/r/85031c0c-d981-031e-8a50-bc4fad2ddcd8@collabora.com/
Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Fixes: 805b2e1d427a ("kbuild: include Makefile.compiler only when compiler is needed")
Cc: stable@vger.kernel.org # v5.13+
Reported-by: "kernelci.org bot" <bot@kernelci.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -350,7 +350,7 @@ KBUILD_CFLAGS += -fno-asynchronous-unwin
 
 KBUILD_LDFLAGS		+= -m $(ld-emul)
 
-ifdef CONFIG_MIPS
+ifdef need-compiler
 CHECKFLAGS += $(shell $(CC) $(KBUILD_CFLAGS) -dM -E -x c /dev/null | \
 	egrep -vw '__GNUC_(MINOR_|PATCHLEVEL_)?_' | \
 	sed -e "s/^\#define /-D'/" -e "s/ /'='/" -e "s/$$/'/" -e 's/\$$/&&/g')


