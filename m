Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D29235C69B;
	Tue, 21 Jul 2026 21:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668873; cv=none; b=VUIm7j4+CbNd4QiKgsToVNe7L+m73tj4wBZuUBWTRNr2ZyWrzEa+k3WORacy2UMitQnD09D6PpFOnwbeIKXAewFlWPKjWDpCLtXCyiKln+MZ9VoiYRwqQOC/hIVhdWhAez747PuAHf2GGxxSVlmNTLMsNp26lOx/nJj2NJRgeJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668873; c=relaxed/simple;
	bh=94fwmhI/4Ox/CWMeKJA0LINEjKREi2j0J1RiZ55E540=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uZPV4f9yVVgbX8JkuXRzKhpVW2TtVfwbA2xFOSmiGWnFzkpCZD6TNBnCd68lVz+53jjevf/JF3H7PeJDt3Meg2T3wq0hsWVemxjddZl1fGWIbutTJBmgvqvDhSyXPZkS1p96MGYewk++q2jPkFXziMtewSia9rNYw1VAsoR/A1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ST0G4VE2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ST0G4VE2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14C511F000E9;
	Tue, 21 Jul 2026 21:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668871;
	bh=/ZkxCu6YRbyfLTjYTMyPEGHwMT2j6ItCwip2+bYmsyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ST0G4VE2CF3fW2C3LRqHUdqrBef6fN0TaPl0yUVHsCx6QPwzj3zc7vHEJ0UtdLDnV
	 /TLebPwlyuqVfJw3gBUzgMGsTsbxOs1uxg7u0Hk25cVc9MWPhP5z7nAyTW6RcdhYMh
	 VCXC4fE7dOTrYnzHifB2+RjlEv4tL1Y/2M1Qi7Zg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0341/1067] net/sched: cls_bpf: prevent unbounded recursion in offload rollback
Date: Tue, 21 Jul 2026 17:15:42 +0200
Message-ID: <20260721152432.222483263@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit 27db54b90bcc7c37867fe664107fa25ea6a116e4 ]

Quan Sun reported [1] a stack overflow in cls_bpf_offload_cmd().

Reproducer on netdevsim: add a skip_sw cls_bpf filter, set the
bpf_tc_accept debugfs knob to 0, then `tc filter replace`. The replace
calls tc_setup_cb_replace() which fails. cls_bpf_offload_cmd() then
swaps prog/oldprog and recursively calls itself to roll back. But
bpf_tc_accept=0 makes the rollback fail too, which triggers yet another
rollback frame with the same arguments, and so on until the stack is
exhausted.

bpf_tc_accept is just a convenient knob for the reproducer. Any driver
whose tc_setup_cb_replace() fails twice in a row can hit the same loop,
so this is not a netdevsim-only issue.

Two ways to fix it:

  1) Have the rollback call tc_setup_cb_add() on oldprog instead of
     re-entering cls_bpf_offload_cmd().
  2) Mark the rollback frame with a flag and skip a second-level
     rollback from inside it.

Go with (2). It is the smaller change and keeps the original behaviour:
the rollback still goes through tc_setup_cb_replace(), so the driver
gets one real chance to restore its state. If that attempt also fails,
we just return the original error instead of recursing.

[1]: https://lore.kernel.org/bpf/ce5a6005-3c5e-4696-9e05-eba9461dc860@std.uestc.edu.cn/T/#u

Fixes: 102740bd9436 ("cls_bpf: fix offload assumptions after callback conversion")
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Link: https://patch.msgid.link/20260526025529.24382-1-jiayuan.chen@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_bpf.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/sched/cls_bpf.c b/net/sched/cls_bpf.c
index 5820ee95fa36e6..00159978c45016 100644
--- a/net/sched/cls_bpf.c
+++ b/net/sched/cls_bpf.c
@@ -140,7 +140,8 @@ static bool cls_bpf_is_ebpf(const struct cls_bpf_prog *prog)
 
 static int cls_bpf_offload_cmd(struct tcf_proto *tp, struct cls_bpf_prog *prog,
 			       struct cls_bpf_prog *oldprog,
-			       struct netlink_ext_ack *extack)
+			       struct netlink_ext_ack *extack,
+			       bool is_rollback)
 {
 	struct tcf_block *block = tp->chain->block;
 	struct tc_cls_bpf_offload cls_bpf = {};
@@ -175,7 +176,8 @@ static int cls_bpf_offload_cmd(struct tcf_proto *tp, struct cls_bpf_prog *prog,
 					  &oldprog->in_hw_count, true);
 
 	if (prog && err) {
-		cls_bpf_offload_cmd(tp, oldprog, prog, extack);
+		if (!is_rollback)
+			cls_bpf_offload_cmd(tp, oldprog, prog, extack, true);
 		return err;
 	}
 
@@ -206,7 +208,7 @@ static int cls_bpf_offload(struct tcf_proto *tp, struct cls_bpf_prog *prog,
 	if (!prog && !oldprog)
 		return 0;
 
-	return cls_bpf_offload_cmd(tp, prog, oldprog, extack);
+	return cls_bpf_offload_cmd(tp, prog, oldprog, extack, false);
 }
 
 static void cls_bpf_stop_offload(struct tcf_proto *tp,
@@ -215,7 +217,7 @@ static void cls_bpf_stop_offload(struct tcf_proto *tp,
 {
 	int err;
 
-	err = cls_bpf_offload_cmd(tp, NULL, prog, extack);
+	err = cls_bpf_offload_cmd(tp, NULL, prog, extack, false);
 	if (err)
 		pr_err("Stopping hardware offload failed: %d\n", err);
 }
-- 
2.53.0



