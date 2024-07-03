Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D37C17FAB1;
	Wed,  3 Jul 2024 11:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005754; cv=none; b=mRqhjD3IuHB3gTAp9QDQH9ojV58hZ1S9S0ede7I8qgIy1UvqRRKqYQm0IlpZHwyKWFJRUnkVtGt8Yv2D8Hg3O8glEqxPBJB8T1j3n6Q39FbPdu9mc6DGnHpZbYd1oi/wpCbozCyZq5oiJ+Zg0I0LnIk8td5Y2UyFjaMbGyLby0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005754; c=relaxed/simple;
	bh=70AHGZyiTt/k0BAVZJsx7eXk/fdtitbs25inVOGbVvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iaF+Lf2iTQh3iDJEjaFoKGLXUP53mSVF6VOUnnJuzJeyw4jyxlYWWwIdATdACH9E+Qn5jEpOy2yRmenhpUHx9FodnCa9/b9f2uCUMqRCOGhh1NSU/EnuAmKuCLIrlz3Q9UT9r53gnVO2//ofjbIqX9hemfV0fkRcJvg/fpyMLMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aPdlkoG+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aPdlkoG+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84BFDC32781;
	Wed,  3 Jul 2024 11:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005753;
	bh=70AHGZyiTt/k0BAVZJsx7eXk/fdtitbs25inVOGbVvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aPdlkoG+0mEUvHSxAqHiK10WYSIkqeIlPKfcQ9kfj4ywuPM3JSOuyCnYZhEU4adoA
	 BuXTqeWT2aL8Aawj6DDajJfbjps7T8uMKmoHbqZnxYiiH1Id0sz72YoWuzQxHUKqYt
	 py497HEKrKSB4rOh59MsJpKaKuVSyHHH4G06L8qs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ondrej Mosnacek <omosnace@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 186/356] cipso: fix total option length computation
Date: Wed,  3 Jul 2024 12:38:42 +0200
Message-ID: <20240703102920.144441400@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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
index 75ac145253445..016ebcbc8a633 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -2015,12 +2015,16 @@ static int cipso_v4_delopt(struct ip_options_rcu __rcu **opt_ptr)
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



