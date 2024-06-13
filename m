Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FCD9144D11;
	Thu, 13 Jun 2024 12:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280942; cv=none; b=swAGt0NdGU+vh9yrrFbEVT6KCC9IptNxBVrZ2lwpM661mFl9VhM7UXF8/0xmlEF4r0RCKC2NgsSWcADSSm+q/VL+JevEEZLKGyPwdmHi2tNp2acLmPL3XQQR8oi5TjrAYB2/CZlL7fspLqs0TAj0qnOJUCq4eA2rA3GNfHHFVUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280942; c=relaxed/simple;
	bh=WGvJbrZan4a2hL+nNMUGcHkGLbEsjL2Nuq7qeS2fbH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nOY6hwLC5l1+dmQnpvXqtUvoG25QHKy4TejJRiVHgHL6spcRTCFgBkhTY2nTryq8xDF1AUSKlCrHlnaEn8+MHLmuAMzqwD1iXWMUE6+N0hhfHufp0D4QggVq8zoPLVxNOLCVE3u1aQXsx27Np0sT5dS+qS6RGOv8C325LP347s8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OR6L1+52; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OR6L1+52"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 899DDC2BBFC;
	Thu, 13 Jun 2024 12:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280941;
	bh=WGvJbrZan4a2hL+nNMUGcHkGLbEsjL2Nuq7qeS2fbH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OR6L1+52L7z10ttau17wwYCqxSlDjQ5HXCoQ9y/CifyWlhCPYMRqM/jWeKtFcWoaX
	 EjBzUcoCNdCOVzl2HInWDGhMvFUbdB6LxGuN/JgE1sSVPRTTLIF3F/dXv//I48B+Oa
	 gjKJFSQwaSb7eH0YOrPyE7nOEHpvqgyE6DpDyR/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 086/317] ipv6: sr: add missing seg6_local_exit
Date: Thu, 13 Jun 2024 13:31:44 +0200
Message-ID: <20240613113250.875657571@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 3321687e321307629c71b664225b861ebf3e5753 ]

Currently, we only call seg6_local_exit() in seg6_init() if
seg6_local_init() failed. But forgot to call it in seg6_exit().

Fixes: d1df6fd8a1d2 ("ipv6: sr: define core operations for seg6local lightweight tunnel")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20240509131812.1662197-2-liuhangbin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/seg6.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/seg6.c b/net/ipv6/seg6.c
index a8439fded12dc..1a7bd85746b3a 100644
--- a/net/ipv6/seg6.c
+++ b/net/ipv6/seg6.c
@@ -503,6 +503,7 @@ void seg6_exit(void)
 	seg6_hmac_exit();
 #endif
 #ifdef CONFIG_IPV6_SEG6_LWTUNNEL
+	seg6_local_exit();
 	seg6_iptunnel_exit();
 #endif
 	unregister_pernet_subsys(&ip6_segments_ops);
-- 
2.43.0



