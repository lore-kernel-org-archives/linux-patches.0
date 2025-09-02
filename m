Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D81CC31E102;
	Tue,  2 Sep 2025 13:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820158; cv=none; b=P1igYJvaB+dTNHREt4td82MNh/6URfG3ZUME374pG88WPtyICpilyxknenopYo7dfzebL/Ekwd1TESnu2v5DBJtwM6g+/nNEmdUxwliu/5Quxbk9DcZrQlNbgxRsu2+UfDX/2mSYBNp0mX/qXrCf4u9Hzyk5z2wgpYCWc4CrDZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820158; c=relaxed/simple;
	bh=OpcVFwmy5YN/C0nFIkUe4eR9CUTZJpdRSie4latCutA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MhZUKz+ql0NYD8dDrKwveodC+sTWPo5vLcZPiSuCQQqx2q7Mzrqm1yajkGe776w6HQNKOgNsCBUvr5RT6g2mXKmsy2fYcNFPw/ckRH0Czy9Z9DDr661lQH897f5kLw5LD78WstfdEPuU19/tqNHKwgVlrMAXf7hTFpTVgxO/E/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d2mNnXfO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d2mNnXfO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DAB3C4CEF4;
	Tue,  2 Sep 2025 13:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820158;
	bh=OpcVFwmy5YN/C0nFIkUe4eR9CUTZJpdRSie4latCutA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d2mNnXfODTijQr/ncpIRVujLtrVPqM+1WYJIvuZQ1Ll9IIkF6f2uG4l8p070jwksk
	 ApZxrzWfVCw6Tvu8c/kGg/z3yY3NvqdeczJB43yfz8FgX3fldMM+C8uWYcBZ3rP8ji
	 Lf4BSqFAjZnMKA6XtMZ6sEAGqFXT2kP/kV44j7Vw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brett A C Sheffield <bacs@librecast.net>,
	Oscar Maes <oscmaes92@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 17/75] net: ipv4: fix regression in local-broadcast routes
Date: Tue,  2 Sep 2025 15:20:29 +0200
Message-ID: <20250902131935.791061578@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131935.107897242@linuxfoundation.org>
References: <20250902131935.107897242@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oscar Maes <oscmaes92@gmail.com>

[ Upstream commit 5189446ba995556eaa3755a6e875bc06675b88bd ]

Commit 9e30ecf23b1b ("net: ipv4: fix incorrect MTU in broadcast routes")
introduced a regression where local-broadcast packets would have their
gateway set in __mkroute_output, which was caused by fi = NULL being
removed.

Fix this by resetting the fib_info for local-broadcast packets. This
preserves the intended changes for directed-broadcast packets.

Cc: stable@vger.kernel.org
Fixes: 9e30ecf23b1b ("net: ipv4: fix incorrect MTU in broadcast routes")
Reported-by: Brett A C Sheffield <bacs@librecast.net>
Closes: https://lore.kernel.org/regressions/20250822165231.4353-4-bacs@librecast.net
Signed-off-by: Oscar Maes <oscmaes92@gmail.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20250827062322.4807-1-oscmaes92@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/route.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 8672ebbace980..20f5c8307443d 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2547,12 +2547,16 @@ static struct rtable *__mkroute_output(const struct fib_result *res,
 		    !netif_is_l3_master(dev_out))
 			return ERR_PTR(-EINVAL);
 
-	if (ipv4_is_lbcast(fl4->daddr))
+	if (ipv4_is_lbcast(fl4->daddr)) {
 		type = RTN_BROADCAST;
-	else if (ipv4_is_multicast(fl4->daddr))
+
+		/* reset fi to prevent gateway resolution */
+		fi = NULL;
+	} else if (ipv4_is_multicast(fl4->daddr)) {
 		type = RTN_MULTICAST;
-	else if (ipv4_is_zeronet(fl4->daddr))
+	} else if (ipv4_is_zeronet(fl4->daddr)) {
 		return ERR_PTR(-EINVAL);
+	}
 
 	if (dev_out->flags & IFF_LOOPBACK)
 		flags |= RTCF_LOCAL;
-- 
2.50.1



