Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE12531BCBC;
	Mon, 27 Oct 2025 19:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592771; cv=none; b=cOqBlkAg2bZxMI/RIr0GeXRX6LjMyBFP/SGqvUESC+0l7w5jKzONto0A5f3Zi5eFFparShI2mrMwBGbdozVebo5Rix8lDyAF4g+CAV201ffYyAjL55A/nIKanQhiZccrxYHcX4QSNoUfz/3M49GK5Wf+EG3VQeQD52wlCRGi4jU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592771; c=relaxed/simple;
	bh=XNfPsptp+osDJFegjYd457oaiqFL48/7AgTnuTxOamw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l7nY2lOHw9+C8PTURKMN6W9vwpdYIArNWkBhiE60rr0EzHj4iittPCLeTkGl88mtSpzc9D8wLDSH3gMwOVe5wiNdjY7mimcO5a1oR3wUzhx87hosPQ1hyVuJwzmPv13FTUFNtIx/0QvSNoRe9oj2POQbs1LvZdkn0+zQMIIWZ84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d7tqWJaQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d7tqWJaQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C29CC4CEF1;
	Mon, 27 Oct 2025 19:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592771;
	bh=XNfPsptp+osDJFegjYd457oaiqFL48/7AgTnuTxOamw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d7tqWJaQlXB8o2oECfrD7E5lhnlSNw9U2GawmzjJMyAer3KuC+kyCjeAhih9/iA7U
	 KDGCfYDMQnggYNypU1dc9MyVGZiZhUerx55PVbYeS3V5i44vLS/ULb+EancK5Eqb59
	 hgbvC1NNe3wtkMvDGN/AgqlcZLLy5mZjTQAt00WQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu-Ting Tseng <yutingtseng@google.com>,
	Alice Ryhl <aliceryhl@google.com>
Subject: [PATCH 6.6 66/84] binder: remove "invalid inc weak" check
Date: Mon, 27 Oct 2025 19:36:55 +0100
Message-ID: <20251027183440.572114775@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183438.817309828@linuxfoundation.org>
References: <20251027183438.817309828@linuxfoundation.org>
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
@@ -846,17 +846,8 @@ static int binder_inc_node_nilocked(stru
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


