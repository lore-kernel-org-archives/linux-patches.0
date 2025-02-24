Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2129824A3;
	Mon, 24 Feb 2025 14:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408886; cv=none; b=mIAf+q9GBtGaWHClCAILUnjuyCaYnL5rOZqcsI2ixjx3ui1h+ETATg/QO4JfEpPxYWteb8zdJZed3e1h6FaPY4k3VjNS+Jf4FiNl2u5m9xZUwOYcll02JGuW03VutCQw9uAIvX4xrvXglMt91j90OESFkJ7Lq55I0he+1zE4OCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408886; c=relaxed/simple;
	bh=4hhB3VefAqUZASLyie2kRBebQe4H7eFh6iCXSUs8uu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S89QHhJOud/mhh/+hUG4MeRRFHP6W3IHXQo7vEHXN5CW9hjguXCN/QsUdaf60Fr+Mtw/kmLqaFqpiHMwKWvneUNm/mAect96JcVOBXCLVmC2vQ80ULfcmt+E+jwDwQz/3mWJi/c1EKF+5yM4X3+Ew9OZlvsUerF8wjz2v39q8MY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F6GgFg1D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F6GgFg1D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60B38C4CED6;
	Mon, 24 Feb 2025 14:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408885;
	bh=4hhB3VefAqUZASLyie2kRBebQe4H7eFh6iCXSUs8uu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F6GgFg1DHgXD7TCBsMGeDInfNZ/sIo4KvlAQl8b0gpr3Hmlt0puzQltmvnU+Vrlau
	 ewJETshN0xfUb4TR+rsS9RfW8+OzftxqfZkMpD3rdYghgvuPO7nq7WmvK3DVmVt/aA
	 eO8tguTqlHMdJpPJNA026V0QqXGAs2/Q5IhtmPzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Luczaj <mhal@rbox.co>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 035/138] vsock/bpf: Warn on socket without transport
Date: Mon, 24 Feb 2025 15:34:25 +0100
Message-ID: <20250224142605.847694983@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 53a081d49d28a..7e3db87ae4333 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1189,6 +1189,9 @@ static int vsock_read_skb(struct sock *sk, skb_read_actor_t read_actor)
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



