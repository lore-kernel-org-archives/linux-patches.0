Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031436;
	b=waRhhPuYpgGfWiee312CVjCVStTaaC58aRMh9RxHIzoWgefX1qHwOq5OfdJfX6QQngxP
	 VMk/G0/xBYk5kubeAI189E0ZkjaB90qH4Zkuong16eox6eRU50ubnuT/4jOWKjnZTSSO4
	 MOcflZXWfjO/iPiLir06u3fAUdQ5e5GPV4bQim/rwXxEPPH0toOnpMToQJ2kVomQQw6Aq
	 DuBoONFGlY24zvJcjGrvPIZxqkho59/LvxkyNQ9hMeIcN6KBn1N68LiI9TUHb/Yq1STtv
	 5id8Putv0wyRU86uGVsGZozsbgyu/340Rac/TyD10pmSQjFw7jjIlCImqKZpIonT1PA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031436;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uO+Z+BCKnEqTlc2BDHx3l/a1OY4evlcdtfVKEffTjyg=;
	b=hYkz3OGdPd03nDiapVlsWAf4XeMbgSBvSKqbED86OscondGPT8kYMcL3g4HDUHorhiMg
	 9b4q3lR3l7dU4Ldgn+5hwiLPIsq8YD/f2YskyILYeUtr+cfvEfGmHegybFhr0rEX+t2Ec
	 UG6Yb/HQswthrj7+ITswGCvjCz4AdYk+UTbRCPufXWnZOKkV0DjyhA0ferx1RLFOjD6NC
	 qTNQENfrd/2j69m3gmp2dSzpML5XDVfaGmsnpmfAxlIKetqo6nrOysB+J/6tU/VW4Q6yM
	 SfYneuZYbmXwSVfUO1nphcYX97mwYDDCFIsHGj/uW/tUHTG+JaU3BW9wnuCmIlMjJww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h4xRpUEN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A399960A2603;
	Wed, 18 Nov 2026 19:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h4xRpUEN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B60C71F000C5;
	Wed, 18 Nov 2026 19:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031436;
	bh=uO+Z+BCKnEqTlc2BDHx3l/a1OY4evlcdtfVKEffTjyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h4xRpUEN60gJcZcEy+agSm1lh/FlD0R9isiOJ98OBs4IX4degeCNisrrsqzV+EZsO
	 LlG86wpdKtU5yWSkQ/3wreh0uOFt53jBS/0x8kbR4dfqTXX8ZSN1q8cKWKgmArNVvF
	 Z8Uue+WKeMMGxa9QA2TVmQJ5fcPfZGto3xs//2Iw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Yafang Shao <laoar.shao@gmail.com>,
	Quentin Monnet <qmo@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1056/1756] bpftool: Fix out-of-bounds read in kprobe_multi link info dump
Date: Wed, 18 Nov 2026 15:53:03 +0100
Message-ID: <20261118150052.271665974@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 52fd2c9fac56e..fa6c1ca59a52d 100644
--- a/tools/bpf/bpftool/link.c
+++ b/tools/bpf/bpftool/link.c
@@ -321,7 +321,7 @@ show_kprobe_multi_json(struct bpf_link_info *info, json_writer_t *wtr)
 		}
 		jsonw_uint_field(json_wtr, "cookie", data[j].cookie);
 		jsonw_end_object(json_wtr);
-		if (j++ == info->kprobe_multi.count)
+		if (++j == info->kprobe_multi.count)
 			break;
 	}
 	jsonw_end_array(json_wtr);
@@ -750,7 +750,7 @@ static void show_kprobe_multi_plain(struct bpf_link_info *info)
 		else
 			printf("  ");
 
-		if (j++ == info->kprobe_multi.count)
+		if (++j == info->kprobe_multi.count)
 			break;
 	}
 error:
-- 
2.53.0



