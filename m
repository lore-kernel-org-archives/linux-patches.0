Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE6C44DB64;
	Tue, 16 Jun 2026 16:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626825; cv=none; b=sUP9s3IpQXuFgL4ukLBFSsZOiu4YG7dXshCqKfbnv+65IbZByZbCgDNbGssg91TXhHz8MY1xkMxKNH5HrUh3H5iMAB685AErQqBA9p/8SnlaFwE/vIG9GfvZaBvZjnBQGRt0O03OKrfyyFFxkspzbOrd9aQIwcKUqNsvoJCF4WM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626825; c=relaxed/simple;
	bh=GhaheBpkstUbwL/QXb0OOJVLFhSZ24ZZjfP8T209BlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AVp8ihw89Szp9sAadkcIRTryet9iSKolbPn8C6rgiyJn+2Z7N0dcuAVvpa8BSaejFDeNE2idZPJPhsxYG5O+FwbUZj0rj3N/Ih4OMgkfVXqqEopAoeglqPScl/mws83GYbTpv33QPoub8G3brYgnEoIYa47yaE1xk78FeNXatkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y7LZALu5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y7LZALu5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A8D1F000E9;
	Tue, 16 Jun 2026 16:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626824;
	bh=AkkTVndk6vBfyKqcliCHNuoImqwDBSalwJWpkivIfm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y7LZALu5w/ebwIfKhGfDI6enSUyXlyow9q3SK4SssMytvurVJEzvv9MLizXitgV2l
	 Jqcl+l4+9S//eChtEj9enNVWfDvEpakL3jR6uMcku4KTT+Som6E4SqB9C5E0DKefwE
	 Wg+8/Rj4c2Ng18AKH2g0BBEc4Myj8ugoy/P4BVhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Tamir Shahar <tamirthesis@gmail.com>,
	Amit Klein <aksecurity@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 078/261] tcp: restrict SO_ATTACH_FILTER to priv users
Date: Tue, 16 Jun 2026 20:28:36 +0530
Message-ID: <20260616145048.700582604@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 5d39580f68e6ddeedd15e587282207489dfb3da2 ]

This patch restricts the use of SO_ATTACH_FILTER (cBPF) on TCP sockets
to users with CAP_NET_ADMIN capability.

This blocks potential side-channel attack where an unprivileged application
attaches a filter to leak TCP sequence/acknowledgment numbers.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Tamir Shahar <tamirthesis@gmail.com>
Reported-by: Amit Klein <aksecurity@gmail.com>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Song Liu <song@kernel.org>
Cc: Yonghong Song <yonghong.song@linux.dev>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Stanislav Fomichev <sdf@fomichev.me>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/core/sock.c b/net/core/sock.c
index 7b6ed7c85a58cc..4a09e780406fe8 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1455,6 +1455,11 @@ int sk_setsockopt(struct sock *sk, int level, int optname,
 	case SO_ATTACH_FILTER: {
 		struct sock_fprog fprog;
 
+		if (sk_is_tcp(sk) &&
+		    !sockopt_ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN)) {
+			ret = -EPERM;
+			break;
+		}
 		ret = copy_bpf_fprog_from_user(&fprog, optval, optlen);
 		if (!ret)
 			ret = sk_attach_filter(&fprog, sk);
-- 
2.53.0



