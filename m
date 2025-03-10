Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6739617CA12;
	Mon, 10 Mar 2025 17:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629083; cv=none; b=DcRvhsI+On85a3BsKPICumwFsy2xuwkDXf9qpS/UBzj96tbrjflvuWv+6moK9wAkC/qnmwDArFL27d6W1I9XBtTzoQCFA+EWEk4x2sp+qyTpDdkcUpR9W2V7J1GFsyAucn1BG9pag3PcAaehnf4oDR8oGKMLL9lsFNSkhH/F3bM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629083; c=relaxed/simple;
	bh=199KVOfWeJPtN9gOSseZ33rXpvnpeEDixHY9QS1houU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RKw24Kg5hGK3Ep9DrfYQE+1E801oYkZ67Va2aOLZSnnpBjJrO5qP4F29+mDW07R1oXxCKU5lGX8YjdIg9p4UGKDH6kOOH6cBnbVVPv2Ow1EclSRJW5Vr0dBYPEj7GbFSUFVXijKKB7xz5PJ4s0OSbj9z1REzGCQsSdtfyar577g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ja6Mu869; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ja6Mu869"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2557C4CEE5;
	Mon, 10 Mar 2025 17:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629083;
	bh=199KVOfWeJPtN9gOSseZ33rXpvnpeEDixHY9QS1houU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ja6Mu869XZr8kPjOxKXrtiLoix64+zk6LwZqMP8MgRt94wqLrwzPZZgKMj7JrROfw
	 Zu0RnFepKM2ULVGf4DWAw3C9s1Cx8aZKPOTbgPkeOurjKNHwuJF2n4FECFkNqoMw2d
	 c63F/Zl0l6APmgs2UPWk3hrPABpbEbDD9ZHPV6PE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Luigi Leonardi <leonardi@redhat.com>,
	Michal Luczaj <mhal@rbox.co>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 171/620] vsock: Allow retrying on connect() failure
Date: Mon, 10 Mar 2025 18:00:17 +0100
Message-ID: <20250310170552.369581221@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Luczaj <mhal@rbox.co>

[ Upstream commit aa388c72113b7458127b709bdd7d3628af26e9b4 ]

sk_err is set when a (connectible) connect() fails. Effectively, this makes
an otherwise still healthy SS_UNCONNECTED socket impossible to use for any
subsequent connection attempts.

Clear sk_err upon trying to establish a connection.

Fixes: d021c344051a ("VSOCK: Introduce VM Sockets")
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Reviewed-by: Luigi Leonardi <leonardi@redhat.com>
Signed-off-by: Michal Luczaj <mhal@rbox.co>
Link: https://patch.msgid.link/20250128-vsock-transport-vs-autobind-v3-2-1cf57065b770@rbox.co
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/af_vsock.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 943d58b07a559..a4bcb758301dd 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1386,6 +1386,11 @@ static int vsock_connect(struct socket *sock, struct sockaddr *addr,
 		if (err < 0)
 			goto out;
 
+		/* sk_err might have been set as a result of an earlier
+		 * (failed) connect attempt.
+		 */
+		sk->sk_err = 0;
+
 		/* Mark sock as connecting and set the error code to in
 		 * progress in case this is a non-blocking connect.
 		 */
-- 
2.39.5



