Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00EB432D0FA;
	Mon, 27 Oct 2025 18:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590936; cv=none; b=YmOPtq6tKaI27STKuC57DtlKMXIvZLbSRqjLmlAgRMovumLpP5d1Czh7fsnAcmDsiYFcA9tWCNfi5Sh//e3opnMPEslyz3cqkB3cfHwvnACNLFkV2tM2HeO7rQPW0fIbw+XB4jSWqLG0YZtZPZdWZHSMfEo9F8xohTHxinfXkx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590936; c=relaxed/simple;
	bh=pcQ7FjKK1C23QvtW9cXSwjFmt8LcoVK4IyjOW8wLXzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MW1M8wSiI0ULTNxBIyaSZahfT/iThxRHE3SG1BeOtodnWQk8eQBR06i7oLEQUD0KjIpG6tDCsl153fW0sP2nhlvtSnDvOfEl0n1/kK5iw2uOZt4YeWkkl9fIjmShEgEkJvPsbYU04CAjwsbH4U+wrFB6SECo8fMFx+jpuAwAQok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p7RJdsVx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p7RJdsVx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C382C4CEF1;
	Mon, 27 Oct 2025 18:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590935;
	bh=pcQ7FjKK1C23QvtW9cXSwjFmt8LcoVK4IyjOW8wLXzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p7RJdsVxxjoHLat8sYjTxU6KjGHbWLEgCvrZdays2u3FSFHm+nyLB/u95xk2zU78L
	 8OTZsRSC5uruQTyZAvIDiKSnC990Yat/SPqr+kyzoxYKvXVkSaH3120/ZKajnznCcU
	 2YdPT5P+Ch+H9hMkLOd+e1BTpcM+3bkTtYklo8g0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu-Ting Tseng <yutingtseng@google.com>,
	Alice Ryhl <aliceryhl@google.com>
Subject: [PATCH 5.4 205/224] binder: remove "invalid inc weak" check
Date: Mon, 27 Oct 2025 19:35:51 +0100
Message-ID: <20251027183514.267799489@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1208,17 +1208,8 @@ static int binder_inc_node_nilocked(stru
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


