Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026274;
	b=zbhay5Ku7/38WAyi2vVs84IoNZK30GW00e0V56HFPgVzn8HjtIKkcEaG94OcmRDRomrb
	 X225pW6Wvf+6prw9ig/UdTi2/HRL4uT8/qSZlikhGDl07vaiBuW+jcOtKYS7h6n1sdnzP
	 B/24zeJ/scmcw6E0sJPyA/1CwBVSsk9aHVDyP42so9mm2azb3AUCMA3VgfjhkXVzG//bU
	 bCDRn7vU+a5avtrV7kRprkVNzUErn868xSLxkPHUPiyGspVn+nsROa87L3iOF+RLJhrEi
	 7QXiHUz9Ei2LDNYEQlRnrX+Ocgw5H6bEW1noXVs0PUK7Xa5Q996p2lapSuDVT1R4Y7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026274;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=edt7XMHJmqn56vwDnaMgySMb1+WBhRyuMmNlE/j4Mfc=;
	b=p/9uXo5IbZEdSlwkBkhUFrNUv182SuJs2vdbBLEA/MrGig1mvdqCDFZo1A2x0PeSgEWX
	 NJQPEBj3NwdZxNSXM6/pFag6TP5Q5kh28MpX0g5KZzkJh7kmYeTKsBX2vixmV/P+WrMiM
	 wVZ9GLJ+jMhkbkEaox1brTFIaR03Pjr6mqgyEF5sAzAp+lyd1FWkZwxnLf2hvNYeqlV31
	 kKkG2Rmx/KKZue2xFdr69/Zs3KrFRCsZLPPjeAGI9SoZgm9w5v6sMiKiwMIae9DcXiH99
	 29OaDfozZzPy7oHsxXO7g4ok4yR8VvvmhWLQLfFwK5TpjREYQSIwClTo6go1hFFgwiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TKnIBsBx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C37606A32F;
	Wed, 18 Nov 2026 18:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TKnIBsBx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ABA01F000C4;
	Wed, 18 Nov 2026 18:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026274;
	bh=edt7XMHJmqn56vwDnaMgySMb1+WBhRyuMmNlE/j4Mfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TKnIBsBxT232pD9Y0veMXOc43d8o27M3FTymnLLA/LUBHRSCh39epeYPr3ZpAkaJl
	 K0aiv89b6jgXmrUvaxIr17AsUK3iYM/sW/swaN7iLW6ekU2rCKZHErMJHhwOLmScJh
	 Xg4K8rU4RetlUQl8ulUTIcGPZYAwvyPCBEEYRGkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Yafang Shao <laoar.shao@gmail.com>,
	Quentin Monnet <qmo@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1335/2151] bpftool: Fix out-of-bounds read in kprobe_multi link info dump
Date: Wed, 18 Nov 2026 15:51:10 +0100
Message-ID: <20261118150210.687980219@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuan Chen <chenyuan@kylinos.cn>

[ Upstream commit 0d5e3fc78a6f2522e6339743b8e5ecc02351a9dd ]

show_kprobe_multi_{plain,json}() walk the sorted kallsyms array against
the sorted addr/cookie array with j as a cursor into the latter. The
loop terminating condition is checked after the cursor has already been
used to access the array:

    if (j++ == info->kprobe_multi.count)
            break;

After all count entries have been printed, j has been bumped to count,
but the loop keeps running and dereferences data[count] -- one element
past the end of the calloc(count, sizeof(*data)) allocation -- while
comparing every remaining kallsyms symbol. If the out-of-bounds value
happens to match a symbol address, a bogus entry with a garbage
addr/cookie pair is printed to boot.

Fix the off-by-one by advancing the cursor before the comparison, so the
loop terminates as soon as the last entry has been printed.

Verified with an ASAN build of bpftool against a live kprobe_multi link
of 3 symbols:

  before: ERROR: AddressSanitizer: heap-buffer-overflow READ of size 8
          at link.c:860 (show_kprobe_multi_plain) and link.c:352
          (show_kprobe_multi_json), 0 bytes after the 48-byte
          get_addr_cookie_array() allocation
  after:  clean output, no ASAN report

Fixes: edd7f49bb884 ("bpftool: Show kprobe_multi link info")
Signed-off-by: Yuan Chen <chenyuan@kylinos.cn>
Acked-by: Yafang Shao <laoar.shao@gmail.com>
Acked-by: Quentin Monnet <qmo@kernel.org>
Link: https://lore.kernel.org/bpf/20261010074435.1415234-1-chenyuan_fl@163.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/link.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/bpf/bpftool/link.c b/tools/bpf/bpftool/link.c
index bdcd717b0348f..ddcdd8754add7 100644
--- a/tools/bpf/bpftool/link.c
+++ b/tools/bpf/bpftool/link.c
@@ -364,7 +364,7 @@ show_kprobe_multi_json(struct bpf_link_info *info, json_writer_t *wtr)
 		}
 		jsonw_uint_field(json_wtr, "cookie", data[j].cookie);
 		jsonw_end_object(json_wtr);
-		if (j++ == info->kprobe_multi.count)
+		if (++j == info->kprobe_multi.count)
 			break;
 	}
 	jsonw_end_array(json_wtr);
@@ -799,7 +799,7 @@ static void show_kprobe_multi_plain(struct bpf_link_info *info)
 		else
 			printf("  ");
 
-		if (j++ == info->kprobe_multi.count)
+		if (++j == info->kprobe_multi.count)
 			break;
 	}
 error:
-- 
2.53.0



