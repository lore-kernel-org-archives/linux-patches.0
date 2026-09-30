Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEAD151CF5D;
	Wed, 30 Sep 2026 18:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792744; cv=none; b=kYx6IKapEqJW/m4YqbpMCctDn9MeUANzE33WqFO1JPFt+fjIdH510mwBgFTtArS8JS06jEFRsktw+IBJRmAnknev6q+YS5vx+jioS5V8h8KI2kt2Q9Ujhd1ivhyZ3LqKaKJJspdniclU0Lxddf92hcTB9NUPTk6FmfRu84Cw7XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792744; c=relaxed/simple;
	bh=n6rDUN5i9pXjLPBMXENArj6XM7R9bl0oNTJj3qzO3Co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=riGzutCGAGvl5yUEf1u0OBhTMAEb2iN5yTBXPaFrrA9m7WsZkhHnDNyQ9iKS59nugn9Q7XFsmiGMNs2Ep4tm9IdvBCKYXGPMlnHIiYXTtw8U/CCWczDbqbW3k1Syf5x2x7VDl1BwkhFbrhHRId9JtYU6MKCgajgkxqdmCIfoc+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X0sFrFwm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X0sFrFwm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A8D61F000FF;
	Wed, 30 Sep 2026 18:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792743;
	bh=U+2rKLsyOI8LKPArd3Q4tZT+x4Zp3Wivx0L1NDzmUPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X0sFrFwmPg4qQ9LHA+fchJ7Ln9+4a+bCiOpAQMJ0GCAAmf5djRf7B6M1WS5fUp74O
	 HpohBr4Bw9sDNH4cfwrRBW+FsLIMBWrlkR59OGF0y88VsBbCL7VOCK7vmCcOmIDDjq
	 o+Hq8zN+CJiqCQlFv5eVvHDJDCE8t0tlZWIA7sDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+adfca3e91be95776@bugs.sh,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	Weiming Shi <bestswngs@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 011/395] bpf: Disallow bpf_skb_pull_data() for LWT_SEG6LOCAL
Date: Wed, 30 Sep 2026 17:24:33 +0200
Message-ID: <20260930152340.859033899@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit e4a62833adff6ef0fe7c0b90393204fe3c26b5c5 ]

An LWT_SEG6LOCAL program can invalidate its cached SRH with
bpf_lwt_seg6_adjust_srh() and then call bpf_skb_pull_data(). The latter
may reallocate skb->head, leaving the per-CPU SRH pointer dangling.
Post-program SRH validation then writes through that pointer.

Disallow bpf_skb_pull_data() for LWT_SEG6LOCAL programs so the verifier
rejects this unsafe helper combination. Other LWT program types continue
to expose the helper through lwt_out_func_proto().

Fixes: 004d4b274e2a ("ipv6: sr: Add seg6local action End.BPF")
Reported-by: co+adfca3e91be95776@bugs.sh
Suggested-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Closes: https://lore.kernel.org/all/GCy0KRM2IcQGoJQTjJEU9D0maBxXzEDHuQpq@bugs.sh/
Link: https://lore.kernel.org/bpf/DL9COXZQXX4V.1FN45QO2Q77ZH@gmail.com/
Link: https://lore.kernel.org/bpf/20260909040807.3885815-2-bestswngs@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index 42f5688dc1fab..0b849567afe9f 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8725,6 +8725,8 @@ static const struct bpf_func_proto *
 lwt_seg6local_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 {
 	switch (func_id) {
+	case BPF_FUNC_skb_pull_data:
+		return NULL;
 #if IS_ENABLED(CONFIG_IPV6_SEG6_BPF)
 	case BPF_FUNC_lwt_seg6_store_bytes:
 		return &bpf_lwt_seg6_store_bytes_proto;
-- 
2.53.0



