Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43D2225A38;
	Tue, 17 Mar 2026 17:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767953; cv=none; b=FnFKoZ0exR+gLKFdxFVccipW9/d1spbc1aSwxT18V5cJaBvS0CCyUaGD7tbXEIM5hgLhd1Cg3abdAfAR/ZN/lwx5SU4807R35Shx6R3yLyFYwU6WxmWyC5iWwqZwrBcGaGJbFvCzF5G6rceYUoeW87eyKhJ5gO/GheFqqkjsr4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767953; c=relaxed/simple;
	bh=2fJJJAeCeAtL+J/RBrjx0Q29GFyfq/0eqvhy3Btr0I4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lWvRPghxl3SSWwqBniYGmpuFc5Q7xo0Yf3949lvwMtdArZy6pQbNO3RGiY0A3db/dHA9dPIzqxscJndIh0MXT3ot5+anX8a4HaK2OgSLLX8oWwePfAeasi9LNLMNPxhMOgs/oflt6JfakZI9hk+7WnkG69dlkxBO5PQ/BEhjlwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MRY/YkpV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MRY/YkpV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 544D2C2BCAF;
	Tue, 17 Mar 2026 17:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767952;
	bh=2fJJJAeCeAtL+J/RBrjx0Q29GFyfq/0eqvhy3Btr0I4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MRY/YkpVTK/txtnEUYnKlyvD4H1w22D4a880qVd3lPEBXvt2Ozife8iHUDgZNU5zx
	 oHhtLqBatYZq0PEl2w89GE6mc2EccYs5P1rf9Bm6wAIPOGzVOHBIwpWW9FymwK+hYt
	 UtIgu69Ef47uqch95UT6KeHxpP0egB+aLijSYY3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.18 198/333] bpf: Fix kprobe_multi cookies access in show_fdinfo callback
Date: Tue, 17 Mar 2026 17:33:47 +0100
Message-ID: <20260317163006.699626981@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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


