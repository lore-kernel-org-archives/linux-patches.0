Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40242200D5
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u9R0LOPc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A13C433C8;
	Mon, 16 Oct 2023 14:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697467561;
	bh=CgfKUwNUxiUeBCEJqmtHtjieTJfl9o4txX11SPOFIvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u9R0LOPcsYXTMbXmN6R2osmqT+JsNC9F8uNCiF0G65r5uCwTfiXVqUI7ynGreHX3N
	 e4K1vhGW6X3QpTWRxNpft6x2o44HLJ3SV4JHl4E7MIDzeultwNucEfQelZdQC10nck
	 dDcZoW4RBgtN6ynIN4CvpADlQNMim0jwS0jGf76w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Garg <sumit.garg@linaro.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>
Subject: [PATCH 6.5 026/191] KEYS: trusted: Remove redundant static calls usage
Date: Mon, 16 Oct 2023 10:40:11 +0200
Message-ID: <20231016084016.012575485@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sumit Garg <sumit.garg@linaro.org>

commit 01bbafc63b65689cb179ca537971286bc27f3b74 upstream.

Static calls invocations aren't well supported from module __init and
__exit functions. Especially the static call from cleanup_trusted() led
to a crash on x86 kernel with CONFIG_DEBUG_VIRTUAL=y.

However, the usage of static call invocations for trusted_key_init()
and trusted_key_exit() don't add any value from either a performance or
security perspective. Hence switch to use indirect function calls instead.

Note here that although it will fix the current crash report, ultimately
the static call infrastructure should be fixed to either support its
future usage from module __init and __exit functions or not.

Reported-and-tested-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Link: https://lore.kernel.org/lkml/ZRhKq6e5nF%2F4ZIV1@fedora/#t
Fixes: 5d0682be3189 ("KEYS: trusted: Add generic trusted keys framework")
Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/keys/trusted-keys/trusted_core.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/security/keys/trusted-keys/trusted_core.c
+++ b/security/keys/trusted-keys/trusted_core.c
@@ -44,13 +44,12 @@ static const struct trusted_key_source t
 #endif
 };
 
-DEFINE_STATIC_CALL_NULL(trusted_key_init, *trusted_key_sources[0].ops->init);
 DEFINE_STATIC_CALL_NULL(trusted_key_seal, *trusted_key_sources[0].ops->seal);
 DEFINE_STATIC_CALL_NULL(trusted_key_unseal,
 			*trusted_key_sources[0].ops->unseal);
 DEFINE_STATIC_CALL_NULL(trusted_key_get_random,
 			*trusted_key_sources[0].ops->get_random);
-DEFINE_STATIC_CALL_NULL(trusted_key_exit, *trusted_key_sources[0].ops->exit);
+static void (*trusted_key_exit)(void);
 static unsigned char migratable;
 
 enum {
@@ -359,19 +358,16 @@ static int __init init_trusted(void)
 		if (!get_random)
 			get_random = kernel_get_random;
 
-		static_call_update(trusted_key_init,
-				   trusted_key_sources[i].ops->init);
 		static_call_update(trusted_key_seal,
 				   trusted_key_sources[i].ops->seal);
 		static_call_update(trusted_key_unseal,
 				   trusted_key_sources[i].ops->unseal);
 		static_call_update(trusted_key_get_random,
 				   get_random);
-		static_call_update(trusted_key_exit,
-				   trusted_key_sources[i].ops->exit);
+		trusted_key_exit = trusted_key_sources[i].ops->exit;
 		migratable = trusted_key_sources[i].ops->migratable;
 
-		ret = static_call(trusted_key_init)();
+		ret = trusted_key_sources[i].ops->init();
 		if (!ret)
 			break;
 	}
@@ -388,7 +384,8 @@ static int __init init_trusted(void)
 
 static void __exit cleanup_trusted(void)
 {
-	static_call_cond(trusted_key_exit)();
+	if (trusted_key_exit)
+		(*trusted_key_exit)();
 }
 
 late_initcall(init_trusted);


