Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC1626AC1;
	Sun,  1 Sep 2024 17:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210468; cv=none; b=bX0E2UeKvvtZGt98t7FVtCfinm5fYu54nad6W+cdgATvdSGi7gFeZFRNCfiEPNI4OtM8hB5nTgD9IIo1Kvz2oLlpFf/XXLZX0Q8A1qU0uWtK/O7njsJfUzLOTgePJAMuQgDQObkbbcWv5VLXtzPn9BgatMs87XusVj/6RFm57A4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210468; c=relaxed/simple;
	bh=mRfr8sOHptqrXE9LNoxNk8hmgLm/4OVaG2LrJ8bswkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rdxkzVPwdx+Qad6XljrWxetqNp0WCAjZdkRoEtBnZa8dg4PAva/3DRiR49cnMwdhQDPgfblQjwKPXL14z5w05CFc8RkfccmUfpiGEb3WihWri2quleUCvYZcNfAzGM++UnW8/E863zSEGfP2skifkYs5cOqyWRdWzZVDtppPtmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aQ5b2htK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aQ5b2htK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E9F0C4CEC3;
	Sun,  1 Sep 2024 17:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210467;
	bh=mRfr8sOHptqrXE9LNoxNk8hmgLm/4OVaG2LrJ8bswkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aQ5b2htKv2tTLVp+Rwh81t2Y8QA/3EKSj28F/6OrjW0WbmoxaW4H0zeGbs2yJTtQM
	 EMN7Osuff1F6LK5qG5cc1JHNr5Jek8/Xz1O3ZvnBg/QqbJUec3dZNsvCapijUbeTCI
	 BnfUfbyfqCnhuk/KGY3lOMhzHY90IhiR/ln5loU0=
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
Subject: [PATCH 5.15 198/215] gtp: fix a potential NULL pointer dereference
Date: Sun,  1 Sep 2024 18:18:30 +0200
Message-ID: <20240901160830.837587827@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3bc9149e23a7c..40c94df382e54 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -817,7 +817,7 @@ static struct sock *gtp_encap_enable_socket(int fd, int type,
 	sock = sockfd_lookup(fd, &err);
 	if (!sock) {
 		pr_debug("gtp socket fd=%d not found\n", fd);
-		return NULL;
+		return ERR_PTR(err);
 	}
 
 	sk = sock->sk;
-- 
2.43.0



