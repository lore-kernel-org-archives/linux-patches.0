Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88FEA1D6A7
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:57:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F213C433CB;
	Wed, 20 Sep 2023 11:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211052;
	bh=WkWcHHdcjTdQ3W/bmYoucZoYWfx7OybnLojx5uqGAdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hofS2Vpxg++39RatqIgdY+O3Pv9sPYmMtdr5dCNDbbos1hyGInoqfOQdE000qnqA1
	 5aCSg24BikYPrhYLbzgA9Xb61l/8QGXUsVWCFZvoyYuT56kNbnrgV1c/Q7hcbKSCXc
	 y4jewSCT4sQgHVYV4LayqRKPxXFhwn2gllQ8oS3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 091/139] MIPS: Use "grep -E" instead of "egrep"
Date: Wed, 20 Sep 2023 13:30:25 +0200
Message-ID: <20230920112839.006159435@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112835.549467415@linuxfoundation.org>
References: <20230920112835.549467415@linuxfoundation.org>
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

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit d42f0c6ad502c9f612410e125ebdf290cce8bdc3 ]

The latest version of grep claims the egrep is now obsolete so the build
now contains warnings that look like:
	egrep: warning: egrep is obsolescent; using grep -E
fix this up by moving the related file to use "grep -E" instead.

Here are the steps to install the latest grep:

  wget http://ftp.gnu.org/gnu/grep/grep-3.8.tar.gz
  tar xf grep-3.8.tar.gz
  cd grep-3.8 && ./configure && make
  sudo make install
  export PATH=/usr/local/bin:$PATH

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Stable-dep-of: 4fe4a6374c4d ("MIPS: Only fiddle with CHECKFLAGS if `need-compiler'")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/Makefile      | 2 +-
 arch/mips/vdso/Makefile | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/Makefile b/arch/mips/Makefile
index ee8f47aef98b3..dd6486097e1dc 100644
--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -352,7 +352,7 @@ KBUILD_LDFLAGS		+= -m $(ld-emul)
 
 ifdef need-compiler
 CHECKFLAGS += $(shell $(CC) $(KBUILD_CFLAGS) -dM -E -x c /dev/null | \
-	egrep -vw '__GNUC_(MINOR_|PATCHLEVEL_)?_' | \
+	grep -E -vw '__GNUC_(MINOR_|PATCHLEVEL_)?_' | \
 	sed -e "s/^\#define /-D'/" -e "s/ /'='/" -e "s/$$/'/" -e 's/\$$/&&/g')
 endif
 
diff --git a/arch/mips/vdso/Makefile b/arch/mips/vdso/Makefile
index f72658b3a53f7..1f7d5c6c10b08 100644
--- a/arch/mips/vdso/Makefile
+++ b/arch/mips/vdso/Makefile
@@ -71,7 +71,7 @@ KCOV_INSTRUMENT := n
 
 # Check that we don't have PIC 'jalr t9' calls left
 quiet_cmd_vdso_mips_check = VDSOCHK $@
-      cmd_vdso_mips_check = if $(OBJDUMP) --disassemble $@ | egrep -h "jalr.*t9" > /dev/null; \
+      cmd_vdso_mips_check = if $(OBJDUMP) --disassemble $@ | grep -E -h "jalr.*t9" > /dev/null; \
 		       then (echo >&2 "$@: PIC 'jalr t9' calls are not supported"; \
 			     rm -f $@; /bin/false); fi
 
-- 
2.40.1



