Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B171C57BC;
	Tue, 27 Aug 2024 15:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771493; cv=none; b=TghWZhlleBr4t/ltuVUw7eJKtYytn9HaC0WEki+qZySqMKfmWvYSTe8E3r/lZ+D7f4kGK0T46bqnMMJuEVMGGRMPtvJap7njVo1AJsVJxR2JjF8zpxrNpeHcQvnEpanf6GvfcWK7VfdXq4mp45npCJnrUzk/xa0dJAlXYs6ofbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771493; c=relaxed/simple;
	bh=7Exdw7mq41xZhCTgGsxCR0ep5l+qSbcyrMYtvSz1Eyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i7yxYgnWegUBfUwPhmOsgdp1vrBMNSL+wQRsIIbGXuSINOTCI8DZPlysDFR2TRdjh76SHGww+ZcKVNJkVgFN/oziS/rCWzyE9EBelM4vmJ5SvIIQUjVMQ5aoxpZbqf4RD6iyG2ys07yelDsg5Sirh2/MPUEC7/Y5l3zsn778YSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2inAAVVD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2inAAVVD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B4D3C4DDED;
	Tue, 27 Aug 2024 15:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771492;
	bh=7Exdw7mq41xZhCTgGsxCR0ep5l+qSbcyrMYtvSz1Eyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2inAAVVD3kewq1xpNW4b/95RFBi3g51+hnB2SmDqzdCG2GhH9Fkr3tBU0GDPUSb/E
	 4PWGO3TaHCJ6nft5Zsxn9dMRwtygH42GxIikC7icG94VCOz96FB3DV1tMYskX7FjPf
	 ZpQzgpP3TiRZVuVQDn3bjde9RQGwZNRjUmWn6qZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 163/273] net: mctp: test: Use correct skb for route input check
Date: Tue, 27 Aug 2024 16:38:07 +0200
Message-ID: <20240827143839.611026899@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeremy Kerr <jk@codeconstruct.com.au>

[ Upstream commit ce335db0621648472f9bb4b7191eb2e13a5793cf ]

In the MCTP route input test, we're routing one skb, then (when delivery
is expected) checking the resulting routed skb.

However, we're currently checking the original skb length, rather than
the routed skb. Check the routed skb instead; the original will have
been freed at this point.

Fixes: 8892c0490779 ("mctp: Add route input to socket tests")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/kernel-janitors/4ad204f0-94cf-46c5-bdab-49592addf315@kili.mountain/
Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20240816-mctp-kunit-skb-fix-v1-1-3c367ac89c27@codeconstruct.com.au
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mctp/test/route-test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mctp/test/route-test.c b/net/mctp/test/route-test.c
index 77e5dd4222580..8551dab1d1e69 100644
--- a/net/mctp/test/route-test.c
+++ b/net/mctp/test/route-test.c
@@ -366,7 +366,7 @@ static void mctp_test_route_input_sk(struct kunit *test)
 
 		skb2 = skb_recv_datagram(sock->sk, MSG_DONTWAIT, &rc);
 		KUNIT_EXPECT_NOT_ERR_OR_NULL(test, skb2);
-		KUNIT_EXPECT_EQ(test, skb->len, 1);
+		KUNIT_EXPECT_EQ(test, skb2->len, 1);
 
 		skb_free_datagram(sock->sk, skb2);
 
-- 
2.43.0



