Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7593D1714D0;
	Wed,  5 Feb 2025 14:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766347; cv=none; b=Lm8eYBdFYXjeXxdEDR5MExcLB9HyNorMV2nhckD4Dt5UaZCKmDmX1oLEalegysS/RVzy4yPup1XvBFm6SKE0SzUGxodigXwPaiO82tVOuC/VGmrmJgRNzUCHKaoifDADme5FIXBpFTwjLskQaJGJsuCH0QJTdTaACBDH2IVBSLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766347; c=relaxed/simple;
	bh=XdVlU2fySb3b23m53u+zsmqnnS3pa6IqP6E3hzSFhkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PTjZoCfWNAgtdSr6Ltl7ZMwL7KNG/pnGoOIkjkhqGK/nksA3WYBUMHVpEi2Z45gQbFEQAUG8basQUA/mW5Cjs3ejmjtZtBngQ3JfPa/Yb6Eiy4ez27OnDhrV4QwRfaABDmPuCMq2WQsqbsiM8IbDekuJsnuvi42ZWr/v9Z6riDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DiETl6J+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DiETl6J+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D57EFC4CED6;
	Wed,  5 Feb 2025 14:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766347;
	bh=XdVlU2fySb3b23m53u+zsmqnnS3pa6IqP6E3hzSFhkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DiETl6J+wMBymZiMH6cpxLUSmyRzMm1NOBP+zssIJ8hmT7A7cgNVSdntjBVn8Eygr
	 0XU6xaFi6Zs22xgkEIRbALlA2OIM9sJhrZVec8PqFXc5VC2wPENzxektMie8rVtPY2
	 gJhG2NXi7XA9d2iPQuOu6zXyVY72fM3pCp4s8VF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Luigi Leonardi <leonardi@redhat.com>,
	Michal Luczaj <mhal@rbox.co>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 342/393] vsock: Allow retrying on connect() failure
Date: Wed,  5 Feb 2025 14:44:21 +0100
Message-ID: <20250205134433.397412504@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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
index ea857ed57d046..df7d95b404d99 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1457,6 +1457,11 @@ static int vsock_connect(struct socket *sock, struct sockaddr *addr,
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



