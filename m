Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A4B28FE;
	Sat, 30 Dec 2023 12:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ObgGSyKa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AFABC433C7;
	Sat, 30 Dec 2023 12:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937937;
	bh=P0g5AUWOSOlDDOTnIXkV6nJwZBx6DPnXSQlRh18+Dgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ObgGSyKaD/KBvGfwwgrlyM5yO3KAnfYxEKwQKG2VJnJoOnpK3XhltuWgaGbHKo9Tv
	 IR2dEQF4Fjig8YWDQak+wEnbUzM1CGG4nNiI3sQQvG4CG1SSeXrHpmYBVAlfwNhnd3
	 I4kO2DxfIAUpm+q9CTHZ0ri47gpMcQqXOqxw/WAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 121/156] net: avoid build bug in skb extension length calculation
Date: Sat, 30 Dec 2023 11:59:35 +0000
Message-ID: <20231230115816.316972376@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

commit d6e5794b06c0fab74fe6e4fa55d508a5ceb14735 upstream.

GCC seems to incorrectly fail to evaluate skb_ext_total_length() at
compile time under certain conditions.

The issue even occurs if all values in skb_ext_type_len[] are "0",
ruling out the possibility of an actual overflow.

As the patch has been in mainline since v6.6 without triggering the
problem it seems to be a very uncommon occurrence.

As the issue only occurs when -fno-tree-loop-im is specified as part of
CFLAGS_GCOV, disable the BUILD_BUG_ON() only when building with coverage
reporting enabled.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202312171924.4FozI5FG-lkp@intel.com/
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/lkml/487cfd35-fe68-416f-9bfd-6bb417f98304@app.fastmail.com/
Fixes: 5d21d0a65b57 ("net: generalize calculation of skb extensions length")
Cc: <stable@vger.kernel.org>
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20231218-net-skbuff-build-bug-v1-1-eefc2fb0a7d3@weissschuh.net
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/skbuff.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4810,7 +4810,9 @@ static __always_inline unsigned int skb_
 static void skb_extensions_init(void)
 {
 	BUILD_BUG_ON(SKB_EXT_NUM >= 8);
+#if !IS_ENABLED(CONFIG_KCOV_INSTRUMENT_ALL)
 	BUILD_BUG_ON(skb_ext_total_length() > 255);
+#endif
 
 	skbuff_ext_cache = kmem_cache_create("skbuff_ext_cache",
 					     SKB_EXT_ALIGN_VALUE * skb_ext_total_length(),


