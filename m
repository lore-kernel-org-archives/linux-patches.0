Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8E618C034;
	Thu, 17 Apr 2025 18:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744916237; cv=none; b=eMlvxl+2kjbuVAAyvq36sTAWdrRLkQaf4VCasm4pvR4sBWypAkkxFutCTlAykcgubQME3rJSxgYCX4q97GMrb6E55eexoz2vUitJJggqiypYXzG0QZKqkA3ZiqibvNHEMdsFaqXPZkuxk79afjQFLFfQguAUTmFxs020YYoW/Ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744916237; c=relaxed/simple;
	bh=svF0g+qxZQ6xlq9nHu7o89DsWxUlfeTQM5vPtOLI4+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GSKhsnhufhgLbROXpED1f9VbxY6uMcIOs+y6hKmBbRKXiMoY9+iQWdtCgU0lVo3IpaCDv0l+iI0a7h6n6p+XG17paLulb4jpeUO2Z3yfewO6usHHkLqB+58lXRhqSqobmyL91lCnZdMN1emX6c1pyWV6cWDOYiy2auejxLHwZp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n50Vcws2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n50Vcws2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF03EC4CEE4;
	Thu, 17 Apr 2025 18:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744916237;
	bh=svF0g+qxZQ6xlq9nHu7o89DsWxUlfeTQM5vPtOLI4+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n50Vcws2NngCVO/3fNXiIEZRQRh/4MUQ3GezCn/GkM1xKlMRCIN2hnUcsBsnCi5GS
	 b9T9dQ/q+A1ry5bt4zvWKWqdXTbnduDCOB+hI6uTnFjlIoQDuviHzWk+Ig30Qw7TXn
	 rpyHKmZljtZklqBCnuJNA1uZRSHVAXtaNyfmEUOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eder Zulian <ezulian@redhat.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	He Zhe <zhe.he@windriver.com>,
	Xiangyu Chen <xiangyu.chen@windriver.com>
Subject: [PATCH 6.12 389/393] libbpf: Prevent compiler warnings/errors
Date: Thu, 17 Apr 2025 19:53:18 +0200
Message-ID: <20250417175123.251218127@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eder Zulian <ezulian@redhat.com>

commit 7f4ec77f3fee41dd6a41f03a40703889e6e8f7b2 upstream.

Initialize 'new_off' and 'pad_bits' to 0 and 'pad_type' to  NULL in
btf_dump_emit_bit_padding to prevent compiler warnings/errors which are
observed when compiling with 'EXTRA_CFLAGS=-g -Og' options, but do not
happen when compiling with current default options.

For example, when compiling libbpf with

  $ make "EXTRA_CFLAGS=-g -Og" -C tools/lib/bpf/ clean all

Clang version 17.0.6 and GCC 13.3.1 fail to compile btf_dump.c due to
following errors:

  btf_dump.c: In function ‘btf_dump_emit_bit_padding’:
  btf_dump.c:903:42: error: ‘new_off’ may be used uninitialized [-Werror=maybe-uninitialized]
    903 |         if (new_off > cur_off && new_off <= next_off) {
        |                                  ~~~~~~~~^~~~~~~~~~~
  btf_dump.c:870:13: note: ‘new_off’ was declared here
    870 |         int new_off, pad_bits, bits, i;
        |             ^~~~~~~
  btf_dump.c:917:25: error: ‘pad_type’ may be used uninitialized [-Werror=maybe-uninitialized]
    917 |                         btf_dump_printf(d, "\n%s%s: %d;", pfx(lvl), pad_type,
        |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    918 |                                         in_bitfield ? new_off - cur_off : 0);
        |                                         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  btf_dump.c:871:21: note: ‘pad_type’ was declared here
    871 |         const char *pad_type;
        |                     ^~~~~~~~
  btf_dump.c:930:20: error: ‘pad_bits’ may be used uninitialized [-Werror=maybe-uninitialized]
    930 |                 if (bits == pad_bits) {
        |                    ^
  btf_dump.c:870:22: note: ‘pad_bits’ was declared here
    870 |         int new_off, pad_bits, bits, i;
        |                      ^~~~~~~~
  cc1: all warnings being treated as errors

Signed-off-by: Eder Zulian <ezulian@redhat.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/bpf/20241022172329.3871958-3-ezulian@redhat.com
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Xiangyu Chen <xiangyu.chen@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/lib/bpf/btf_dump.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -867,8 +867,8 @@ static void btf_dump_emit_bit_padding(co
 	} pads[] = {
 		{"long", d->ptr_sz * 8}, {"int", 32}, {"short", 16}, {"char", 8}
 	};
-	int new_off, pad_bits, bits, i;
-	const char *pad_type;
+	int new_off = 0, pad_bits = 0, bits, i;
+	const char *pad_type = NULL;
 
 	if (cur_off >= next_off)
 		return; /* no gap */


