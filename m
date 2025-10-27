Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF3F18A6A5;
	Mon, 27 Oct 2025 19:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591702; cv=none; b=GBu8niJiTo7Pr6PVPi2sxo3WeJqsnlisudnz/oRvqdA5TJSArAOr1WHVsCy+MVweoytnYZit+uzsRZUL6ylMmO4caei3dJJRO7xsW39lwqSAaFFSOe1CS1jX+rLRTlV8PAQfGaqkxkCndEskDnI1lQ1JdJrjKMU3dHgjirZkptU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591702; c=relaxed/simple;
	bh=OfpwhiHlw00nLGr8lYhlcYQbRbPaZ260+8nqsVLvU+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RVmY9mVZtQUV931hYbrQJIA0wgL7i3r9023z8kWuxYperPlzEUJi1k8bTZFo1bRCuT/QiDsLHBhx38qER/PyTCN5R49KOzzfR+KXdSm3Oj0HXO7GdtQwJxBGq21V+RyGw/DgIK+cFHc11dasP+h20oMo6LPunyO/6ZX2JheQYFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KRi2iyK+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KRi2iyK+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4111BC4CEF1;
	Mon, 27 Oct 2025 19:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591702;
	bh=OfpwhiHlw00nLGr8lYhlcYQbRbPaZ260+8nqsVLvU+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KRi2iyK+xLTclJqQFG9wRt2+JPn1i5kn2OBpokUduQ/PwJ1DBxpONK1Db5xoTtoLf
	 Tm7sPGoNRCFOgumBhn+md/IfYdXCdNiHjFD4NVBOGiLwYP2op2eaZqnGCjAy/S7/aX
	 lh9HyNmDUm3UqghB/TF7A+40GgMFlJz0BUL8XnMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu-Ting Tseng <yutingtseng@google.com>,
	Alice Ryhl <aliceryhl@google.com>
Subject: [PATCH 5.10 297/332] binder: remove "invalid inc weak" check
Date: Mon, 27 Oct 2025 19:35:50 +0100
Message-ID: <20251027183532.695314157@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

From: Alice Ryhl <aliceryhl@google.com>

commit d90eeb8ecd227c204ab6c34a17b372bd950b7aa2 upstream.

There are no scenarios where a weak increment is invalid on binder_node.
The only possible case where it could be invalid is if the kernel
delivers BR_DECREFS to the process that owns the node, and then
increments the weak refcount again, effectively "reviving" a dead node.

However, that is not possible: when the BR_DECREFS command is delivered,
the kernel removes and frees the binder_node. The fact that you were
able to call binder_inc_node_nilocked() implies that the node is not yet
destroyed, which implies that BR_DECREFS has not been delivered to
userspace, so incrementing the weak refcount is valid.

Note that it's currently possible to trigger this condition if the owner
calls BINDER_THREAD_EXIT while node->has_weak_ref is true. This causes
BC_INCREFS on binder_ref instances to fail when they should not.

Cc: stable@vger.kernel.org
Fixes: 457b9a6f09f0 ("Staging: android: add binder driver")
Reported-by: Yu-Ting Tseng <yutingtseng@google.com>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Link: https://patch.msgid.link/20251015-binder-weak-inc-v1-1-7914b092c371@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -1204,17 +1204,8 @@ static int binder_inc_node_nilocked(stru
 	} else {
 		if (!internal)
 			node->local_weak_refs++;
-		if (!node->has_weak_ref && list_empty(&node->work.entry)) {
-			if (target_list == NULL) {
-				pr_err("invalid inc weak node for %d\n",
-					node->debug_id);
-				return -EINVAL;
-			}
-			/*
-			 * See comment above
-			 */
+		if (!node->has_weak_ref && target_list && list_empty(&node->work.entry))
 			binder_enqueue_work_ilocked(&node->work, target_list);
-		}
 	}
 	return 0;
 }


