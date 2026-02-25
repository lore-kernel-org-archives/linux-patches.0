Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7029242D9B;
	Wed, 25 Feb 2026 01:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982893; cv=none; b=SEweiPOWD2dh3LMPtKdNCJXxoi1tQc+GLNUYyq4s2d7hwSx8w4XOiwDOdssD7Xhu9lNyGfATkJawGAatu2P3Z7CHamOEpzdPHQejfeL2VDo8sa1H0uv07UTC+E73UjfHO85esS/eDSE637BhUm7UQwrJmmor73hy9OSasQ0cH9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982893; c=relaxed/simple;
	bh=LQ/AVFjN5E5JeIbkHfxjscqeZQSSAfOjzHsiq6KLhVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eGpWKrEhUF+PUQfpdo9eHLk2TDnoJDxE2MiV9Zv1Tdqa/eN/Rf3z1XOoKLeMUePjPZDpODLMMlXVGHtCBYnI62u2wkVlz3EmCb+U1iLKwq26EgGmMX3ID+Tw+Vjixo6tnZYvp8E6YenIJzGMtg1vJxY8OVF06laEYM2fQn79ZfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iKRO24yb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iKRO24yb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EC3BC116D0;
	Wed, 25 Feb 2026 01:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982893;
	bh=LQ/AVFjN5E5JeIbkHfxjscqeZQSSAfOjzHsiq6KLhVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iKRO24ybZiw2TAc9ALpmPit6/8sa52ZbOSIs4kypiVr7C5eKfW49ZpFoYN1OzP3/V
	 KQ9eUp4EpxDAUY4w8o63bvgwwacCJhwhfjZRZ59e9+npzP772Le6B7TcO0AK76H0qu
	 +0MjbQZ8Nst0O5kgC6bHfb4f1YIlkBbomLyoFoEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Protopopov <a.s.protopopov@gmail.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 078/781] bpf: Return proper address for non-zero offsets in insn array
Date: Tue, 24 Feb 2026 17:13:07 -0800
Message-ID: <20260225012401.615956904@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

From: Anton Protopopov <a.s.protopopov@gmail.com>

[ Upstream commit e3bd7bdf5ffe49d8381e42843f6e98cd0c78a1e8 ]

The map_direct_value_addr() function of the instruction
array map incorrectly adds offset to the resulting address.
This is a bug, because later the resolve_pseudo_ldimm64()
function adds the offset. Fix it. Corresponding selftests
are added in a consequent commit.

Fixes: 493d9e0d6083 ("bpf, x86: add support for indirect jumps")
Signed-off-by: Anton Protopopov <a.s.protopopov@gmail.com>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Link: https://lore.kernel.org/r/20260111153047.8388-2-a.s.protopopov@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/bpf_insn_array.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/bpf_insn_array.c b/kernel/bpf/bpf_insn_array.c
index c96630cb75bf7..37b43102953ee 100644
--- a/kernel/bpf/bpf_insn_array.c
+++ b/kernel/bpf/bpf_insn_array.c
@@ -126,7 +126,7 @@ static int insn_array_map_direct_value_addr(const struct bpf_map *map, u64 *imm,
 		return -EINVAL;
 
 	/* from BPF's point of view, this map is a jump table */
-	*imm = (unsigned long)insn_array->ips + off;
+	*imm = (unsigned long)insn_array->ips;
 
 	return 0;
 }
-- 
2.51.0



