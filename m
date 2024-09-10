Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B63188A28;
	Tue, 10 Sep 2024 10:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963958; cv=none; b=H0wwAfQFfthlIfkqDZ3XCeZmqPbI5RbGw9mejUvC4Jj8dPZYQWNGxu4AxS5QVfE+Iua+rJg0XhwS2r7QE1KNjyqTLnbtTW9WaGYz/0ezfYPN+bdMoaA5c2plXvmcpVTAHpVEhpt+hwxWNzYHrzrBWhZ2NjcLRNhDcB/mrRBbuac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963958; c=relaxed/simple;
	bh=chEoo/ZTyWFfC9/dygPvjkNftMiZosV1W9WFpmTvbug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BOoJa0R285AsNDwZvF2bbiY2TbSmtN4r5nX2IryfOycjee/Pc+N+sJjwlEtqCTP+7mPQWNTJMhvTzC1INTlOvGuTEQRfs8bXON2jrBRkgWcw5KRAY7Kenw8hkNUjZonS4mXFgB5msm0Uo/1vqapFQmMzRxwlNadsRVzvvju8xgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VzViCbko; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VzViCbko"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E25E3C4CEC3;
	Tue, 10 Sep 2024 10:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963958;
	bh=chEoo/ZTyWFfC9/dygPvjkNftMiZosV1W9WFpmTvbug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VzViCbkoa4kx2z0YxBgXRrFWXcUmWM1wova3GIa3aBpiqYtUAhqH+jx2NpdmZhas6
	 sCX8DNLxTHInx26KJvmxhsMlmtZuKXF5/CbeZ3+yHoYKXvdFuUC4wqdxFrjIbbFYiF
	 7TWPlS5wIEWfsihlB9ySeexvbrOwmKeqcbkhdKmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	=?UTF-8?q?Jens=20Emil=20Schulz=20=C3=98stergaard?= <jensemil.schulzostergaard@microchip.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.6 002/269] net: microchip: vcap: Fix use-after-free error in kunit test
Date: Tue, 10 Sep 2024 11:29:49 +0200
Message-ID: <20240910092608.318733515@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Emil Schulz Østergaard <jensemil.schulzostergaard@microchip.com>

commit a3c1e45156ad39f225cd7ddae0f81230a3b1e657 upstream.

This is a clear use-after-free error. We remove it, and rely on checking
the return code of vcap_del_rule.

Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/kernel-janitors/7bffefc6-219a-4f71-baa0-ad4526e5c198@kili.mountain/
Fixes: c956b9b318d9 ("net: microchip: sparx5: Adding KUNIT tests of key/action values in VCAP API")
Signed-off-by: Jens Emil Schulz Østergaard <jensemil.schulzostergaard@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c |   14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

--- a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
@@ -1442,18 +1442,8 @@ static void vcap_api_encode_rule_test(st
 	vcap_enable_lookups(&test_vctrl, &test_netdev, 0, 0,
 			    rule->cookie, false);
 
-	vcap_free_rule(rule);
-
-	/* Check that the rule has been freed: tricky to access since this
-	 * memory should not be accessible anymore
-	 */
-	KUNIT_EXPECT_PTR_NE(test, NULL, rule);
-	ret = list_empty(&rule->keyfields);
-	KUNIT_EXPECT_EQ(test, true, ret);
-	ret = list_empty(&rule->actionfields);
-	KUNIT_EXPECT_EQ(test, true, ret);
-
-	vcap_del_rule(&test_vctrl, &test_netdev, id);
+	ret = vcap_del_rule(&test_vctrl, &test_netdev, id);
+	KUNIT_EXPECT_EQ(test, 0, ret);
 }
 
 static void vcap_api_set_rule_counter_test(struct kunit *test)


