Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFCA44FDA49;
	Tue, 13 Oct 2026 12:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894029; cv=none; b=jSPPyLfM1wsQY6MbKqB18fL4BD4tdOp6e0hZXQYiVKGrW4OcT8LNbvrkNl1B6gfppqfe/Fev+N9PvCYP90efntHaWdgB5nxeHU8IHRNUTAWYM3s8rseXxgd3OXAAWQnepMeJJeFN5nKa6jfC98HhlClSXZbvu1rv/h8gTp1EPJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894029; c=relaxed/simple;
	bh=CNP9QEjsWHv/hd6Q3dzUt+uEMgBn9QLLkwTYAPgc4F0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G6wjrDdeTFehFf1WYrm6NfD/Aiiv1gfuTol72ZOqCJAtDPxkszYeuTbhN6u89ACjMC2TZFg27J8cy596P1l/HXcUwtZy8BHG+tSSukVwN+e3n7ztDB6LskpwVPDo2ptKCzY9nF7SMDppf3lwM54CIZVGfeDTPE5ydgZSjIn7BxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fpCfSjoH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fpCfSjoH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEC051F000FF;
	Tue, 13 Oct 2026 12:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894028;
	bh=OuQld2ev55ycDKQFIeYgRAcyC5i2DjKr4fYQ+55Ygoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fpCfSjoHJmjOKk/C0TcbRp2sia69KDV9quFn23ElXlR467vYJ90WYUH1Kq8YdEPv4
	 gThCXXfO8vJ0DLzI43ueJnsapb1Z3BWYngfGw04jjjsTPtdy3CgyWhAAMDh33jrTDE
	 DhMiB6j4MhXZF0x9PBmxpDP5DTWbCRwOI/HAOwBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ning Ding <dingning04@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 422/621] bpf: Compare iterator types during state pruning
Date: Tue, 13 Oct 2026 13:36:57 +0200
Message-ID: <20261013112930.849293309@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Ning Ding <dingning04@gmail.com>

[ Upstream commit 83608e303b95d07afba1c15da0b5d9e513c2f15a ]

An iterator stack slot can be MEM_RCU or PTR_UNTRUSTED. These states
must not be equal, or the verifier can prune an unsafe path.

Compare the pointer type for STACK_ITER slots.

Fixes: dfab99df147b ("bpf: teach the verifier to enforce css_iter and task_iter in RCU CS")
Signed-off-by: Ning Ding <dingning04@gmail.com>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://patch.msgid.link/20260811035955.132989-2-dingning04@gmail.com
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 8cd9526c0dac9..947b501a58aee 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -19488,7 +19488,8 @@ static bool stacksafe(struct bpf_verifier_env *env, struct bpf_func_state *old,
 			 * infinite loop check triggering, see
 			 * iter_active_depths_differ()
 			 */
-			if (old_reg->iter.btf != cur_reg->iter.btf ||
+			if (old_reg->type != cur_reg->type ||
+			    old_reg->iter.btf != cur_reg->iter.btf ||
 			    old_reg->iter.btf_id != cur_reg->iter.btf_id ||
 			    old_reg->iter.state != cur_reg->iter.state ||
 			    /* ignore {old_reg,cur_reg}->iter.depth, see above */
-- 
2.53.0



