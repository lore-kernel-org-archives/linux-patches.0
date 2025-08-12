Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A63C26FA77;
	Tue, 12 Aug 2025 19:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025669; cv=none; b=KAnKsVaYPvV7Si0oYVZM7a7eMaT/SZ8BULpjefwvZub+qvOfFcYNdbuYzVhT8T7i/v0diIhQnl6xCqi5/cpv3kf5WEJn1hSTeSc4gnrfbp477OIGA4ItQXazF7sdUntM1deSonyHOBWfYWNaGnQQbfqyxnifW8dF92kR3I7csh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025669; c=relaxed/simple;
	bh=pQEe6YRGp78XzOwaeXKQkGMlpjyzPing/eGumihr0Nw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F34Gc1OkZMhQC4kQqHoZAX7RBHlKYAtjK9WuJNPyxxzkcmW3v5Sp3F2fYxtXFlffJyP68vTpExy6gVbQIT2CUH4cJbbTsI4Z37UpaXsmpnseDWCDsxDV/FRaPsXPaGs4gYJn4PMEUbYkNNqooEHzmk1gCmKICKWYBCLyFyzOlQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xCgrWE/l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xCgrWE/l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 990CEC4CEF0;
	Tue, 12 Aug 2025 19:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025669;
	bh=pQEe6YRGp78XzOwaeXKQkGMlpjyzPing/eGumihr0Nw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xCgrWE/lp89uahL79aYah+q1pniNlDdNdTyCJ3BtbM1epstTWicdu8eWljxE1/k8H
	 e1Wc8otmMgc60zrk8QFe4fJd0eUn0DzyDmy0RFslqgV91uIGc6SasT1OvWqSjFQn/n
	 0nSYloDd3xKrnvIwbxJx5LoCj44ugJZqVM05DMOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a36aac327960ff474804@syzkaller.appspotmail.com,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 108/480] bpf: handle jset (if a & b ...) as a jump in CFG computation
Date: Tue, 12 Aug 2025 19:45:16 +0200
Message-ID: <20250812174401.940773605@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

From: Eduard Zingerman <eddyz87@gmail.com>

[ Upstream commit 3157f7e2999616ac91f4d559a8566214f74000a5 ]

BPF_JSET is a conditional jump and currently verifier.c:can_jump()
does not know about that. This can lead to incorrect live registers
and SCC computation.

E.g. in the following example:

   1: r0 = 1;
   2: r2 = 2;
   3: if r1 & 0x7 goto +1;
   4: exit;
   5: r0 = r2;
   6: exit;

W/o this fix insn_successors(3) will return only (4), a jump to (5)
would be missed and r2 won't be marked as alive at (3).

Fixes: 14c8552db644 ("bpf: simple DFA-based live registers analysis")
Reported-by: syzbot+a36aac327960ff474804@syzkaller.appspotmail.com
Suggested-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20250613175331.3238739-1-eddyz87@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index c12dfbeb78a7..a1ecad2944a8 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -23657,6 +23657,7 @@ static bool can_jump(struct bpf_insn *insn)
 	case BPF_JSLT:
 	case BPF_JSLE:
 	case BPF_JCOND:
+	case BPF_JSET:
 		return true;
 	}
 
-- 
2.39.5



