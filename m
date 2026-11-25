Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622225;
	b=FzHvAYMP89GiIQlb+mUz/PSBKJp0YJoA4lKL/9AY+BsqM8lTjWF8Hap1NsL6doSwfCwq
	 XnLVTIspHb3SkMKcG3C7utu75wAuIZPmkvUDOke5SZVJS909AK18xyngpeGwjjQOf1inH
	 UbOhk3fqHMMjl2GfN/KBAVD+shMnHHf4LfFF/TT6AYILhW7N4OxAU544Cams44zXIX60e
	 pLrlNQaQwnUXYBqAhiVfP2ESPH2+KwGbrGf7nmfLjvXYMqk1diCGO13EkxoZ0iPMDe+3a
	 Br/7POeMWgHaXDwUJ3wRRq9ngiJ7sgY/T0sjSVKByk1KgjjIHWXuEoTs7hnQTM81sjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622225;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nFEolNIHSt87FBWIbmkISPI+4DVM0QZYznUu3kH8GTY=;
	b=uS8U8qyUqgoKjNV2l04KMM6NlvTzGgAHO6NLHiluc8/nwfUiMysqX7Vxa5+Za8COxpcY
	 eHOEU2m8GODf+i5kfGCSqZBY0AxjhdYvoBhERe1TSAf03P361Tarls2IUnu0I/ZScQ3UI
	 0HdZ6uQRGV2T0DeWEQvfsZaIrrMvSk+Zx+tWYzXC873cT+KUSASUpt0j2V1oshEEzcB20
	 JPGV7y8IKWGX4jtrk97svfTdb73dxnCLa3SJyqHZKNO5pen9KBHpJA3u7GjDvW1uEBxPG
	 F6wUwNMSOjnoWNwteicFAxgnyAVwNOY0ymyl33iA3JXhdojsaN1tIGVhF6GMtwVGELw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2NVboFMR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5D5606A321;
	Wed, 25 Nov 2026 15:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2NVboFMR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4308C1F000C0;
	Wed, 25 Nov 2026 15:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622224;
	bh=nFEolNIHSt87FBWIbmkISPI+4DVM0QZYznUu3kH8GTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2NVboFMRtxTjNHjdXXVNO1crbQDVT8bgKsoXwqQiYcX25mamzgbPoa/PsnFp6tAmH
	 tOE6gPUaLTY8aAktgs2dOLmtf8jDbZB0LaYvHSlQ7ki/gRDjn+fk61nHvBlvhWvUea
	 KskuzuzhfKBp7hOGiDSHcUeda8+ttx9z4Kl6IVug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jori Koolstra <jkoolstra@xs4all.nl>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 469/990] net: scm: move scm_detach_fds() from common path to scm_recv_unix()
Date: Wed, 25 Nov 2026 15:30:36 +0100
Message-ID: <20261125143833.081594830@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jori Koolstra <jkoolstra@xs4all.nl>

[ Upstream commit 48b84acc5e18655f2a02fe2a043330d03f939ffe ]

scm->fp can only be set when using UNIX sockets, therefore we should
move it out of the common path __scm_recv_common() into
scm_recv_unix().

Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Signed-off-by: Jori Koolstra <jkoolstra@xs4all.nl>
Link: https://patch.msgid.link/20260813162818.149248-3-jkoolstra@xs4all.nl
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 0359338fd8cf ("af_unix: Inherit SO_INQ in unix_stream_connect()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/scm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/scm.c b/net/core/scm.c
index 66eaee783e8be..6d0e60feaada9 100644
--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -525,9 +525,6 @@ static bool __scm_recv_common(struct sock *sk, struct msghdr *msg,
 
 	scm_passec(sk, msg, scm);
 
-	if (scm->fp)
-		scm_detach_fds(msg, scm);
-
 	return true;
 }
 
@@ -547,6 +544,9 @@ void scm_recv_unix(struct socket *sock, struct msghdr *msg,
 	if (!__scm_recv_common(sock->sk, msg, scm, flags))
 		return;
 
+	if (scm->fp)
+		scm_detach_fds(msg, scm);
+
 	if (sock->sk->sk_scm_pidfd)
 		scm_pidfd_recv(msg, scm);
 
-- 
2.53.0



