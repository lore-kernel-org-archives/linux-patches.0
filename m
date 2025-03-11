Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26DE250BF8;
	Tue, 11 Mar 2025 15:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705535; cv=none; b=nDu1j0ATZw6t1a4X7vu5ndTA6/xHhUj65X48BeyQYN1Xsh51MMJvRjKH+a9jCd2hcLNcL1/0Nwj+3wmiDDwCG0mIPrioDYd5PzevZQhFBs9cCF6qTR2Yla3TbvXRoLl6NuB7ob/hPvoW/cJnNij2pktCt8teZiEZpfk12MsTB4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705535; c=relaxed/simple;
	bh=UiUr6KwTi7BuYTz/TrUIN1tYfgZ2qyKkl17jPIWGjxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rADq0qZ7dtghCtJoBi0BVmJYshHHU3+hEAxLWhfIpC0tn6X6LS/Nfxp5Ctx/Ufxm0USV84eFzxMbnaAeFEQV8utERkz5nH3fuGD2UriUlO8aDFRjhM/r+gNqQ6xzpOappHQzxcZC1/44C6YcDZ4F64WSNltEdmVre+kRhfKS70g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XKA6FVl/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XKA6FVl/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 428AAC4CEE9;
	Tue, 11 Mar 2025 15:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705535;
	bh=UiUr6KwTi7BuYTz/TrUIN1tYfgZ2qyKkl17jPIWGjxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XKA6FVl/FONLSl6pnpzVkxJgSWYmROrTHO47I5rLbEpJJM9aUdMwjhkooz8gP3qrL
	 LHl3kyCghhn/lB0rv2kTknDd4AnZdaM7L6+tHGoH/t3MNMQ1Ocua9Zk6DRO2EEXfyh
	 juxQI0Lg/Z0TIKYPCNcgY9261w/0EF0dthjmrr9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Luigi Leonardi <leonardi@redhat.com>,
	Michal Luczaj <mhal@rbox.co>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 069/328] vsock: Allow retrying on connect() failure
Date: Tue, 11 Mar 2025 15:57:19 +0100
Message-ID: <20250311145717.636581583@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 4cd65a1a07f97..5d490633a7f11 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1185,6 +1185,11 @@ static int vsock_stream_connect(struct socket *sock, struct sockaddr *addr,
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



