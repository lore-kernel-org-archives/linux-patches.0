Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 546C12EBB89;
	Tue, 15 Jul 2025 13:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586693; cv=none; b=V5z3+2WFBf0KGP3tfZssUhZUE+nXY6LD0Lir790S+NzCoGnDinq9h7nk+wtnF5DcQ0p4GhSN/BpMVNPm0lN/+1SYoUVVtFT2L/9bKSBXMZC8FpsQxB37MOHxCqx44b77DgMg8Hb9N/OYE/3QlOwriRbgCs+JJZ6+Mw5rh9hNYrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586693; c=relaxed/simple;
	bh=K6B+wwsD3gW0+ulgLj7E0cqU2ohmtW9+SxPl6J2xEVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m0yKXWcSAUaE+DFwj+C/grF776I67MCWJJi/NIrEyxEvBVDL2ozEVQA51RcDkx/pnzu3cX/LmeDueXZsMS/DmJw/6iPT89B+as4YPmU4mJCsiTGxMN0yAUpYw8mecHRB0BAdYK91pNOqgMmrBq+/b99Fq/TRfHNMXg+LtvvBDE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zbmsd1/p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zbmsd1/p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C872C4CEE3;
	Tue, 15 Jul 2025 13:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586692;
	bh=K6B+wwsD3gW0+ulgLj7E0cqU2ohmtW9+SxPl6J2xEVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zbmsd1/pkbzUAejhVlRChsuRmoO22KAn2l8/FptgKYlbKHCUKOItJjcLWj86al+h/
	 PrQQUhd/ptHTuDwyXqbMerHDZj+HdVbwdMrE3FLI/6zmsvPt24Ou/p7++Gx3b9ZYXL
	 U1UPSQT3xXm9mGq8+8KFHnCi04pZcTptBJqrKKmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 013/192] objtool: Add missing endian conversion to read_annotate()
Date: Tue, 15 Jul 2025 15:11:48 +0200
Message-ID: <20250715130815.395402187@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit ccdd09e0fc0d5ce6dfc8360f0c88da9a5045b6ea ]

Trying to compile an x86 kernel on big endian results in this error:

net/ipv4/netfilter/iptable_nat.o: warning: objtool: iptable_nat_table_init+0x150: Unknown annotation type: 50331648
make[5]: *** [scripts/Makefile.build:287: net/ipv4/netfilter/iptable_nat.o] Error 255

Reason is a missing endian conversion in read_annotate().
Add the missing conversion to fix this.

Fixes: 2116b349e29a ("objtool: Generic annotation infrastructure")
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20250630131230.4130185-1-hca@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/check.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index f23bdda737aaa..d967ac001498b 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2318,6 +2318,7 @@ static int read_annotate(struct objtool_file *file,
 
 	for_each_reloc(sec->rsec, reloc) {
 		type = *(u32 *)(sec->data->d_buf + (reloc_idx(reloc) * sec->sh.sh_entsize) + 4);
+		type = bswap_if_needed(file->elf, type);
 
 		offset = reloc->sym->offset + reloc_addend(reloc);
 		insn = find_insn(file, reloc->sym->sec, offset);
-- 
2.39.5



