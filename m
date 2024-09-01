Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0463233987;
	Sun,  1 Sep 2024 16:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207828; cv=none; b=B6YfhuXVHZNHhBCKetWm394WeEcByubdVY+Ds14LJ9Q4jCy/tgdCnenJ0zW8Vd+d86Y/QXcOopyS701Ghw1P33OraaYmo6ITHBcBO8UNyFDGh+PhjxuuxyXAZ2QemAHMmRNdgsqv/wYDQy5jj4QKT/979vm6TK8osnVA4riH3Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207828; c=relaxed/simple;
	bh=zM+7vF+IPoWDW3qXXAjcLMSG3DI3nZPoGglDh6zwP/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dQ4zbBF8GnKs2uY7J5vtaV1/YfCPqUjTxs27f912Yqhy7oY9mZwvPbRLKTYOZ/pA3PF2hdMUbHnTc4sX/4E8d1qcICIDBiGWW4JrsSkpPrYiWt1P23wn/zmwBdYoqiFc3SKsVJqs2XjchxwnT7/LH5tiLb+b9BEqv7jqZtoFrMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sOt7ESxJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sOt7ESxJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 129D4C4CEC3;
	Sun,  1 Sep 2024 16:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207827;
	bh=zM+7vF+IPoWDW3qXXAjcLMSG3DI3nZPoGglDh6zwP/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sOt7ESxJhL5tjXMY9JvjqG2d1FA69+5ZIPUh77lVQEhxufumkbtnJ00J0tgS/cY6M
	 c75YifQXEKB7JZfaRjNKIc2gRziaj4LX6X/UuW1qQX+VOJO5MlqAZQWhF7hQRM7yAu
	 mvEkECpxqduWz6pme1I55qDRAmiuz97tsXdUw3Ak=
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
Subject: [PATCH 4.19 88/98] gtp: fix a potential NULL pointer dereference
Date: Sun,  1 Sep 2024 18:16:58 +0200
Message-ID: <20240901160807.016531506@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index cc80bd98e172d..733cafb0888f6 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -812,7 +812,7 @@ static struct sock *gtp_encap_enable_socket(int fd, int type,
 	sock = sockfd_lookup(fd, &err);
 	if (!sock) {
 		pr_debug("gtp socket fd=%d not found\n", fd);
-		return NULL;
+		return ERR_PTR(err);
 	}
 
 	sk = sock->sk;
-- 
2.43.0



