Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9C83074AC;
	Mon, 27 Oct 2025 19:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592003; cv=none; b=L2OTKydIWOBg6r24poordK6izY58sJoT6FTFI9k52wgZTJb7kos6tBjZJShvL+t3OmnAc03lring+QldxcXldvd32d9SxouMbZNNp+1gxLK0AVKjS36PNRWHJxu+iwOim23/aziUNMPhN8kI7aBVKWfx9S7Qc29Us2l9DOt8l/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592003; c=relaxed/simple;
	bh=PNVs1+schTPRYJ9QVvtY5HrH5Dg9muMj0l+6eKPGr6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G4PsuML27OASJpVpNj3OBhGyFKWVu3EuUafWvJOfpFYBLuVYQDk+WiVwznlYuTKyLy1MPb9NIXHRoeLgmeagiWsDb5Q8WxOx7Af7a8NBkCs+MAT0HSJGCvWPj3RRPvzsR5QDjwEiALb/5vOaH3yM9j+Xlh8hHCahiR42muFBN3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cWvPifu1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cWvPifu1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F223C4CEF1;
	Mon, 27 Oct 2025 19:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592002;
	bh=PNVs1+schTPRYJ9QVvtY5HrH5Dg9muMj0l+6eKPGr6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cWvPifu1lJ1jy/HK7xhwcN5Z0xpeZtgqI6p9ThN9Kpz0GIruv0H3GKV8Upvk3ddXs
	 2NZcdN1kllxJDJVHtguNusRvNvRAR1IBLaPvVpbl9jXPpeWZnje5G0x9P9TW66vLY0
	 /zm7s4y33YEJhuEbK+dl0HyNwC0YBBcATOuxJKfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu-Ting Tseng <yutingtseng@google.com>,
	Alice Ryhl <aliceryhl@google.com>
Subject: [PATCH 5.15 081/123] binder: remove "invalid inc weak" check
Date: Mon, 27 Oct 2025 19:36:01 +0100
Message-ID: <20251027183448.559288758@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
References: <20251027183446.381986645@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -818,17 +818,8 @@ static int binder_inc_node_nilocked(stru
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


