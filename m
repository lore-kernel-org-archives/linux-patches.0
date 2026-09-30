Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BCCC3B994F;
	Wed, 30 Sep 2026 19:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795172; cv=none; b=fesVduf3iIPJ3KhYSYbUqwWSAufTXy7LSU68w3xPm6GdYHOuqqsf63Ko0ZayH4e4Ydln8TJsqeuTRjULlwqSTCsSyvetRPATjpSb4gudWY2DPHus97mLnoCCjxKvnkjGyNMijw0TC+gWMC4FGZ1W1uv/o5KoDVOqPLzMoPK8mMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795172; c=relaxed/simple;
	bh=rzb7X1ICMJ4aTp/BUm3XcXr3fBRQxdXC+w82mkyHrfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V6yNFy4HH9Nmwv1uRnc+miPhKDkQ0/WRLnkcvY0pJP1Z/GDfM6bsn5s1gLDpAJxmnzyG/hL2AVsmYcFfVClg52gd9ymBjOhAMV2htjpC3lHQ9aRAIp37bW7gCYP3HVfOiXKpO3CelFcF+ZshRLbKiT8w3xjF0KXUrOyigZv8v+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UBEhy0RJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UBEhy0RJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5B3F1F000FF;
	Wed, 30 Sep 2026 19:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795171;
	bh=3kUU9/oNRoCfpJviIfz3kIfFTjhD2Sl4oJyP+VxQhek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UBEhy0RJ/6/e4f9qiC3h6NXu8XCNGUek33x9ExFd16EdtMNcbSbxJDF+79yuZonXO
	 zDC4l1V+dowP2f9yCOxNerhjDcapFpgHth1bqD0ABV1Lwq8xMJ0m/sk4CX3k9G1xFj
	 Vsql0KTIftyrOe50drBnRXFi2RweyukgXa0YA2Ow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0466/1193] bpf: reject BPF_PSEUDO_FUNC reference to the main program
Date: Wed, 30 Sep 2026 17:19:10 +0200
Message-ID: <20260930152444.524556679@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f7f5f54dc4485..0f85d5f3ecf9a 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -14994,6 +14994,15 @@ static int check_ld_imm(struct bpf_verifier_env *env, struct bpf_insn *insn)
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



