Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E74C28EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 13:56:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE5FAC433EF;
	Mon, 30 Jan 2023 13:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675086970;
	bh=JM45I2fdT6mOTmZK1pKVbXIFfVWOizKcUivhoEtHPEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IllxO/LTrQbKV9rRFPRcxPJGNvyOlDkAUU9GDSlEol5ZHE79wvMqljvgrjfNKFdTX
	 OBvyp7PQJlSWr8/xp83hCPKe+SV3Wqn+saoYgspKgt5ql1SYeXbktbg7Qw2SnflT07
	 P5vpvkkCAdOSpBBcz6oJoG65GnE6+UYNFFP4RZDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 056/313] kbuild: fix make modules error when CONFIG_DEBUG_INFO_BTF_MODULES=y
Date: Mon, 30 Jan 2023 14:48:11 +0100
Message-Id: <20230130134339.295051171@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 74d3320f6f7cf72de88a7e8df573821f6db90239 ]

When CONFIG_DEBUG_INFO_BTF_MODULES=y, running 'make modules'
in the clean kernel tree will get the following error.

  $ grep CONFIG_DEBUG_INFO_BTF_MODULES .config
  CONFIG_DEBUG_INFO_BTF_MODULES=y
  $ make -s clean
  $ make modules
    [snip]
    AR      vmlinux.a
  ar: ./built-in.a: No such file or directory
  make: *** [Makefile:1241: vmlinux.a] Error 1

'modules' depends on 'vmlinux', but builtin objects are not built.

Define KBUILD_BUILTIN.

Fixes: f73edc8951b2 ("kbuild: unify two modpost invocations")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Makefile b/Makefile
index 770e509d4da4..0904b82905d9 100644
--- a/Makefile
+++ b/Makefile
@@ -1529,6 +1529,7 @@ endif
 # *.ko are usually independent of vmlinux, but CONFIG_DEBUG_INFOBTF_MODULES
 # is an exception.
 ifdef CONFIG_DEBUG_INFO_BTF_MODULES
+KBUILD_BUILTIN := 1
 modules: vmlinux
 endif
 
-- 
2.39.0



