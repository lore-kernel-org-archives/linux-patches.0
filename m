Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F48725A326;
	Thu, 17 Apr 2025 18:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914628; cv=none; b=Y7lwdLUqmcIvP/wobFhEquP5sOr605U/88icZJgRDlYhLz3z2CYMu+0JlHYVQN82RK69cD16obt/xlEojgafbtJK6eYdhyJ0qoU+rika7E8Q5VAN7iOQfhp8+90CnxcQhpEGiBbdo3b4mfl+Gi3gyFSyNeZkhkwbDdTMzWMyZKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914628; c=relaxed/simple;
	bh=RgTl+rkAjyKczyYFx1vhk2dzZSZwYRBKee40HnejrS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ga5OxFM12yGIUtJK858ZzSdsPGB1mfgG6YEgFVLrmn52JUhl0pc7Gjg+OSlWq2Ai5KwTCEXT6DhCCbkx9UzS4cVCfNtPff+GakziRzejOmxRlB6sFJxgHJ3ZXwufqO4n1Aq13Z8bqMOmRev5k15bsqt0BKQBPJvP8nrHDJ0CRA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vc489aUy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vc489aUy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23A71C4CEE4;
	Thu, 17 Apr 2025 18:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914628;
	bh=RgTl+rkAjyKczyYFx1vhk2dzZSZwYRBKee40HnejrS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vc489aUypCzFMKlt8U4MgApyfXhkDCnECsJyZ+hIAxbPTMOVHhSg4dsXE2yym0MQZ
	 fZrmEmb8SKiw4I2L/uGB/S2sL7I9kIljeHzNP/u5S1pxLMhukXOGhcxZmL0/lJ+BSp
	 0UwcWRUOO+gRcvC2moWp+DO2NtoHuPFtlgtwEXeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.13 248/414] mptcp: sockopt: fix getting freebind & transparent
Date: Thu, 17 Apr 2025 19:50:06 +0200
Message-ID: <20250417175121.396514407@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit e2f4ac7bab2205d3c4dd9464e6ffd82502177c51 upstream.

When adding a socket option support in MPTCP, both the get and set parts
are supposed to be implemented.

IP(V6)_FREEBIND and IP(V6)_TRANSPARENT support for the setsockopt part
has been added a while ago, but it looks like the get part got
forgotten. It should have been present as a way to verify a setting has
been set as expected, and not to act differently from TCP or any other
socket types.

Everything was in place to expose it, just the last step was missing.
Only new code is added to cover these specific getsockopt(), that seems
safe.

Fixes: c9406a23c116 ("mptcp: sockopt: add SOL_IP freebind & transparent options")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250314-net-mptcp-fix-data-stream-corr-sockopt-v1-3-122dbb249db3@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/sockopt.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -1419,6 +1419,12 @@ static int mptcp_getsockopt_v4(struct mp
 	switch (optname) {
 	case IP_TOS:
 		return mptcp_put_int_option(msk, optval, optlen, READ_ONCE(inet_sk(sk)->tos));
+	case IP_FREEBIND:
+		return mptcp_put_int_option(msk, optval, optlen,
+				inet_test_bit(FREEBIND, sk));
+	case IP_TRANSPARENT:
+		return mptcp_put_int_option(msk, optval, optlen,
+				inet_test_bit(TRANSPARENT, sk));
 	case IP_BIND_ADDRESS_NO_PORT:
 		return mptcp_put_int_option(msk, optval, optlen,
 				inet_test_bit(BIND_ADDRESS_NO_PORT, sk));
@@ -1439,6 +1445,12 @@ static int mptcp_getsockopt_v6(struct mp
 	case IPV6_V6ONLY:
 		return mptcp_put_int_option(msk, optval, optlen,
 					    sk->sk_ipv6only);
+	case IPV6_TRANSPARENT:
+		return mptcp_put_int_option(msk, optval, optlen,
+					    inet_test_bit(TRANSPARENT, sk));
+	case IPV6_FREEBIND:
+		return mptcp_put_int_option(msk, optval, optlen,
+					    inet_test_bit(FREEBIND, sk));
 	}
 
 	return -EOPNOTSUPP;


