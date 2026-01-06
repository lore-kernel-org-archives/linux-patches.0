Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932C1355034;
	Tue,  6 Jan 2026 17:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720197; cv=none; b=Yym2NnUC9AmaEaFf0TMFM8u3bS7mTIP9pvlXj76vtZMkmUZrO8AKcqISLpagFvvl0f1vGqFBLeLs2lxMrPHZb4dhmuWGsN2LpLoPSBqa9cyn0E/6Ni1EwDjPy8GNQLXQO7Pi/9+MEbL4lUp+/MtHniDESmjpjjXe6LMmx9fDXyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720197; c=relaxed/simple;
	bh=8sGc+qtrU+1GzuJn6axbdkVPaaS/ZcqVPwh4izt+Abo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tbET608jhfFuA7UhGXmm3q0kCtu5MZZxxy9Z0s6CX1lsFneCxPVPEBK1LJw6bJGRrgAEBW4XwW0RmW4UqKyl4KwQtAZrrPNVMuAywING21bkql+jI3hluzb64mjf/5+8Or4wqRYON7FFRX01+IZBQMwl8p8QDPYwYdySBMKw9Z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dfMI1NJQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dfMI1NJQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10E18C116C6;
	Tue,  6 Jan 2026 17:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720197;
	bh=8sGc+qtrU+1GzuJn6axbdkVPaaS/ZcqVPwh4izt+Abo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dfMI1NJQ/97bTWEEsA77jFyrMEg3r3hWYdtAusQGSgqnmfdY6USALmJ5/7Vmki5ZN
	 H/tldcebBWsL0KSgzC9FAVjV71m/v8l6uTrpLDXS9JzVslbmtFDzpDAIzIIjTCHGSR
	 OmMeVtFRNjHZlmnGKpPyFHmYbODE0ZilsvnDYtZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Yejian <zhengyejian@huaweicloud.com>,
	Gary Guo <gary@garyguo.net>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 163/567] kallsyms: Fix wrong "big" kernel symbol type read from procfs
Date: Tue,  6 Jan 2026 17:59:05 +0100
Message-ID: <20260106170457.357816314@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


