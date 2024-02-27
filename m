Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C89713AA4C;
	Tue, 27 Feb 2024 14:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043088; cv=none; b=WGkxMXgPCdpjivfbqUFTnljeIaZahvm9KQKcoeHaThggw/YAQ3qyd30LuzrSmXfAdiGuJaJAblgriD1x7Lx+7IXTg3LBhMt4cBuJK0VHxyaNJDQTn8br18Yht+FsLTNV518FeoTcvcWudOAH5+wlDGGoqWFK/sajhVXBEnYRKJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043088; c=relaxed/simple;
	bh=mFCKyS6j7oZt92RcgUIEjrtOSUWvL8Uy5zxuN/m8JCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sSVs8p52IpGyWwPlqD+WHtXFDcr3+AeEMEZ5mOKmQOGKJCVOsaId6hZxES7Ft4hEjHQAuulq/I4ghFeaRROVmQgd2tLGDGzk8z7BoAkdzkPc3eg7Z/Z3XdvB1WthyxfY00p2QIb4i6fE16Cvb70uh4lXwaJpGmJkn6GjDJSCGac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zcMfJUqs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zcMfJUqs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF8FDC433C7;
	Tue, 27 Feb 2024 14:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043088;
	bh=mFCKyS6j7oZt92RcgUIEjrtOSUWvL8Uy5zxuN/m8JCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zcMfJUqsGbEjNtIhYi+Vy7tsX6/VpYCZ/PwnNOtv59PWI7i1SYw2QaIoRnO0WHcbC
	 ChnlnOXxRmSxt+7aaL0pCcYw19OM0SOA5lBwf+43GPooHqvp2FgfGKjxF4L0NGqx3o
	 Dwu7r1dwItt6E7DhJyIg2V5dHBcdrgkUP3uk5eC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 230/245] tls: stop recv() if initial process_rx_list gave us non-DATA
Date: Tue, 27 Feb 2024 14:26:58 +0100
Message-ID: <20240227131622.658412194@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit fdfbaec5923d9359698cbb286bc0deadbb717504 ]

If we have a non-DATA record on the rx_list and another record of the
same type still on the queue, we will end up merging them:
 - process_rx_list copies the non-DATA record
 - we start the loop and process the first available record since it's
   of the same type
 - we break out of the loop since the record was not DATA

Just check the record type and jump to the end in case process_rx_list
did some work.

Fixes: 692d7b5d1f91 ("tls: Fix recvmsg() to be able to peek across multiple records")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://lore.kernel.org/r/bd31449e43bd4b6ff546f5c51cf958c31c511deb.1708007371.git.sd@queasysnail.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 92eab4a7a80b5..e6f700f67c010 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1787,7 +1787,7 @@ int tls_sw_recvmsg(struct sock *sk,
 	}
 
 	copied = err;
-	if (len <= copied)
+	if (len <= copied || (copied && control != TLS_RECORD_TYPE_DATA))
 		goto end;
 
 	target = sock_rcvlowat(sk, flags & MSG_WAITALL, len);
-- 
2.43.0



