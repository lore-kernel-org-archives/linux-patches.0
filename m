Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74CC01E0DD8;
	Wed, 30 Sep 2026 16:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787218; cv=none; b=a33TD3SbM/Zqfn3JzYOwWJ/ydyuqvag7NvIMPk3vcN57v5oKgWasLvbMsuJFm2fjgR7jBJLSKRqcPBzs8rgD4EVTiAnvBeE/d3rMxO+hf/jK3P1y+G4iQd8n7L27u00aXyLaqUtRBVMlQyXXzc9DfSuakS6Yr95p5/w30jG7jGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787218; c=relaxed/simple;
	bh=cyr4xFid+iXTO8BA5d2PKM08uvTlOomwZfHQSeM4jvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kRdCgHF2Rd9bAFNv1WvzyOBs5L93WEpzpawVITWowPqDYY4WEvonbbqVL7MP/5n6qv4rxHZtsoNHToEkRuTLyqO6mopu8XSd1HbMTtgPxOt65rTEV7EuF16MRyBu7xcQB3Iq/UbIeJWlCTUV4/9HnEo/Aj/oUf2GKf8kiK4DA8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o/z6wCqU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o/z6wCqU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D14651F000FF;
	Wed, 30 Sep 2026 16:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787217;
	bh=s4HIno7lU6DmLjawx+6Allt/O3wNa5sBK4oa4THI3rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o/z6wCqUBdp7qpYy2U6VI4eeQBgXeo2vErx/VluWWGDgwtk8nczVOZIcXfule/oOt
	 Btx2t4MVsGk6gLUGoR95tMkjc0Lng3nHt3UvCA5V6yWg8iBMFk4Ua8yw0Qgv+6Rx9F
	 8y13wGSkRQ1E8aqYMRhHIYPT2RBRbXPfoeZNn81g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <nicholas@carlini.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 151/457] bpf: Reject pkt arguments in mutating subprogs
Date: Wed, 30 Sep 2026 17:24:16 +0200
Message-ID: <20260930152349.309998201@linuxfoundation.org>
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

From: Emil Tsalapatis <emil@etsalapatis.com>

[ Upstream commit a6c1edfbe240e4377038a0e1d233ad81fde9a21b ]

The verifier tracks changes in how PTR_TO_PACKET registers'
bounds are modified across subprog boundaries. PTR_TO_PACKET
registers are actually passed as PTR_TO_MEM, which is assumed
valid for the entire call. This is not the case with packet memory,
where a pskb_* call may invalidate its memory region.

Reject BPF code that passes PTR_TO_PACKET pointers to subprogs that
may mutate a packet. We cannot pass the pointer as a true PTR_TO_PACKET
because we would also need to somehow pass the PTR_TO_PACKET_META
or PTR_TO_PACKET_END to the subprog. Since we cannot avoid representing
the pointer in the subprog as PTR_TO_MEM, only permit it if the
subprog is guaranteed not to mutate the packet.

Fixes: 80f281664f5a ("bpf: Support pointers in global func args")
Reported-by: Nicholas Carlini <nicholas@carlini.com>
Suggested-by: Nicholas Carlini <nicholas@carlini.com>
Signed-off-by: Emil Tsalapatis <emil@etsalapatis.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20260922172028.6269-6-emil@etsalapatis.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index cb523cc5465dd..ccf735d74dc82 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9264,6 +9264,16 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env, int subprog,
 				return ret;
 			if (check_mem_reg(env, reg, argno, arg->mem_size))
 				return -EINVAL;
+			/*
+			 * PTR_TO_PACKET get passed as PTR_TO_MEM, preventing
+			 * us from adjusting bounds tracking info.
+			 */
+			if ((reg_is_pkt_pointer_any(reg) || reg_is_dynptr_slice_pkt(reg)) &&
+			    sub->changes_pkt_data) {
+				bpf_log(log, "%s is a packet pointer, but func#%d may change packet data\n",
+						reg_arg_name(env, argno), subprog);
+				return -EINVAL;
+			}
 			if (!(arg->arg_type & PTR_MAYBE_NULL) &&
 			    (type_may_be_null(reg->type) || bpf_register_is_null(reg))) {
 				bpf_log(log, "%s is expected to be non-NULL\n",
-- 
2.53.0



