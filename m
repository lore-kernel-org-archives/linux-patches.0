Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CF8C35A93D;
	Fri,  9 Jan 2026 12:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960485; cv=none; b=iow2nOl4Wz4TP+zdHUHCmcptiVmi5qdeq23VZgCAt0Q2cVKBcjnuqrcuNP/Jim6L5NdzIGLn3kCd96A36r/lPHSG2DwTLJDieggaPcMA3CXyTzSQCbYSCl2lwJ7bMZNA9Pjnb/2+h57Y0IukpPyXtBFtn8oe+/pQBwWbfuIJDtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960485; c=relaxed/simple;
	bh=cLznSSVGKgdSvxGvCTCiLVx834DyF5kpFNJml6mXs3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L9kBPIC6pYf/yMVx2gskuwASZZo6TTHKXW+reNxlXlWvbsnJ8jqkMeX2prcymWt+NWd0xg80U/4ZoqXC0Y/l88CNMTbcSnA3aAOlbCrK2f1V4cXLgf4F7A2SLg8u6++SZtrTa/J8lLjFBjaWTPo/vmD/sCUYNXevdY2wsseRXt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QutXDjvH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QutXDjvH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28CDCC16AAE;
	Fri,  9 Jan 2026 12:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960485;
	bh=cLznSSVGKgdSvxGvCTCiLVx834DyF5kpFNJml6mXs3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QutXDjvHz2/4ohCIi0mI/3LXMjIOAOxuZycFbuccAzBnK4KNcT8ve1BJWkc/KL6DR
	 h+m8LxXIHpjtlI5UMBZywYNggSYWYd4K7+MYVsICwF118cV3OHwvjnywIXKVVvNAkz
	 h25iB31Ofer5D1u5h6SG1+a5bXyWn753M5AtbWus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Yejian <zhengyejian@huaweicloud.com>,
	Gary Guo <gary@garyguo.net>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.6 419/737] kallsyms: Fix wrong "big" kernel symbol type read from procfs
Date: Fri,  9 Jan 2026 12:39:18 +0100
Message-ID: <20260109112149.757568622@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


