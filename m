Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E802DECDE;
	Tue,  2 Sep 2025 13:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820594; cv=none; b=Cjqycn2aCwOd5OusmjtphF2FWy+Vyy9OyMW79BQXUhE9yYD1EU4t7fQ24Hu0qI9TpO3r/5eZgDWpEF+LC9UnDU/W0dHkTfNUeyr/4h9fqp1eihPDBW5JYE7bGnTzWD3Z/a+TbT1g5+ymDkPVFsCZQVmaUaRLhGyU+B0ZTBSp1Aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820594; c=relaxed/simple;
	bh=l9ydAcRih9R0zzVf4CXd12okONOCwdFdkNHZJUjwrZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cU/QyRzGqI2jU4XvJVpMEN+rrHKTPGVUQOhaXf94mpjStBEqznH14q4ZtVPKEUP6LCMxcGS2G8erTeTApJ5xB1awDe4ijLgS883sm4NAcpp67CPKH2F4feOz6Z/W/ucYgflmudohUuXN1VfHPJPkiCpF/qnaKPIqnCigKStzI4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cVuEfcxb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cVuEfcxb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 281BCC4CEED;
	Tue,  2 Sep 2025 13:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820592;
	bh=l9ydAcRih9R0zzVf4CXd12okONOCwdFdkNHZJUjwrZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cVuEfcxbkx0FQxHETby6T+gimtNFv96WPXgRLsX4pfWzyIMYscuR4oV0lDRitGV9y
	 ZIC1+MO/sLunsBCVB9Fs6z6CjinYwJnJdDURsfvpxhbsNaks0V4uaJK9JlzbCh69J2
	 jR8un6gZtNRzBJx6pjmoA5bj5JdI9/O3giLsMdJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brett A C Sheffield <bacs@librecast.net>,
	Oscar Maes <oscmaes92@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 09/33] net: ipv4: fix regression in local-broadcast routes
Date: Tue,  2 Sep 2025 15:21:27 +0200
Message-ID: <20250902131927.416793947@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131927.045875971@linuxfoundation.org>
References: <20250902131927.045875971@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index df4cbf9ba288f..b24de1c67d0c2 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2552,12 +2552,16 @@ static struct rtable *__mkroute_output(const struct fib_result *res,
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



