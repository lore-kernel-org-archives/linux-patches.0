Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78BBC4E4C3D;
	Thu, 17 Sep 2026 15:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659307; cv=none; b=KrugzLtw7Modrj0+HAcuroRceqpEDPYL/pzzVIyyR1qS4cJBs9VtTcI41wmsjF+2uCBvTr5yPF36yz7WhAvoOTXkRBXE8t+pdXOc4ra/LYweKMOJV1U6aOyDN2LX62gRo53li5pPLlZRT7nnkqkMW6EFO0/cgJ9WHBNOhjE49rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659307; c=relaxed/simple;
	bh=URxrj2ZbbClfLHuLgNlIEG4Y5GHVZB4YcAkULZqKYRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MAiBNqGdkVEyaD+g8cBxWyC5VwYD43RCw6fttAfbxIXyzWsU6Huc2JewqO6iFnXvrfxlgFDPrWAeFg5ySSRK+VK0ky8JEBbXuRSTcPB9AsgphIXatUWVsS6nkaZcLg4CUTDktjmXmWT4214k1TfX0bNwUp/BGzEhgtn86XQezL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O2L+Ojg5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O2L+Ojg5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C12CB1F0089A;
	Thu, 17 Sep 2026 15:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659300;
	bh=qS2Za81BR3aShCFbZoEOyM37BYi3conpCeeu1ELkRuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O2L+Ojg5ifRzx6BAqQk9YLDReDliFMoQy1y2LQeZIzHDPSoQX74GGaD1Uso70QCGm
	 g8lvqLmz1MvKpAviTboF/vtRHQnaxf4qnWPgxjazfMhT12RyRNNgs5ZILWfj2UClTp
	 4wQfImb5PUQ5PkGYO8jvS78PX4EnVFSirAHZ/aOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 203/733] bpf: reject BPF_PSEUDO_FUNC reference to the main program
Date: Thu, 17 Sep 2026 16:08:31 +0100
Message-ID: <20260917151356.234517436@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: Eduard Zingerman <eddyz87@gmail.com>

[ Upstream commit 374b2c5561db80fcdd7cdce44af37a49416f61c7 ]

fixups.c:jit_subprogs() rewrites BPF_PSEUDO_FUNC loads to contain real
function addresses. This function is invoked from bpf_jit_subprogs()
only when env->subprog_cnt > 1. Meaning that for any program like
below:

  int main(void *ctx) {
    void *ptr = main;
    ...
    bpf_timer_set_callback(..., ptr);
    ...
  }

The 'ptr' won't be ever converted to contain an address.
In combination with e.g. bpf_timer_set_callback() this would lead to a
function call at a bogus address.

Instead of complicating the implementation, just assume that no useful
program needs main to be a sync or async callback and reject
BPF_PSEUDO_FUNC loads for the main subprogram.

Fixes: 69c087ba6225 ("bpf: Add bpf_for_each_map_elem() helper")
Reported-by: Nicholas Carlini <npc@anthropic.com>
Suggested-by: Nicholas Carlini <npc@anthropic.com>
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20260902233658.1186477-1-eddyz87@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 59f12ba70eb6e..b0118bccf3280 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -16291,6 +16291,15 @@ static int check_ld_imm(struct bpf_verifier_env *env, struct bpf_insn *insn)
 			verbose(env, "callback function not static\n");
 			return -EINVAL;
 		}
+		/*
+		 * When env->subprog_cnt == 1 this instruction won't be rewritten
+		 * to hold a real function address. Assume that no usable program
+		 * combines e.g. main and timer callback and just reject here.
+		 */
+		if (subprogno == 0) {
+			verbose(env, "callback function cannot be the main program\n");
+			return -EINVAL;
+		}
 
 		dst_reg->type = PTR_TO_FUNC;
 		dst_reg->subprogno = subprogno;
-- 
2.53.0



