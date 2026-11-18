Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019624;
	b=YDyXVhxoo3UkDkdbrWwhJX71zWd8VRfXagiA9wG5sKBuQXzpKQS3uRAX/IMvvcUStS2k
	 Su/X9P/Xk3RjMYBiy7on+Jky7MTmEQHJb63K7Rjnw8extHUM7xEDrzbxCz38CALOype1R
	 wSQKBRKw7g+rhIsdWQJuNaz2wIVXgMQZDnwnILNGeKdVZEmxi5A2EtObYbLasp4rmpv3R
	 4nslquEK5B/F0dA6ub2RALesmAp2rMSyDg8XRQL6VmvQuiWANDcRwlH2MTY+4GSj++ULF
	 pziBcm+q4qPZcy4w09IafitCyEz66SA/RXUzCaQ47x3x6TM7jkcT5peGh8Xw2zsnCHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019624;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sOC+g0daScttdl2DvbaBrUVGuYmlA9bq+BZ0MwWLrIs=;
	b=eEmWITjHd9RHZiBk+aV+kxbAT8EEh0WYEE6++Vi8rgYdNLc+Ov+QAOJ+4S/qFmHWIL3W
	 jv4C+FInhOTpZd41G5YTy72tuz21A4oNdp61CD2E5e11ezs07BNxgt5pRx5nSJ/wVIMMz
	 Qq1URI0G455GXUZKQv3SdEA3Jl0rYpXsmTgSK9hc51f2Iwov/3VJnPsA3P93hQ+efhKLL
	 YcPKZqHBpgjds22vHZbJDaJ8Gfd2jIlAugNxVqJ5YXQuPwR3cEVrMCAgP5JjYX/UeySug
	 olJr+iu4P5isv4wQP5YchZ8M5nIQhG7bG94Af8FGj963+VDoSPOcLuCHnG6YiFDDWHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bn0+iT8J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81AB9606A331;
	Wed, 18 Nov 2026 16:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bn0+iT8J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D24E81F000C5;
	Wed, 18 Nov 2026 16:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019624;
	bh=sOC+g0daScttdl2DvbaBrUVGuYmlA9bq+BZ0MwWLrIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bn0+iT8JVs6CHu+JWyIr8+sRo6yK6AhB44CryF6eSddVNKQKKRcQgrAEWnBWwaEPT
	 +3VtwWzmq8qCzmRskvgXx4GXxYhNz/ODJaQP+ZUSRuGBh1Sqfl3HLAa9E0zYh1FI2i
	 7JAGrNQn6QtWJGQntg8l92MKUDphwBG95Amckqfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Yafang Shao <laoar.shao@gmail.com>,
	Quentin Monnet <qmo@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1622/2651] bpftool: Fix out-of-bounds read in kprobe_multi link info dump
Date: Wed, 18 Nov 2026 15:47:42 +0100
Message-ID: <20261118150346.251196221@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 088d1d206065f..5cffa2d283b47 100644
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
@@ -867,7 +867,7 @@ static void show_kprobe_multi_plain(struct bpf_link_info *info)
 		else
 			printf("  ");
 
-		if (j++ == info->kprobe_multi.count)
+		if (++j == info->kprobe_multi.count)
 			break;
 	}
 error:
-- 
2.53.0



