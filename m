Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A804E533C;
	Thu, 17 Sep 2026 17:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665600; cv=none; b=GM2wZsmA4Aa2Kadgn1O1qRnHv3LwvcsbRHvipCRx2j4QTB63ApFrUtgh5km4KiLBvMDLtl4nL+0andbzuaP1jxib9Zk+gtkMhYUVtwOWLdl3V7dAPdOndp1pUK+N9h3msSj8e5ujL63q6lzoZNdFXN6Y6fD0CjlC9KX1WJYNbw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665600; c=relaxed/simple;
	bh=zGTp3WyqwyE5K2deNnNG9QdcMNDc31R1JrR7Erwucv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PDzCvaQ+G/37+Z8/vkt63VlagLerDDgoyG1MsimFryLwx3rPRjO4vd4W4/nmstQUS9hInmsVjDr/AfGYsGZBC6nCdRixk983mkogpyh+yPArK3eerIQqWVqW1GglqnMRrhG9mNNcd1Yz+6SXkfxNThCnx+tctDIGRjfsE+y8TZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zb2UrQdu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zb2UrQdu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A2F91F000FF;
	Thu, 17 Sep 2026 17:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665599;
	bh=IVbi6yAYUJ/CyYd2CnSN4r4DgNd5QFl/pT+7O27QxmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zb2UrQduAWPFN4fuvs3PPdBcKhshXkR6P7YmqMrjq06mWNC2ztoWZV4i3Z3OWAAW3
	 mzU3LYr50KcmYCsfCNIEnCj32B/+EoS6o+vNbPdoOqwVmXOvfEa+zpNienj8z3XfGb
	 yLj6jeLFg5TgqxIWnyp5yl/Nacld90vP2GjQqM78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0758/1250] bpf: Reject resilient lock operations in rbtree callbacks
Date: Thu, 17 Sep 2026 16:09:13 +0100
Message-ID: <20260917151612.421564307@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit 7b7b8b5960102566bd625ae829d1f330c5b5d104 ]

__bpf_rbtree_add() keeps parent and link pointers live across calls to the
program-supplied comparison callback. The verifier therefore requires the
root's lock to remain held throughout the callback.

The helper path enforces this rule for bpf_spin_lock() and
bpf_spin_unlock(), but the resilient lock kfunc argument path does not.
Since resilient locks may protect BPF rbtree roots, a callback can release
the root lock and let another CPU remove and free the node referenced by
the in-progress tree walk. The walk then resumes using freed pointers.

Reject resilient lock kfuncs in an rbtree comparison callback, matching
the existing policy for the spin lock helpers. Resilient-lock-protected
trees remain valid when their comparison callbacks leave lock state alone.

Fixes: 0de2046137f9 ("bpf: Implement verifier support for rqspinlock")
Reported-by: Nicholas Carlini <npc@anthropic.com>
Suggested-by: Nicholas Carlini <npc@anthropic.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20260903144433.1716731-6-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index c2e71bb4a2cd7..52c17bed9e2eb 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -13726,6 +13726,11 @@ static int check_kfunc_args(struct bpf_verifier_env *env, struct bpf_kfunc_call_
 		{
 			int flags = PROCESS_RES_LOCK;
 
+			if (in_rbtree_lock_required_cb(env)) {
+				verbose(env, "can't res_spin_{lock,unlock} in rbtree cb\n");
+				return -EACCES;
+			}
+
 			if (reg->type != PTR_TO_MAP_VALUE && reg->type != (PTR_TO_BTF_ID | MEM_ALLOC)) {
 				verbose(env, "arg#%d doesn't point to map value or allocated object\n", i);
 				return -EINVAL;
-- 
2.53.0



