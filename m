Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C66125DD06;
	Tue, 11 Mar 2025 15:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706736; cv=none; b=XRWcuRwik8rP9c3z1cHlj6zHhP54gWi7HMUwC4IBA1HKoL5p2xZqYGsL4xMd/dfH13v7SAdNsXfsuPKw/FCltPAGv4fPlA05IPKxn95JpRW1gvMAX+9ipbP/LUCFTJOnVr+D0gFfXB6dHj8imiounZNbpf3oRtQYb9FDIkl0Rl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706736; c=relaxed/simple;
	bh=1mT/rJsne1z1w60lQlNDFBCTyzDJdL+ApM01nW75lqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H/b9qNL1R9mLVtAQJcV7CiMLk6xo681r1Eq4nTI/tt6kNkKr/gumtKdKlEN6EKygP9TzmDuMocW9tpZjj61TxyCDL/r7wXKw3Djbs8Hbpz8IDIh4dCkClNetLcMF1lR2zi/Iar/hA+cCIQw/nkZ1uQF6+GR6eHhYBm46iVvu/4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QI2F+Lqy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QI2F+Lqy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6111C4CEEA;
	Tue, 11 Mar 2025 15:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706736;
	bh=1mT/rJsne1z1w60lQlNDFBCTyzDJdL+ApM01nW75lqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QI2F+LqyRlvRc7pNCKr0GKhPgGNMx9yIi1J73+q9qlRmxMVuVUMjrdmcw+Ko2cy7Y
	 FSMNjucpFOy/c8P4BqMo7tjHWj7GLBNivqetw39T8bR/uWXQ8vJd3ggImymJ7wkRLe
	 grViRH4M0ky5d29E7ZtU1y2MlIX+9CDXGP0n9l+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Luigi Leonardi <leonardi@redhat.com>,
	Michal Luczaj <mhal@rbox.co>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 108/462] vsock: Allow retrying on connect() failure
Date: Tue, 11 Mar 2025 15:56:14 +0100
Message-ID: <20250311145802.633603315@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 53a9c0a73489b..473ba765a4356 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1340,6 +1340,11 @@ static int vsock_stream_connect(struct socket *sock, struct sockaddr *addr,
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



