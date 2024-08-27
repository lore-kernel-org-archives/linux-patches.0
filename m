Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B56C1A01C8;
	Tue, 27 Aug 2024 14:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770517; cv=none; b=JoAlqFi6+G9QSNV7115oBvnIesi0z3T/CLQmCzoRNxdkFmfRpnQn5YwMOQeA08Ut2xQgDEwGAa0A/r4Powbk7fD6ErIUV4rGlxQmJNALPmOo4t15MqLjBxoGu+wPpfeU9p1pv2lkWOcpJ+9O3Gbaa4LzIONCq1jLTfQ0B/c1Yqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770517; c=relaxed/simple;
	bh=31vaVnt6TjunfZbPhhyADMLo2KVeafkqwj2JyqF01JU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G88soq+ohlX7eBJBTpZVTb0wqhL7d0RHPE+0fPr3C8AqdlKXyeCeWiCIaSeJsLoUsNLKRmEstwlu2p4XyrQu6iIOh2x1r5HkVJudtyOkyvmVRwgKYtj3iCleuwhxcAtR0fMOlY9rVCWLAxghHTizhMrjJLSQe9z9W3yBhQuzyas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UNldYS1f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UNldYS1f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B65ECC4E691;
	Tue, 27 Aug 2024 14:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770517;
	bh=31vaVnt6TjunfZbPhhyADMLo2KVeafkqwj2JyqF01JU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UNldYS1fyGsYbQZXXYmzXf0ED/4+s3GH6BpoYPs1Gufv84Q30QA7z+niPFVd636kz
	 W9Wp6m024ZdHNommZZqihf2vJ6XHE+/jgrU2D+M+VNJYnSQJy3SV8VlEMFZWW02fF8
	 +IQ2uafIfZoIBSlpyeqShbDewvXvLUda2T4w5evw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 251/341] net: mctp: test: Use correct skb for route input check
Date: Tue, 27 Aug 2024 16:38:02 +0200
Message-ID: <20240827143852.958079753@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



