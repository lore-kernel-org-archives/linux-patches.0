Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B163E1CB126;
	Tue, 27 Aug 2024 15:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772503; cv=none; b=Iym7iNqdrF01rxkLr6mOz6lHd7Ytm55fs1UQhAv9fXDAyIqSQJpSR4JNmCxe/KerDAkaDPwsXR6zbEsKwhwV/NsduiUiHgW88MIoDfAYT7ZHUMg+y5pHTkFUnLaOYr7HnFp+c8twYT6FVcPPgVadSeozFuDe5v0Cqpi6Wa7oK88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772503; c=relaxed/simple;
	bh=bPMRD5s7W6VA2M+A89yafUJEUSbbU/JOX0U2Jf9mmr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BIArpKmwcv7B5EIJ47FFa0Vxc36K40/vK8Ils4zMgiJgsZEjN1UvMa9Xz5cXUhhuGpp0U/RRNaJYuOArLfw7ZBTQXfFQXCovVV3DKjvXdhfAi8UsEa9zxXSCEzRbFZq1Wg65tW3ldQvqdTldRNaSW9Yoho6Ic6aWNB718Nv+c2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FwCejzj8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FwCejzj8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 901E9C61047;
	Tue, 27 Aug 2024 15:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772503;
	bh=bPMRD5s7W6VA2M+A89yafUJEUSbbU/JOX0U2Jf9mmr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FwCejzj8CRfDpbiJgzG7QBk61Fg9va4HM49E0hMkLGRUGPp8HUE2MswzW08e/aqqS
	 Ko0UWGX0BP82HUaNsKQir0zPVEEMWk++wM3CRElRw7yTIF93CFk2F48dhe1KfGj4wb
	 AURcJ7unaZzlcTv8fMe+ps6vvB9mpIZP7QKx2f1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 233/321] net: mctp: test: Use correct skb for route input check
Date: Tue, 27 Aug 2024 16:39:01 +0200
Message-ID: <20240827143847.107112915@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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
index 92ea4158f7fc4..a944490a724d3 100644
--- a/net/mctp/test/route-test.c
+++ b/net/mctp/test/route-test.c
@@ -354,7 +354,7 @@ static void mctp_test_route_input_sk(struct kunit *test)
 
 		skb2 = skb_recv_datagram(sock->sk, MSG_DONTWAIT, &rc);
 		KUNIT_EXPECT_NOT_ERR_OR_NULL(test, skb2);
-		KUNIT_EXPECT_EQ(test, skb->len, 1);
+		KUNIT_EXPECT_EQ(test, skb2->len, 1);
 
 		skb_free_datagram(sock->sk, skb2);
 
-- 
2.43.0



