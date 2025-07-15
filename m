Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB0C3BBF2;
	Tue, 15 Jul 2025 13:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585409; cv=none; b=nMTcQzk76DVOXcsyEGFaW//0RrKUnp7HBAbcnSqkApp5ZhjUFn0112JEXJ7yLZsJkFkhRpkdrOAh1V0+Ly8wMywEL1Xi2ugsV+Pnj52nR+NpalMRKiusrTCEWqKF6DtLcVWELSmq+YyLR7lno0d9wyeVPkKiG/rs0TQemyqYBx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585409; c=relaxed/simple;
	bh=vK4iQwZHQzeo88+msVar9h4ArYd3wO5Fvpt1GT2tYo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FHo98arp8/IFbEms9+bXILkjCFkpQsj18MVh7CBOnjar98hto6iqOfCbgooc94BIex+iuEwsbSz04mjcOl6oRmD5qYXfFo4XeHr4swai5l10XZLlG61M79TdEPDutUwg9ITZ9esZryUYstCivMnkgHNGlwOzkuNOqzIIPJChtec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CeXa15Os; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CeXa15Os"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F492C4CEE3;
	Tue, 15 Jul 2025 13:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585409;
	bh=vK4iQwZHQzeo88+msVar9h4ArYd3wO5Fvpt1GT2tYo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CeXa15OsPSvjGu5Z13P+wR/WGLsQk/vL3cTDyxoJ1qG3RNTjhmBVKEwzm8pnG7ujf
	 5ptgCov43AewOLSF+9rsQobhMIrhnQSSRxJE5qJNGGtMUsuAsCKW0ZGtHXhPIhXc7o
	 gSHSvKOFDA6f4KGILFyE/EwLDc8ZxWUYGUGhTtYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 030/163] vsock: fix `vsock_proto` declaration
Date: Tue, 15 Jul 2025 15:11:38 +0200
Message-ID: <20250715130809.964876187@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefano Garzarella <sgarzare@redhat.com>

[ Upstream commit 1e3b66e326015f77bc4b36976bebeedc2ac0f588 ]

>From commit 634f1a7110b4 ("vsock: support sockmap"), `struct proto
vsock_proto`, defined in af_vsock.c, is not static anymore, since it's
used by vsock_bpf.c.

If CONFIG_BPF_SYSCALL is not defined, `make C=2` will print a warning:
    $ make O=build C=2 W=1 net/vmw_vsock/
      ...
      CC [M]  net/vmw_vsock/af_vsock.o
      CHECK   ../net/vmw_vsock/af_vsock.c
    ../net/vmw_vsock/af_vsock.c:123:14: warning: symbol 'vsock_proto' was not declared. Should it be static?

Declare `vsock_proto` regardless of CONFIG_BPF_SYSCALL, since it's defined
in af_vsock.c, which is built regardless of CONFIG_BPF_SYSCALL.

Fixes: 634f1a7110b4 ("vsock: support sockmap")
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Link: https://patch.msgid.link/20250703112329.28365-1-sgarzare@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/af_vsock.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index 9e85424c83435..70302c92d329f 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -242,8 +242,8 @@ int __vsock_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
 int vsock_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
 			size_t len, int flags);
 
-#ifdef CONFIG_BPF_SYSCALL
 extern struct proto vsock_proto;
+#ifdef CONFIG_BPF_SYSCALL
 int vsock_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore);
 void __init vsock_bpf_build_proto(void);
 #else
-- 
2.39.5



