Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207108;
	b=N9BlNQrqy2l9NBr5yUrC90yKxVuMYRqb7CceVSUoNAs7MhtWRM80EE3PvpAwJp2Z/8BL
	 E4fk/b62X6e1+ypKtcic+IoAQwBNyHUhRFrvS80MWNYf+RdsUBPb8wStPCafqX8J/oYN6
	 JbTb6IpVB6KpUbtB5oQQ1Ef+aoqFx0IW11lErP2cTNNcoktMgXt9XBiDGseFh++rSmkD9
	 apJ6/qvvhf6Ag4+oarFpQNk/XJZ8GmEZyM1EqUkZ9zQYFwWqimWI1Ocrcz7k9dPQuznA5
	 KtnCLLwth9MQOiB0N7QsxBcbQcievjczDbUKPWgYNAReSCu18NFB2gOeb3VhYDJusgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207108;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FKt7ubL4WEcjss9Us8e4iSlc+J+FhySp5Pd7ELKfhuU=;
	b=WCaT9FH+4uMC39tR/9ljeucWHxuhdZkmYAcfpEoaNpgmTjAjCzQfzEoH9dVaJHEtgMMc
	 rQCVjb+kAVGfKCcdwOfE3BasIUlrGiyit2TsyiTXxeZkadC1XkeE9/71b6skzKHuUoren
	 yyOhHfxd/RYWfY4DFbgezKg0PAHkT2MhOMSq4+QkS0RAflmsEdgQDlgWfGN/143VdQTIo
	 8wzqCLEdBiPdZHzPE7h0Z+NsqvNCelSUW8U70LdxilJWL6+VZNyoTLVfkfstTAJiBSlEX
	 +fHx83gjI9ZU8FqZzIixE+fTJbD1VILdKGRSm4YFSLHnZ2n8nwzHENZOqhggYpBW7fg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sJ+pu01a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D02606A31F;
	Wed, 28 Oct 2026 17:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sJ+pu01a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4C921F031E0;
	Wed, 28 Oct 2026 17:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207108;
	bh=FKt7ubL4WEcjss9Us8e4iSlc+J+FhySp5Pd7ELKfhuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sJ+pu01axUmdmy2Q/nqCOwrqUTrtCrpdDQGrxRfGVGE7Ow8D8CLw83bGepyx/kwcF
	 L2zn1uk3nUUwxkOUWdfzgoGkwDrmLkhEWFMLVS40oEk7m7P/L2g4XT9NggmzsjNP9K
	 Elo56hEuYIEd9Whw6dvvJhhf17qRmsrEmifRYyHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gavin Inglis <giinglis@amazon.com>,
	Aaron Ahmed <aarnahmd@amazon.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.3 28/38] ftrace: Initialize modname and offset in print_rec()
Date: Wed, 28 Oct 2026 18:00:15 +0100
Message-ID: <20261028165941.119762624@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165940.394092994@linuxfoundation.org>
References: <20261028165940.394092994@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Ahmed <aarnahmd@amazon.com>

commit e1f339ff3b83857b93baf8b88186275a413d445e upstream.

print_rec() leaves 'modname' and 'offset' uninitialized and
kallsyms_lookup() only sets them on success. When the lookup fails like
when a module is being loaded or unloaded, 'modname' holds a garbage
value, passes the 'if (modname)' check, and is dereferenced by
seq_printf().

  Oops: general protection fault
  RIP: 0010:string+0x48/0xe0
  Call Trace:
   vsnprintf+0x1f5/0x650
   seq_printf+0x8e/0xb0
   print_rec+0x6c/0xc0
   t_show+0x4c/0x440
   seq_read_iter+0x119/0x480

This can be triggered by reading available_filter_functions while a
module is being loaded or unloaded.

Initialize both variables so a failed lookup skips the module name.

Cc: stable@vger.kernel.org
Fixes: b39181f7c690 ("ftrace: Add FTRACE_MCOUNT_MAX_OFFSET to avoid adding weak function")
Link: https://patch.msgid.link/20261016230403.4916-1-aarnahmd@amazon.com
Tested-by: Gavin Inglis <giinglis@amazon.com>
Signed-off-by: Aaron Ahmed <aarnahmd@amazon.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ftrace.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -4426,9 +4426,9 @@ subsys_initcall(ftrace_check_for_weak_fu
 
 static int print_rec(struct seq_file *m, unsigned long ip)
 {
-	unsigned long offset;
+	unsigned long offset = 0;
 	char str[KSYM_SYMBOL_LEN];
-	char *modname;
+	char *modname = NULL;
 	const char *ret;
 
 	ret = kallsyms_lookup(ip, NULL, &offset, &modname, str);


