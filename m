Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E291822F5;
	Wed,  3 Jul 2024 10:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003505; cv=none; b=DbTFDtviEv1niGjMSucONh8JeH4WGHq363AIO/T2hg7JZuvK02M3fl04sx9b3dIAPLLMdlbruwhUXVydI9FHBoqr+lab2hqNNPl10gZTN1TWdQOW1DYCUK7iAM6Re/WCdN1lkd3jcC5fRxs47U4VKYdgYr9xrThU8NpTRaSXRd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003505; c=relaxed/simple;
	bh=5TpIzepsR4c5q79rJttlhZdhd/1Dg2++z6Sd/y3OmQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dSANxaPH766LX3CpED8LILLNGbJuGNHA3b7otB3E1jSSYVjz/6CKtKrnLEgFPQDfmme5VH8HMSP/8oDFz02OMwB8YqfefnrCh4Er1Wi78K1N+LJoO3iv+WZulwqv9DbuC+gg34Pl7SnYeQ6HfiMfwRfXOOG25Suwt/xGPY6L1SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jTC+YRkq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jTC+YRkq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 297F3C2BD10;
	Wed,  3 Jul 2024 10:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003505;
	bh=5TpIzepsR4c5q79rJttlhZdhd/1Dg2++z6Sd/y3OmQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jTC+YRkqhPWkdbRgHsojRIAvfJ3jEIt7j8MqouxNWELXUcCUrMMjS0VVbUTWTAQjl
	 8ErjS0RaYURbleIokzGNvr/4mJXYYHNOob/9xyIvsYnk6Nu46N3Ad0sxIubrk0M0GR
	 lYGfszT+aI1dVeLY8tMZsoJZ+S10NRbLmKyEToAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ondrej Mosnacek <omosnace@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 071/139] cipso: fix total option length computation
Date: Wed,  3 Jul 2024 12:39:28 +0200
Message-ID: <20240703102833.123133649@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

From: Ondrej Mosnacek <omosnace@redhat.com>

[ Upstream commit 9f36169912331fa035d7b73a91252d7c2512eb1a ]

As evident from the definition of ip_options_get(), the IP option
IPOPT_END is used to pad the IP option data array, not IPOPT_NOP. Yet
the loop that walks the IP options to determine the total IP options
length in cipso_v4_delopt() doesn't take IPOPT_END into account.

Fix it by recognizing the IPOPT_END value as the end of actual options.

Fixes: 014ab19a69c3 ("selinux: Set socket NetLabel based on connection endpoint")
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/cipso_ipv4.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
index 8dcf9aec7b77d..4a86cf05a3480 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -2029,12 +2029,16 @@ static int cipso_v4_delopt(struct ip_options_rcu __rcu **opt_ptr)
 		 * from there we can determine the new total option length */
 		iter = 0;
 		optlen_new = 0;
-		while (iter < opt->opt.optlen)
-			if (opt->opt.__data[iter] != IPOPT_NOP) {
+		while (iter < opt->opt.optlen) {
+			if (opt->opt.__data[iter] == IPOPT_END) {
+				break;
+			} else if (opt->opt.__data[iter] == IPOPT_NOP) {
+				iter++;
+			} else {
 				iter += opt->opt.__data[iter + 1];
 				optlen_new = iter;
-			} else
-				iter++;
+			}
+		}
 		hdr_delta = opt->opt.optlen;
 		opt->opt.optlen = (optlen_new + 3) & ~3;
 		hdr_delta -= opt->opt.optlen;
-- 
2.43.0



