Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1131728EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 13:55:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DDC1C433EF;
	Mon, 30 Jan 2023 13:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675086899;
	bh=ZOHy4zDgMFlK6xjhcbJMwUmPeR8ZEwcxRMhxMNPe9/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q5UgDoP89D8+2nCnupsoECH1JZObAZxx7wVzVtYseyUzZUFzrS6lwPZdbKQsi+S+t
	 DftxL/Tj77r8jeAN0a1nbLuLQlFnlhCzSN+iMLvyqV5kTyg60pUCN5YvBjE3agiTf4
	 8HVGd/rUF8rxtgddBiq5ui00jRudANlRAuR6o2ZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 033/313] tomoyo: fix broken dependency on *.conf.default
Date: Mon, 30 Jan 2023 14:47:48 +0100
Message-Id: <20230130134338.218816726@linuxfoundation.org>
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

[ Upstream commit eaf2213ba563b2d74a1f2c13a6b258273f689802 ]

If *.conf.default is updated, builtin-policy.h should be rebuilt,
but this does not work when compiled with O= option.

[Without this commit]

  $ touch security/tomoyo/policy/exception_policy.conf.default
  $ make O=/tmp security/tomoyo/
  make[1]: Entering directory '/tmp'
    GEN     Makefile
    CALL    /home/masahiro/ref/linux/scripts/checksyscalls.sh
    DESCEND objtool
  make[1]: Leaving directory '/tmp'

[With this commit]

  $ touch security/tomoyo/policy/exception_policy.conf.default
  $ make O=/tmp security/tomoyo/
  make[1]: Entering directory '/tmp'
    GEN     Makefile
    CALL    /home/masahiro/ref/linux/scripts/checksyscalls.sh
    DESCEND objtool
    POLICY  security/tomoyo/builtin-policy.h
    CC      security/tomoyo/common.o
    AR      security/tomoyo/built-in.a
  make[1]: Leaving directory '/tmp'

$(srctree)/ is essential because $(wildcard ) does not follow VPATH.

Fixes: f02dee2d148b ("tomoyo: Do not generate empty policy files")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/tomoyo/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/tomoyo/Makefile b/security/tomoyo/Makefile
index cca5a3012fee..221eaadffb09 100644
--- a/security/tomoyo/Makefile
+++ b/security/tomoyo/Makefile
@@ -10,7 +10,7 @@ endef
 quiet_cmd_policy  = POLICY  $@
       cmd_policy  = ($(call do_policy,profile); $(call do_policy,exception_policy); $(call do_policy,domain_policy); $(call do_policy,manager); $(call do_policy,stat)) >$@
 
-$(obj)/builtin-policy.h: $(wildcard $(obj)/policy/*.conf $(src)/policy/*.conf.default) FORCE
+$(obj)/builtin-policy.h: $(wildcard $(obj)/policy/*.conf $(srctree)/$(src)/policy/*.conf.default) FORCE
 	$(call if_changed,policy)
 
 $(obj)/common.o: $(obj)/builtin-policy.h
-- 
2.39.0



