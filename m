Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041231;
	b=kw0F1Oket6jHNxbt3wJX6UumXHfWESl0kwPAjyW4l/67lnUsYAE89L02D9kH2MCZo6rf
	 OmXC4gLHWCEip730qyCpw2Fx4tbXVvdYS/VBzDC5OR3/qpxG9X7lPUED6qltYW93B3r4J
	 k05oM0DtNQc9uH8PQYJImKY1TvWyTTtHxHZJCKV3ruhdBmk7y6mikm3O+T0Cd7w94Ymt3
	 TEx0GQ6LpaRIAE2G0iGgqsWovTUYdz+V77jGigUApDWjBpqX0B284X0eNzvVno6rQr0wL
	 sJtDyfi+UXZYoLD2iigYPkHh3+xig1AShWVcIjkHieKHlp60SNm2Yj8ztNcbAOyT5JQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041231;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9AF4EwHb0709EpciPMaXKVos1OIencKAGIIM3qdu1To=;
	b=iNOdNNAjFzg+6yHv8iWXjJ0a9PZqRDQ8yU+Gm4nj33BC2O+GwwLQaLn8i6cvSoIcvRFM
	 cWpEqgQfrRkaMN0x6A5+9RQE8IDoRy7w4hrAGch2A43usYQSHEHIEXT1lvVhGTdkXHEg6
	 XaExihNXrIhvOfIuUv8NitY5HRZIMDbAeF4PzfdcJYLLZulYToiBs/TpVaYOjBjlSYQLc
	 TphMGsS3KPhbBY2mB/2i25S4Yu/TRsRly5RakemOwf8C/3U1iIaJAXl/zZ4mKlz1wi8SK
	 91G8qrrtEGdTM/ZYDBK/3u9a+Jel/auu2a4iP4+lsueSZvM8afMepFrbUyHQqEU15NQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nQZHSpSd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F2E606A320;
	Wed, 18 Nov 2026 22:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nQZHSpSd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BE971F000C4;
	Wed, 18 Nov 2026 22:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041230;
	bh=9AF4EwHb0709EpciPMaXKVos1OIencKAGIIM3qdu1To=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nQZHSpSdzkXA7Sm+tbIVcK2R75dOJlG8QPClLEFSRilwI4XBQwzajz4WNDSfYiH9s
	 cZbm9Na3AvkWt2Cu/QgqOo3p2ZQ0f2DyWdsHH+w0ql6m3lb6fyVCD5s62ySYnxv0Mb
	 7D+Ievhq+1Q0Nf7qr09vvCLURFDxgap9knbfB330=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Yafang Shao <laoar.shao@gmail.com>,
	Quentin Monnet <qmo@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2739/3318] bpftool: Fix out-of-bounds read in kprobe_multi link info dump
Date: Wed, 18 Nov 2026 15:56:01 +0100
Message-ID: <20261118150442.960594754@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 250d1cf82ed94..45ec889474720 100644
--- a/tools/bpf/bpftool/link.c
+++ b/tools/bpf/bpftool/link.c
@@ -287,7 +287,7 @@ show_kprobe_multi_json(struct bpf_link_info *info, json_writer_t *wtr)
 			jsonw_string_field(json_wtr, "module", dd.sym_mapping[i].module);
 		}
 		jsonw_end_object(json_wtr);
-		if (j++ == info->kprobe_multi.count)
+		if (++j == info->kprobe_multi.count)
 			break;
 	}
 	jsonw_end_array(json_wtr);
@@ -695,7 +695,7 @@ static void show_kprobe_multi_plain(struct bpf_link_info *info)
 		else
 			printf("  ");
 
-		if (j++ == info->kprobe_multi.count)
+		if (++j == info->kprobe_multi.count)
 			break;
 	}
 }
-- 
2.53.0



