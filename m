Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4CB0376;
	Wed,  5 Feb 2025 15:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767818; cv=none; b=HCxhJ/80WQiQ6EU9j2RLxZyhbAv/wqRV5sKUfOZv2f5TG4khw8DKE8p8QMRFzJPMlei9HvmducxIz27PIa9EoMgVlNV4Xwil0/Im4jc0C7hGF3VoJZ1sCtRMwv2nNCC2QfpVorvhRJcOrRX2TiNcU/nl7z7cNZQketByToiRIow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767818; c=relaxed/simple;
	bh=GDyzWfCKJX11YxAsBKLw7BvFATCAPCKZKBgrjFBRCDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cBLuQi3YXXmil2cGnJ0agA02z5SZ6kTjEEoiyRHBB6Eb1Uo+KociiYhyf4nlie38pClFVUUgp8VN7Kmq3XUi0owdY8o83XdvTqoHOdu0IIvMfF3lAc+sxRlGnY2m8NTF3THr+uMr8m/kdjedfoM5sfX5uSOjIOsxOS3Xig9/JRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v4WkjaSu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v4WkjaSu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45FD8C4CED1;
	Wed,  5 Feb 2025 15:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767818;
	bh=GDyzWfCKJX11YxAsBKLw7BvFATCAPCKZKBgrjFBRCDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v4WkjaSuHW/ZAXx8nCfC+jwHU694IQmhQ4aO+tqVL7upxjqeT7w0XJfzkHlmFLaVO
	 gfxFfYEFbPIF0/tdM7zFVScvBNpM0Mn8NKMTwfvu/y/zbOOOJQ54B798SPYVWgp0+S
	 7sALC1mnS7E7FqxUXJ7TNT/BO76kmzBWh1JtZIkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Luigi Leonardi <leonardi@redhat.com>,
	Michal Luczaj <mhal@rbox.co>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 513/590] vsock: Allow retrying on connect() failure
Date: Wed,  5 Feb 2025 14:44:28 +0100
Message-ID: <20250205134514.894053631@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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
index 98315d9d07528..ec4c1fbbcec74 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1523,6 +1523,11 @@ static int vsock_connect(struct socket *sock, struct sockaddr *addr,
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



