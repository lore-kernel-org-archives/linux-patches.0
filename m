Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D262D28B4EA;
	Wed, 23 Apr 2025 15:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421017; cv=none; b=hfN9zSiMEhuZuLJWFMyzJwB3lMSy03TtSQDT/qjrdj1gbEX3AfkT/Yko3u8ZANsKs1Y2ZnwiR2DLy+dNIHqCfZPTHDN0WWy1wieglYT9u60dz0r2H11Ka7CUc31+wsuySTaa6sctUZVWFO9pSqEBNVNkKvVkrsuClS9Jzo+qQ2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421017; c=relaxed/simple;
	bh=lMlNfIdu8R94bOj1BW4XAAu1XHHhRzcDm4YY4U3geTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=svGCdylMYqXE3g6oXU3r/NhBJxJYVaIsP32Tf3cbDqhlwQ+7L5ecBDOBCWZb9ybtWOJO+JCmngHGmpiW9V5yLFRQCMRdbPlBHBdGCrqp8f3c2aXdtkTFwF9627usO4x5MTFJsdelR4UnTKQFWilTsEkScDAlWrZD3XQDvqwijCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hchotGBr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hchotGBr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A9A8C4CEE2;
	Wed, 23 Apr 2025 15:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421017;
	bh=lMlNfIdu8R94bOj1BW4XAAu1XHHhRzcDm4YY4U3geTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hchotGBrIc/NXETEIF6N3IFoybFbFLlCras4KQU1lWm8iXY4LQOcNl0XqC/8YjR4v
	 Ke+vHOGehK72sLjSWB5ZANxFU5T8G6c/TzLrtkqiNT6tC6hG7w/sq8c5S1s+/aom57
	 QIIr17DykKzrFIk2T3ta8Leu7i7AJQnVcCkwQTWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 101/291] mptcp: sockopt: fix getting IPV6_V6ONLY
Date: Wed, 23 Apr 2025 16:41:30 +0200
Message-ID: <20250423142628.478440049@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 8c39633759885b6ff85f6d96cf445560e74df5e8 upstream.

When adding a socket option support in MPTCP, both the get and set parts
are supposed to be implemented.

IPV6_V6ONLY support for the setsockopt part has been added a while ago,
but it looks like the get part got forgotten. It should have been
present as a way to verify a setting has been set as expected, and not
to act differently from TCP or any other socket types.

Not supporting this getsockopt(IPV6_V6ONLY) blocks some apps which want
to check the default value, before doing extra actions. On Linux, the
default value is 0, but this can be changed with the net.ipv6.bindv6only
sysctl knob. On Windows, it is set to 1 by default. So supporting the
get part, like for all other socket options, is important.

Everything was in place to expose it, just the last step was missing.
Only new code is added to cover this specific getsockopt(), that seems
safe.

Fixes: c9b95a135987 ("mptcp: support IPV6_V6ONLY setsockopt")
Cc: stable@vger.kernel.org
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/550
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250314-net-mptcp-fix-data-stream-corr-sockopt-v1-2-122dbb249db3@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/sockopt.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -1271,6 +1271,20 @@ static int mptcp_getsockopt_v4(struct mp
 	return -EOPNOTSUPP;
 }
 
+static int mptcp_getsockopt_v6(struct mptcp_sock *msk, int optname,
+			       char __user *optval, int __user *optlen)
+{
+	struct sock *sk = (void *)msk;
+
+	switch (optname) {
+	case IPV6_V6ONLY:
+		return mptcp_put_int_option(msk, optval, optlen,
+					    sk->sk_ipv6only);
+	}
+
+	return -EOPNOTSUPP;
+}
+
 static int mptcp_getsockopt_sol_mptcp(struct mptcp_sock *msk, int optname,
 				      char __user *optval, int __user *optlen)
 {
@@ -1308,6 +1322,8 @@ int mptcp_getsockopt(struct sock *sk, in
 
 	if (level == SOL_IP)
 		return mptcp_getsockopt_v4(msk, optname, optval, option);
+	if (level == SOL_IPV6)
+		return mptcp_getsockopt_v6(msk, optname, optval, option);
 	if (level == SOL_TCP)
 		return mptcp_getsockopt_sol_tcp(msk, optname, optval, option);
 	if (level == SOL_MPTCP)


