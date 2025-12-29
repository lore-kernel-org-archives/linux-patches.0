Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D934627EC7C;
	Mon, 29 Dec 2025 16:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025546; cv=none; b=Ej3jDczsI5sKEE1McZMVrlhaf5rTfcHSsG7PlzSKsG5qhRGQrK0ZXbmpHhCC+7ZOOu1tC2moHMT5jRtzbnW57Vz+mxPnXwfuTHsnxVaFwkC/o+XE+jL3xGwBFkktUSvgyEi7jpzMdCeXW5MGdhIJmJ4Wg7iUxl8xGX6ETOLVzfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025546; c=relaxed/simple;
	bh=PGFiZu81pZJRQE6t/7w9dcuBphdsDw9pwNHc71/TXLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mZGstbemYqhxbR0ijWHBoI8dxguGnLZfJ+p/+BB2s3WnNYHuGI3lD0Isq0wdaWIOr9Z0vIgfkQVn+tGHotpjvzbg3ZAtSGlvjfzCFbJpXNjfbiH3f9DUvduUETqEtlegcg/IRjRvGx5uASAXjq2oaW+C1OEcCqktE+gxZRq5a1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BnbaScyJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BnbaScyJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68A37C4CEF7;
	Mon, 29 Dec 2025 16:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025545;
	bh=PGFiZu81pZJRQE6t/7w9dcuBphdsDw9pwNHc71/TXLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BnbaScyJOXSTkOXEYgrgqneCkqhemflgKE8l2ivpJterOdNnp/Ypzrx/qR108RQap
	 g4fznY0n1v6X2xqi3Z+e2LjvcDXwFsPopxpkR0TFY4+5IeeVlau5D7UworezSz6qTw
	 dwosDKaC7qLBamvwXLEzlNbhdTvPvp6AqUW+xi40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Yejian <zhengyejian@huaweicloud.com>,
	Gary Guo <gary@garyguo.net>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.18 252/430] kallsyms: Fix wrong "big" kernel symbol type read from procfs
Date: Mon, 29 Dec 2025 17:10:54 +0100
Message-ID: <20251229160733.629534658@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zheng Yejian <zhengyejian@huaweicloud.com>

commit f3f9f42232dee596d15491ca3f611d02174db49c upstream.

Currently when the length of a symbol is longer than 0x7f characters,
its type shown in /proc/kallsyms can be incorrect.

I found this issue when reading the code, but it can be reproduced by
following steps:

  1. Define a function which symbol length is 130 characters:

    #define X13(x) x##x##x##x##x##x##x##x##x##x##x##x##x
    static noinline void X13(x123456789)(void)
    {
        printk("hello world\n");
    }

  2. The type in vmlinux is 't':

    $ nm vmlinux | grep x123456
    ffffffff816290f0 t x123456789x123456789x123456789x12[...]

  3. Then boot the kernel, the type shown in /proc/kallsyms becomes 'g'
     instead of the expected 't':

    # cat /proc/kallsyms | grep x123456
    ffffffff816290f0 g x123456789x123456789x123456789x12[...]

The root cause is that, after commit 73bbb94466fd ("kallsyms: support
"big" kernel symbols"), ULEB128 was used to encode symbol name length.
That is, for "big" kernel symbols of which name length is longer than
0x7f characters, the length info is encoded into 2 bytes.

kallsyms_get_symbol_type() expects to read the first char of the
symbol name which indicates the symbol type. However, due to the
"big" symbol case not being handled, the symbol type read from
/proc/kallsyms may be wrong, so handle it properly.

Cc: stable@vger.kernel.org
Fixes: 73bbb94466fd ("kallsyms: support "big" kernel symbols")
Signed-off-by: Zheng Yejian <zhengyejian@huaweicloud.com>
Acked-by: Gary Guo <gary@garyguo.net>
Link: https://patch.msgid.link/20241011143853.3022643-1-zhengyejian@huaweicloud.com
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/kallsyms.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -103,8 +103,11 @@ static char kallsyms_get_symbol_type(uns
 {
 	/*
 	 * Get just the first code, look it up in the token table,
-	 * and return the first char from this token.
+	 * and return the first char from this token. If MSB of length
+	 * is 1, it is a "big" symbol, so needs an additional byte.
 	 */
+	if (kallsyms_names[off] & 0x80)
+		off++;
 	return kallsyms_token_table[kallsyms_token_index[kallsyms_names[off + 1]]];
 }
 


