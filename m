Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0222857E2;
	Wed, 23 Apr 2025 15:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422305; cv=none; b=oU6CfWRE9VR837OJ1z9B89qH48faQ/mv5K2ECQL/NaTj2r6FfGXIC5YVyrKWCD6Skt/AoSBUWiP/V+aZeePT7YgsE1iZkq+Hk66FAX+B044c8tvmVUvd/gH+29sCDtO0AyDA+VpAPzmqY6YZgXCEnpzwV0iOauZV7XneoyWFVGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422305; c=relaxed/simple;
	bh=kT8DJqszx5g4q+0r7P9M9Ipln2KCGSna//yIkARL10U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qbOYCUgSr+R+VqZmi83xVIzQOqXe9GBCXh86lZE1clLMt8e3h5J9pOUffdAd4vTggobMYDS81FBpW3GXNCqWb2P5r8AHHE75xTBlTtkZCGJsN8SEFJS3YAbBrhJrRamnP5G8xmSMs5xQQAJtRGb2YuWB/WiM/pPADkXHXIVTTzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a3lvD/k7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a3lvD/k7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B192DC4CEE2;
	Wed, 23 Apr 2025 15:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422304;
	bh=kT8DJqszx5g4q+0r7P9M9Ipln2KCGSna//yIkARL10U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a3lvD/k7n9xKCTeXz1cTY1NAdzGLASg1J9js1K8KhzRL8B5FJox9snfj28ZbEI/Ty
	 SwQTWRax64JL+mFq63AA1TarFMin4OjctkDw+gqBOSD4wwZL+hhFmphIh0qiPkyOTa
	 Qd3dOgUvRFFGi2H96ysk5GaSStBtj/HIfndlF//4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 260/291] mptcp: sockopt: fix getting freebind & transparent
Date: Wed, 23 Apr 2025 16:44:09 +0200
Message-ID: <20250423142635.052236091@linuxfoundation.org>
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
[ Conflict in sockopt.c due to commit e08d0b3d1723 ("inet: implement
  lockless IP_TOS") not being in this version. The conflict is in the
  context and the modification can still be applied in
  mptcp_getsockopt_v4() after the IP_TOS case.
  Also, get the values without 'inet_test_bit()' like it was done in
  this version. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/sockopt.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -1266,6 +1266,12 @@ static int mptcp_getsockopt_v4(struct mp
 	switch (optname) {
 	case IP_TOS:
 		return mptcp_put_int_option(msk, optval, optlen, inet_sk(sk)->tos);
+	case IP_FREEBIND:
+		return mptcp_put_int_option(msk, optval, optlen,
+					    inet_sk(sk)->freebind);
+	case IP_TRANSPARENT:
+		return mptcp_put_int_option(msk, optval, optlen,
+					    inet_sk(sk)->transparent);
 	}
 
 	return -EOPNOTSUPP;
@@ -1280,6 +1286,12 @@ static int mptcp_getsockopt_v6(struct mp
 	case IPV6_V6ONLY:
 		return mptcp_put_int_option(msk, optval, optlen,
 					    sk->sk_ipv6only);
+	case IPV6_TRANSPARENT:
+		return mptcp_put_int_option(msk, optval, optlen,
+					    inet_sk(sk)->transparent);
+	case IPV6_FREEBIND:
+		return mptcp_put_int_option(msk, optval, optlen,
+					    inet_sk(sk)->freebind);
 	}
 
 	return -EOPNOTSUPP;


