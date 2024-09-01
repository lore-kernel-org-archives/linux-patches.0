Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91EEC1DFD1;
	Sun,  1 Sep 2024 16:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209767; cv=none; b=TIVh/U0ekvICzuv29kRxkRiKoUqWf+TYBPGf4OTPwNF351Tfj2MUQuiwL8/Q3ODkWtIawVes4Istz9TkKppMvOd2aBzRHnkOeQsK++/NffZpfD0qfM9pZJwgER61R78FoGWyaJfOT/vvDoM+2nSmiyoLrlXRZhW0ZOVFaJEkC1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209767; c=relaxed/simple;
	bh=SBfwcNyzzpzgbmCNx8QDCpufNM0m73ukEnNeqEFIuAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SaTDGqEKWcA4jCiFmOMOWvPkAGixoDOtvhdJlS7i/zyrUE8d4O8MDfYvY54UKOP4nTRMiDBPGd3p1E+UWraFDCyRYqbdSuhVTk1ADPH4D/TWWSHU+A72htQZ18USqVDN5nkdoEbxz0vYEVa0vOmGpt3fvFfRGNTm9hno2MkVw/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wfwv2HKM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wfwv2HKM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA06FC4CEC3;
	Sun,  1 Sep 2024 16:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209767;
	bh=SBfwcNyzzpzgbmCNx8QDCpufNM0m73ukEnNeqEFIuAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wfwv2HKMT8j7LrhFsG0rx7DrquUrVLYz3IUDJBu21tj1aWOEhOcm0OFRrjenBXQpp
	 rG+3TokqSti8t1MAXNNquDZpOA7EsA11tOL1/BeJ8Z86mLImjzcifvEw3e0GrRyM57
	 VxK8boDtOn0BdjsnsCMQBGlMMdC4nhBjvMj4ExBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Schultz <aschultz@tpip.net>,
	Harald Welte <laforge@gnumonks.org>,
	Cong Wang <cong.wang@bytedance.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 139/151] gtp: fix a potential NULL pointer dereference
Date: Sun,  1 Sep 2024 18:18:19 +0200
Message-ID: <20240901160819.336514207@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Cong Wang <cong.wang@bytedance.com>

[ Upstream commit defd8b3c37b0f9cb3e0f60f47d3d78d459d57fda ]

When sockfd_lookup() fails, gtp_encap_enable_socket() returns a
NULL pointer, but its callers only check for error pointers thus miss
the NULL pointer case.

Fix it by returning an error pointer with the error code carried from
sockfd_lookup().

(I found this bug during code inspection.)

Fixes: 1e3a3abd8b28 ("gtp: make GTP sockets in gtp_newlink optional")
Cc: Andreas Schultz <aschultz@tpip.net>
Cc: Harald Welte <laforge@gnumonks.org>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>
Link: https://patch.msgid.link/20240825191638.146748-1-xiyou.wangcong@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/gtp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 993960f0fa3cb..24cb7b97e4fcc 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -801,7 +801,7 @@ static struct sock *gtp_encap_enable_socket(int fd, int type,
 	sock = sockfd_lookup(fd, &err);
 	if (!sock) {
 		pr_debug("gtp socket fd=%d not found\n", fd);
-		return NULL;
+		return ERR_PTR(err);
 	}
 
 	sk = sock->sk;
-- 
2.43.0



