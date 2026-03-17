Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1F03F23B3;
	Tue, 17 Mar 2026 16:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766411; cv=none; b=nqy1Y8xN5HCO1q+rXcfwO8WrZxW8YBJeUmzYu+WScm/LPk5i3BNwrJY5iS9KhZ5RR1gcYl+6cMK89xapm2ZELIv5j02i1ELorwssm8W/BFdEDAXC5VvXsVwW4NrjzNriQrncJTBxVM0h5/28AcNgSZmHVC2DfIQAxarKVTKnrkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766411; c=relaxed/simple;
	bh=cp7rlxu14zzRgVF3xHKERiOzjiIpUfm4QrOaS7SL8HI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g56y5IBvt6k1G5QV4B2Zt6RnoyjEoTpyUFTprG4y73bvN8H4TkuD3I86WIM/yvYs7pAXVy5jiUmcr7Bn5TJWDt0GaP9/SgA2lXGHmw3CCe/64cnURQtpgfKAf1aMg/aVVKU6LBkFLfz8XZhiJCqxJKPYjO0PNJZxv8IzQKVAdpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fc6cG+/s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fc6cG+/s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80576C19424;
	Tue, 17 Mar 2026 16:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766411;
	bh=cp7rlxu14zzRgVF3xHKERiOzjiIpUfm4QrOaS7SL8HI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fc6cG+/sEGuy2hwlU7sX0JWgAfCbvymWmDU3p+GURpdztn6tyOSEiA7SznQmS15mx
	 PPAwd9nGaIFJwBnOBKn1n/ubOAgmvaO3K3nZI3ijZKxmXOaqcbUjXvimY2gzq3QIO9
	 x5ATN3zpPaqZW+4RpBoH9qBGK+32t3TuAUdbkulk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.19 233/378] bpf: Fix kprobe_multi cookies access in show_fdinfo callback
Date: Tue, 17 Mar 2026 17:33:10 +0100
Message-ID: <20260317163015.584287547@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <jolsa@kernel.org>

commit ad6fface76da42721c15e8fb281570aaa44a2c01 upstream.

We don't check if cookies are available on the kprobe_multi link
before accessing them in show_fdinfo callback, we should.

Cc: stable@vger.kernel.org
Fixes: da7e9c0a7fbc ("bpf: Add show_fdinfo for kprobe_multi")
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20260225111249.186230-1-jolsa@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/bpf_trace.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2441,8 +2441,10 @@ static void bpf_kprobe_multi_show_fdinfo
 					 struct seq_file *seq)
 {
 	struct bpf_kprobe_multi_link *kmulti_link;
+	bool has_cookies;
 
 	kmulti_link = container_of(link, struct bpf_kprobe_multi_link, link);
+	has_cookies = !!kmulti_link->cookies;
 
 	seq_printf(seq,
 		   "kprobe_cnt:\t%u\n"
@@ -2454,7 +2456,7 @@ static void bpf_kprobe_multi_show_fdinfo
 	for (int i = 0; i < kmulti_link->cnt; i++) {
 		seq_printf(seq,
 			   "%llu\t %pS\n",
-			   kmulti_link->cookies[i],
+			   has_cookies ? kmulti_link->cookies[i] : 0,
 			   (void *)kmulti_link->addrs[i]);
 	}
 }


