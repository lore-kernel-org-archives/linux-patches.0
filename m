Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A83E72572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:38:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EABEC433D2;
	Tue, 18 Apr 2023 12:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821501;
	bh=IhoVdGbYtAUE0wgqUSDPkAsmTE02piyLX9dU+fk1gX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PJ/3Wil1slqhnVUcZSE5HwrbQP7xBouDN485U8mCMI23mMADZoqSqbgCdbEKi0WNz
	 7KER9OkCNlbfsIl6JKqRwucmp5uZUETWOSgt5xDUg2RNDpiIs1+O7ndlaCLVEx5lR6
	 aqYu2SWpmlXGySSHy+jX5lAcEtb/tVQUlnpxM0QA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 25/91] bpf: tcp: Use sock_gen_put instead of sock_put in bpf_iter_tcp
Date: Tue, 18 Apr 2023 14:21:29 +0200
Message-Id: <20230418120306.466581509@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120305.520719816@linuxfoundation.org>
References: <20230418120305.520719816@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Martin KaFai Lau <martin.lau@kernel.org>

[ Upstream commit 580031ff9952b7dbf48dedba6b56a100ae002bef ]

While reviewing the udp-iter batching patches, noticed the bpf_iter_tcp
calling sock_put() is incorrect. It should call sock_gen_put instead
because bpf_iter_tcp is iterating the ehash table which has the req sk
and tw sk. This patch replaces all sock_put with sock_gen_put in the
bpf_iter_tcp codepath.

Fixes: 04c7820b776f ("bpf: tcp: Bpf iter batching and lock_sock")
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20230328004232.2134233-1-martin.lau@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_ipv4.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 0e1fbad17dbe3..63472c9b39ae4 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2760,7 +2760,7 @@ static int tcp_prog_seq_show(struct bpf_prog *prog, struct bpf_iter_meta *meta,
 static void bpf_iter_tcp_put_batch(struct bpf_tcp_iter_state *iter)
 {
 	while (iter->cur_sk < iter->end_sk)
-		sock_put(iter->batch[iter->cur_sk++]);
+		sock_gen_put(iter->batch[iter->cur_sk++]);
 }
 
 static int bpf_iter_tcp_realloc_batch(struct bpf_tcp_iter_state *iter,
@@ -2919,7 +2919,7 @@ static void *bpf_iter_tcp_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 		 * st->bucket.  See tcp_seek_last_pos().
 		 */
 		st->offset++;
-		sock_put(iter->batch[iter->cur_sk++]);
+		sock_gen_put(iter->batch[iter->cur_sk++]);
 	}
 
 	if (iter->cur_sk < iter->end_sk)
-- 
2.39.2



