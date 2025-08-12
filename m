Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9536C284685;
	Tue, 12 Aug 2025 18:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024850; cv=none; b=PjG39EAkvfHGMomb/qqzGnKYpQCEJNcKoTZ0SpF2ugmDNQegvI5lx5EBUUdM+Bj75uOQ6iKFHTDqH4fmcxB+CGW1KNNv7xnSR7GmBM/uWkUgh0aGN0QyOvKwiankkz158WEZ5xQAY5Bq7e3kTL2Ja1gd6WndVWy92N4qTQRinDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024850; c=relaxed/simple;
	bh=hee5B8MHsciLHMcnNK3ufgTMQlPxB1zw0ORa9OI4JMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GcNhnSx2rYOWev3LxVxxW5Rf4Gkl1gGqjdgb6VJ+RQYiDDrx5ATGv+1PyUa9x2KA30iLby3wmE0FuueirjZkYCaQIeW5aszpE7bFJ3JTu0P+QsJWHAm+yqtXgOxvZYRmF56i2yOAchnGF0Kis2amZSGjChZWaDjh1TOPwBFVZpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KCxY+lH1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KCxY+lH1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 056AAC4CEF0;
	Tue, 12 Aug 2025 18:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024850;
	bh=hee5B8MHsciLHMcnNK3ufgTMQlPxB1zw0ORa9OI4JMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KCxY+lH1r1avSHdRY9S+R216vuD8/OZpMIYAOFYZAhE8ZCGgl5dHEcQphBMOIrq83
	 nk7gTThNtjP0hc+YqbXeAQCPj6PSVFoHT9wZD5lZJIBRNEebsp7VM2HnvwLMg/Bmzn
	 prLbGYLisa6DPxIHKL9EomHbwb+0peDQSEMBgtrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Yonghong Song <yonghong.song@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 452/627] bpf: Check netfilter ctx accesses are aligned
Date: Tue, 12 Aug 2025 19:32:27 +0200
Message-ID: <20250812173437.426835416@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Chaignon <paul.chaignon@gmail.com>

[ Upstream commit 9e6448f7b1efb27f8d508b067ecd33ed664a4246 ]

Similarly to the previous patch fixing the flow_dissector ctx accesses,
nf_is_valid_access also doesn't check that ctx accesses are aligned.
Contrary to flow_dissector programs, netfilter programs don't have
context conversion. The unaligned ctx accesses are therefore allowed by
the verifier.

Fixes: fd9c663b9ad6 ("bpf: minimal support for programs hooked into netfilter framework")
Signed-off-by: Paul Chaignon <paul.chaignon@gmail.com>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/853ae9ed5edaa5196e8472ff0f1bb1cc24059214.1754039605.git.paul.chaignon@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_bpf_link.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_bpf_link.c b/net/netfilter/nf_bpf_link.c
index 25bbac8986c2..c12250e50a8b 100644
--- a/net/netfilter/nf_bpf_link.c
+++ b/net/netfilter/nf_bpf_link.c
@@ -295,6 +295,9 @@ static bool nf_is_valid_access(int off, int size, enum bpf_access_type type,
 	if (off < 0 || off >= sizeof(struct bpf_nf_ctx))
 		return false;
 
+	if (off % size != 0)
+		return false;
+
 	if (type == BPF_WRITE)
 		return false;
 
-- 
2.39.5



