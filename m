Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A02D2D3EEE;
	Wed, 25 Feb 2026 06:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002731; cv=none; b=Zb0NOwyRpXiW31GXs1inMDdAg8OrNh56K7QBBsKczHrbm2zZP9XA+B0TwK+u4UhnnsWyMal0/EbktzAY8QnBU7tkP2pgMENzyEFflBVH4vlmQx9voIRVwe1b9mBaVSePw84rx5Q5vlYUtKIrUkHdbKvTxDLZpilpn8vGBPHasAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002731; c=relaxed/simple;
	bh=/m49pow1O/4IvwKoVrJWPny6owwv9SzJE9kXCvOEX/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hwHIpVnIGdpSkfXSoh/QS4esICd7dKW/mev5KAQ/aNy/pMqnnqZNjZwWzeWhyRvmwXDDydoXNnUGtuWae2jEPdDmWF7xT6kGoUz2GvPz1DR5q3stOtQhyc73oxn0uvGyA1hh2d7LHaDJKxY7pmVoMarOeKP3DpDIRWfPOtp/zuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hPl07Eo1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hPl07Eo1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7093CC116D0;
	Wed, 25 Feb 2026 06:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002731;
	bh=/m49pow1O/4IvwKoVrJWPny6owwv9SzJE9kXCvOEX/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hPl07Eo1QY+SWycMOni75+WjSNXIxUx08QpEiYx+niABMSf5oljudlXLVRzVaASNV
	 GIB6ijT+ttcwgi1YRWIGjtiq8fXpUeyN/T+VDRViyxOM2g49ZBDjkmrxhv68TN49vv
	 gxIGdheeNbjGb2VA4Ug9/CzXhaik5/tv39VLYb0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Simon Horman <horms@kernel.org>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 545/641] ipv6: fix a race in ip6_sock_set_v6only()
Date: Tue, 24 Feb 2026 17:24:31 -0800
Message-ID: <20260225012401.734981618@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 452a3eee22c57a5786ae6db5c97f3b0ec13bb3b7 ]

It is unlikely that this function will be ever called
with isk->inet_num being not zero.

Perform the check on isk->inet_num inside the locked section
for complete safety.

Fixes: 9b115749acb24 ("ipv6: add ip6_sock_set_v6only")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Link: https://patch.msgid.link/20260216102202.3343588-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ipv6.h | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 2ccdf85f34f16..f0936df7567e3 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -1280,12 +1280,15 @@ int ipv6_sock_mc_drop(struct sock *sk, int ifindex,
 
 static inline int ip6_sock_set_v6only(struct sock *sk)
 {
-	if (inet_sk(sk)->inet_num)
-		return -EINVAL;
+	int ret = 0;
+
 	lock_sock(sk);
-	sk->sk_ipv6only = true;
+	if (inet_sk(sk)->inet_num)
+		ret = -EINVAL;
+	else
+		sk->sk_ipv6only = true;
 	release_sock(sk);
-	return 0;
+	return ret;
 }
 
 static inline void ip6_sock_set_recverr(struct sock *sk)
-- 
2.51.0



