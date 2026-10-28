Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216848;
	b=5Qj3k6XjifBhWXl0EgvWIyEp9XfwMzA6aKcr1SCr9fGvCSJf9aEKYww3lRLMqbQvIHVu
	 7klAiNP+iOF/kNBn9+6FXJHJ5PwM1Il9ni5P0+wmWvgGUWzJXbCYPgT46qXHP1d27yfTu
	 XBqbX5RMEbgivJB3dHXhjO2iZuKcjBpoy5IEuVezZDvhbLYctK8h+bygBTJeS1xokTuLu
	 T/fjo4+HKFtrAU1MXA4PPpANEpgfsg8Rva9X63MOI3usk4PENxLMEic7yRMk5IgnnrXpI
	 Xsr+HiKCaqw4lTdaRkMnY40OUo/qC4VWfPUvMBLmA+QcywVR1s7ikbALGnUX8ianrMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216848;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MQeFJQlP8QRT4etJDZY6Of1v/oLPUtuLP4soxOHOlys=;
	b=XHxekSFkp2gPnlpuOGGClD/Fs3BRjdQzAHbNm9sgnMjwZFAWQCQWeS37TnQD3OCoZ2Tt
	 K8cWZoieoaTdJGCRiCx5Vrn94m8sSKsmQfCcollQJkIwj/41IyGXafcrG4j3J23zHFm6X
	 L7MZQJsUPc3VDQPQGU028yCPV68yL7cid4dGd/NMQ+OIu/KIqK0OW3ynskiDRTaHYfVjt
	 taoaL4AlqQN4PlVrAPEpXL16gtm7lFsuVxefmMcPZ5p2gFYWw/IS0gW4uACaY3Z6JdnDy
	 yDO7/uLNdgKOq4TitI8xQ500ZzMn8NbHTkigjaW8VprC3a8srU7TnqfzehlRqL67d3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YkiTs2E2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71774606A31C;
	Wed, 28 Oct 2026 19:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YkiTs2E2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE4261F01825;
	Wed, 28 Oct 2026 19:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216848;
	bh=MQeFJQlP8QRT4etJDZY6Of1v/oLPUtuLP4soxOHOlys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YkiTs2E25TGk+k7QH2Vu2AnTfwX9kVmGgKkh7O+NoBNKiLgo1eNaC47/o3iDhOBk6
	 wCe1Sm3EGCGjHt+jczI8wsmmZQpL+TZpo8AOCSgEBql6WHa0gfib0PNKWaqAjAZKIm
	 jrUAXX4y8b7tQgCr3e7TLygI13aGvYTM6rFULohQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdul Wasey <w453y.me@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1701/1887] mptcp: move the OoO check back into __mptcp_try_fallback()
Date: Wed, 28 Oct 2026 18:03:17 +0100
Message-ID: <20261028170538.162116150@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdul Wasey <w453y.me@gmail.com>

The 6.1.y backport of upstream commit 1bba3f219c5e ("mptcp: do not
fallback when OoO is present") put the out-of-order queue check
in __mptcp_finish_join() instead of __mptcp_try_fallback().

So the fix itself is missing, as fallback still happens with OoO data
queued. Worse, the passive side now refuses every MP_JOIN while its
OoO queue is not empty, which is the normal state of a connection
already sending data over more than one subflow. The joining subflow
is reset, so such a connection can't add a new path, and a path that
comes back after an outage can't rejoin while data is in flight.

Move the check to __mptcp_try_fallback(), as upstream does. On this
branch that function is in protocol.h.

Tested on 6.1.190 in netns: 6 connections (5 uploading) over two paths,
then a third endpoint added mid-transfer. Without this patch only the
idle connection gets a subflow on the new path and the other 5 joins
are reset. With it, all 6 join. Same result in 3 of 3 runs each.

Fixes: 9074732c1caf ("mptcp: do not fallback when OoO is present")
Signed-off-by: Abdul Wasey <w453y.me@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c | 7 -------
 net/mptcp/protocol.h | 8 ++++++++
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 5d6dff88bf209..bdace644dbc6a 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -930,13 +930,6 @@ static bool __mptcp_finish_join(struct mptcp_sock *msk, struct sock *ssk)
 	if (sk->sk_state != TCP_ESTABLISHED)
 		return false;
 
-	/* The caller possibly is not holding the msk socket lock, but
-	 * in the fallback case only the current subflow is touching
-	 * the OoO queue.
-	 */
-	if (!RB_EMPTY_ROOT(&msk->out_of_order_queue))
-		return false;
-
 	spin_lock_bh(&msk->fallback_lock);
 	if (!msk->allow_subflows) {
 		spin_unlock_bh(&msk->fallback_lock);
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 6728f08970f2f..31ea91b45363c 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -1005,6 +1005,14 @@ static inline bool __mptcp_try_fallback(struct mptcp_sock *msk)
 		pr_debug("TCP fallback already done (msk=%p)\n", msk);
 		return true;
 	}
+
+	/* The caller possibly is not holding the msk socket lock, but
+	 * in the fallback case only the current subflow is touching
+	 * the OoO queue.
+	 */
+	if (!RB_EMPTY_ROOT(&msk->out_of_order_queue))
+		return false;
+
 	spin_lock_bh(&msk->fallback_lock);
 	if (!msk->allow_infinite_fallback) {
 		spin_unlock_bh(&msk->fallback_lock);
-- 
2.53.0



