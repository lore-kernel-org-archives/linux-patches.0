Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FCB718E350;
	Mon, 28 Oct 2024 06:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097647; cv=none; b=mZpl/OAdyhMbUyJb/uBKwaVOm6LJf6fcDqbmVhoji0b0ql+Dl9gPG3dcwtDEGctwDsDiu7AGwGW9dQTGRLqszEfo3nJh1LgIIsV9PLjcNQbYo/79Q23p0JHS31cRSAeZJlv/siB5ewTBccR0kYvwkWYAfiOc3Z2Deb9U9qt1G5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097647; c=relaxed/simple;
	bh=RQuHn53MK7qMSyRZJ0dbU+D31qrfcBDbc84t2i9cYl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EPj9kvHcBLVUDaVcwPJyLON6822m4srtrjDFRtw4lG0aA7qOMtR1AZ0XnWpMFKOkN8u9MQ/z6Jk3fIUDBEW7DIzGmDDqV/E7jYR1q5aE3R1LGAhEpCn24qPbMjU9AQrnZ7e0FBU5Q7tQQ9ab3DP3CRHVN+exNunfj8z96BrkDls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VauEwr87; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VauEwr87"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6548C4CEC3;
	Mon, 28 Oct 2024 06:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097647;
	bh=RQuHn53MK7qMSyRZJ0dbU+D31qrfcBDbc84t2i9cYl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VauEwr87u9lmvrTtaRahwGGcXF4wlmKkTI0ifBff1n3X3c6zwEsFGPBoNszdkkDDv
	 yV+mpt2RLhUzKpwECpEuZ4WLdBhT1uUHI3DnIwNMhyl0Mh1e+lnukCPhS5kKI0DNdN
	 aCtJWc/VCBDCD5ic23IHcchdzBrG3rYR2dYFjf3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Luczaj <mhal@rbox.co>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 085/208] bpf, vsock: Drop static vsock_bpf_prot initialization
Date: Mon, 28 Oct 2024 07:24:25 +0100
Message-ID: <20241028062308.747788544@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit 19039f279797efbe044cae41ee216c5fe481fc33 ]

vsock_bpf_prot is set up at runtime. Remove the superfluous init.

No functional change intended.

Fixes: 634f1a7110b4 ("vsock: support sockmap")
Signed-off-by: Michal Luczaj <mhal@rbox.co>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20241013-vsock-fixes-for-redir-v2-4-d6577bbfe742@rbox.co
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/vsock_bpf.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/net/vmw_vsock/vsock_bpf.c b/net/vmw_vsock/vsock_bpf.c
index c42c5cc18f324..4aa6e74ec2957 100644
--- a/net/vmw_vsock/vsock_bpf.c
+++ b/net/vmw_vsock/vsock_bpf.c
@@ -114,14 +114,6 @@ static int vsock_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
 	return copied;
 }
 
-/* Copy of original proto with updated sock_map methods */
-static struct proto vsock_bpf_prot = {
-	.close = sock_map_close,
-	.recvmsg = vsock_bpf_recvmsg,
-	.sock_is_readable = sk_msg_is_readable,
-	.unhash = sock_map_unhash,
-};
-
 static void vsock_bpf_rebuild_protos(struct proto *prot, const struct proto *base)
 {
 	*prot        = *base;
-- 
2.43.0



