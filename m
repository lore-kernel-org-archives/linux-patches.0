Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 223DA146A6F;
	Mon, 24 Feb 2025 14:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408030; cv=none; b=Ncv5PjXWETTymWNV9pjlIwZnJNcyV82gZgF1uDgZdCN7ZDuyn/T0989SlLF5xRPbcMHiHE0YwgPKR/jcMmCYc9Y2tg2v4AaeuIneHa08+ceoHwgYqbGD6nCWt+ROCPJAfEiz+BN6AaMiivG0XhWpT4Ex6ZhrrRIn2n99Shk1hAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408030; c=relaxed/simple;
	bh=oKbYsIjMzdmGeP9g8gITjoLifZ6U10+fGWW2pT8w0nQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mRtFHbr1m4IrKiwx+HIDL4xH5rARXH0LShbnFJim7E45Bh9uhbZWJ4ZF5KHN3sUPpBHQpq9MlHRe3gO5D4ELm/ECTmCOqtXFOIlGrzje26V3VOXzmhe4coe0Pkek7Esan/NmVFyGlU+HKDoVjJLbXA3N3aNCgeCy2pJJbEmpuBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1uJ0fSCq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1uJ0fSCq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF59C4CED6;
	Mon, 24 Feb 2025 14:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408030;
	bh=oKbYsIjMzdmGeP9g8gITjoLifZ6U10+fGWW2pT8w0nQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1uJ0fSCq4YJzhOsCDIdWFxUgJq5Lx2yw3pUF9kGfxyEXq9Cx5TgmLKd3H0i02rcKa
	 FXnCmMoDY5K8XJOvhkWM0eQAjygO0dvrEGxXYi5FysCcHLbob/YcyFTx4dWg3sjTpD
	 LG6gQ2Ne7rT7izQF/jdC3nn1VJLkn/m9QpWnJRMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Luczaj <mhal@rbox.co>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 080/140] vsock/bpf: Warn on socket without transport
Date: Mon, 24 Feb 2025 15:34:39 +0100
Message-ID: <20250224142606.154732161@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Michal Luczaj <mhal@rbox.co>

[ Upstream commit 857ae05549ee2542317e7084ecaa5f8536634dd9 ]

In the spirit of commit 91751e248256 ("vsock: prevent null-ptr-deref in
vsock_*[has_data|has_space]"), armorize the "impossible" cases with a
warning.

Fixes: 634f1a7110b4 ("vsock: support sockmap")
Signed-off-by: Michal Luczaj <mhal@rbox.co>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/af_vsock.c  | 3 +++
 net/vmw_vsock/vsock_bpf.c | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 618b18e80cea0..622875a6f787c 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1185,6 +1185,9 @@ static int vsock_read_skb(struct sock *sk, skb_read_actor_t read_actor)
 {
 	struct vsock_sock *vsk = vsock_sk(sk);
 
+	if (WARN_ON_ONCE(!vsk->transport))
+		return -ENODEV;
+
 	return vsk->transport->read_skb(vsk, read_actor);
 }
 
diff --git a/net/vmw_vsock/vsock_bpf.c b/net/vmw_vsock/vsock_bpf.c
index f201d9eca1df2..07b96d56f3a57 100644
--- a/net/vmw_vsock/vsock_bpf.c
+++ b/net/vmw_vsock/vsock_bpf.c
@@ -87,7 +87,7 @@ static int vsock_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
 	lock_sock(sk);
 	vsk = vsock_sk(sk);
 
-	if (!vsk->transport) {
+	if (WARN_ON_ONCE(!vsk->transport)) {
 		copied = -ENODEV;
 		goto out;
 	}
-- 
2.39.5



