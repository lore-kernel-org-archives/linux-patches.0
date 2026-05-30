Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 688A839A7FE;
	Sat, 30 May 2026 18:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166462; cv=none; b=nMKfp7BK1zzraNcNwKN0IJ4yiVQJ8TBYEMQGIjEEkRUhiUlCyPSjUGRR+2cNYc4a2GHn4n6y5BntCcmJUutIGytJoMNCvat2mI5ZOJ3+yowlDt6HQBFtVndaAO964hXDhipX2G0J8oyrBRxRSlI4YhkHn2Y/aM2FBD5DGOf3w2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166462; c=relaxed/simple;
	bh=1i53uHVP/MHVz35horkNTyi6Uvr+h2fBSdZnk0/H+u8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k//s8GFhAMCokEXgoBa74vkZY6qJDbzgGlAPwssk+CkQo8oEfc/q+PTh8zZVDrq3yvLSiYMBIz28G209twAJtDNm9nBOz4g9X+BYa6RWyjd6m1UI2kooImEnfyryO1wNez8XuV2DSjnUIL3vFjbyqra/NXSSSgHKHvds62Tsmus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BSDRRGJl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BSDRRGJl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A87DB1F00893;
	Sat, 30 May 2026 18:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166461;
	bh=5uFzvdOXJfGc0YxH1RltStvmry72pqHYrpgV/AjCxtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BSDRRGJl3GQkTaIdSDquGldOMm5/KvrrfA0brInRa2G2VzJIS97yB1K63QCs9Ldp0
	 9gV0oeWV/aT9MfCMiw0ZMF0ornywuI8MyAYuUGcLLqGuivESn6xUnNxSIvDXry4Tee
	 FX5FLNrHnfRZx5uTXXjnYZB8mpgzogIId257lVJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 380/589] bpf: Fix precedence bug in convert_bpf_ld_abs alignment check
Date: Sat, 30 May 2026 18:04:21 +0200
Message-ID: <20260530160234.788688564@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit e5f635edd393aeaa7cad9e42831d397e6e2e1eed ]

Fix an operator precedence issue in convert_bpf_ld_abs() where the
expression offset + ip_align % size evaluates as offset + (ip_align % size)
due to % having higher precedence than +. That latter evaluation does
not make any sense. The intended check is (offset + ip_align) % size == 0
to verify that the packet load offset is properly aligned for direct
access.

With NET_IP_ALIGN == 2, the bug causes the inline fast-path for direct
packet loads to almost never be taken on !CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
platforms. This forces nearly all cBPF BPF_LD_ABS packet loads through
the bpf_skb_load_helper slow path on the affected archs.

Fixes: e0cea7ce988c ("bpf: implement ld_abs/ld_ind in native bpf")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/r/20260416122719.661033-1-daniel@iogearbox.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 7002368d1592a..b8d891f79b983 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -489,7 +489,7 @@ static bool convert_bpf_ld_abs(struct sock_filter *fp, struct bpf_insn **insnp)
 	    ((unaligned_ok && offset >= 0) ||
 	     (!unaligned_ok && offset >= 0 &&
 	      offset + ip_align >= 0 &&
-	      offset + ip_align % size == 0))) {
+	      (offset + ip_align) % size == 0))) {
 		bool ldx_off_ok = offset <= S16_MAX;
 
 		*insn++ = BPF_MOV64_REG(BPF_REG_TMP, BPF_REG_H);
-- 
2.53.0



