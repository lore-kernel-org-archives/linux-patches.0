Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73594516165;
	Wed, 30 Sep 2026 16:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786851; cv=none; b=rSm2OX47UQkIREx8YOVDxdvzw7bD3+mc5vetUEa2yex9oB2DddMR149Njwe2gHON8pq2pzQn7gG2VM6vX4WMyCTVjSlkgR9zb8If+F7sW5xr59i9ej43B/phUMmIUkSrYaBOJuqqJnOHvsHlQODT3EQhQ2reCzHkl/jJJvmcFYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786851; c=relaxed/simple;
	bh=/Ot/uEGuEHT7irbbfYd20dzuWDop/WmPM+G7jFzJz4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z0AvqS5jKuiIzCoryU71Lo/gJ/n4bWCNvjCfKqsjF2GWlhOcMqKnYYcm5tizJ3QIsmRvdIA9k6lTwXOxfVaVc7R36OyOVstgQ7r7wFnKiHydLaW6M5rsTz1mgp6qD/yWArGxhsuWzizuj25KmAtc6K0DOYU2RMDGjEdap2w2Xz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hh1yzaFW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hh1yzaFW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 860721F000FF;
	Wed, 30 Sep 2026 16:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786850;
	bh=bef2HpVoY9S3b5uzqxCSK0HzCi5y/EzJXeSeQoOZfcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hh1yzaFWEIrz3dNdcXKI6M0xO8bSS4WxLVNkWtkeNATT1I7ijVn0lrCi3fiNbSbP5
	 83AKPvPmBtW2nYnJM+grfItU1hhKT5kgoh9GjertTfHNVHKEbMYQdDKJnlCeo9MqfI
	 3zAuyDXg2hReCU1if/mV7zjIH8Q3/MRRKfsYz9Qc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Chintamaneni <sidchintamaneni@gmail.com>,
	Anton Protopopov <a.s.protopopov@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 025/457] bpf: Allow terminal gotox instructions
Date: Wed, 30 Sep 2026 17:22:10 +0200
Message-ID: <20260930152346.574715376@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siddharth Chintamaneni <sidchintamaneni@gmail.com>

[ Upstream commit 0d7823cd4cda35f2060a685fa276ff7709915abc ]

check_subprogs() treats gotox as a direct jump and validates its reserved
zero offset. When gotox is the final instruction, this produces a
synthetic successor one instruction past the end of the subprogram and
rejects an otherwise valid program.

Skip direct-offset validation for gotox and accept it as a
non-fallthrough terminal instruction. Its actual targets remain validated
from the instruction-array jump table during CFG construction.

Fixes: 493d9e0d6083 ("bpf, x86: add support for indirect jumps")
Signed-off-by: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Reviewed-by: Anton Protopopov <a.s.protopopov@gmail.com>
Link: https://lore.kernel.org/r/20260902171414.96165-1-sidchintamaneni@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 1a0cd37b03cde..dc1a9ef32b78e 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2876,6 +2876,8 @@ static int check_subprogs(struct bpf_verifier_env *env)
 			subprog[cur_subprog].exit_idx = i;
 			goto next;
 		}
+		if (insn_is_gotox(&insn[i]))
+			goto next;
 		off = i + bpf_jmp_offset(&insn[i]) + 1;
 		if (off < subprog_start || off >= subprog_end) {
 			verbose(env, "jump out of range from insn %d to %d\n", i, off);
@@ -2889,7 +2891,8 @@ static int check_subprogs(struct bpf_verifier_env *env)
 			 */
 			if (code != (BPF_JMP | BPF_EXIT) &&
 			    code != (BPF_JMP32 | BPF_JA) &&
-			    code != (BPF_JMP | BPF_JA)) {
+			    code != (BPF_JMP | BPF_JA) &&
+			    !insn_is_gotox(&insn[i])) {
 				verbose(env, "last insn is not an exit or jmp\n");
 				return -EINVAL;
 			}
-- 
2.53.0



