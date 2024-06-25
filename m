Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC4D149DE9;
	Tue, 25 Jun 2024 09:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309544; cv=none; b=A4qabhK8Ag7Q3gq4OqBvU/U19IoqFPXSssprbw15M3cN+rT72NelWjU622e9RfJ4u7Cy25rxLz30iY82IjFnXTQUdggEJJa5iF5o3nQbBFcAQfIw0FvJ88OgDyCJj/bZaQgIrI6Nauqztq5pKw1rjdhTzfueZ0GN79vPYu/35/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309544; c=relaxed/simple;
	bh=Do/WWpGc7wzxHOZTcHPYVIWSV9FqMUAkf5x7Re4GFnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iD6bdojX2saEqAl+5eDEq7gquBZg+mkMgJJCvi246T9d8aM1mcvWFGyvPpG8H3hYVyOK16Zs5GsdBwH5XMYbNSSQWyzf3pNZnfUF8jSjO7c6V+wyoIDph6Jn5NRSeIqwzZIVHW962q6repLINMFPx4e3BDF3P6GOLKjhqWuYVEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RcsmRqjj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RcsmRqjj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4B38C32781;
	Tue, 25 Jun 2024 09:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309544;
	bh=Do/WWpGc7wzxHOZTcHPYVIWSV9FqMUAkf5x7Re4GFnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RcsmRqjjgg/d4C1En3Njmt3ZreIV5DlVRvAMctG5VdY9zDvKrsbdT0RWkIOZVGiXT
	 7FqC9WVJEPrJbgz4fJm9X+Vos3zcuKUjWBfLmIuF8Fbi6O86mokDjYuuzWA9x2Vwzz
	 RW1YohDWo7fje8te8H/tLXmjVDwG+NJjIkj0nv84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ondrej Mosnacek <omosnace@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 052/131] cipso: fix total option length computation
Date: Tue, 25 Jun 2024 11:33:27 +0200
Message-ID: <20240625085527.929364339@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6cd3b6c559f05..2b56cabe4da98 100644
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



