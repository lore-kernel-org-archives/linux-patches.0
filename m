Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A15918FDAA;
	Fri,  6 Dec 2024 15:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497819; cv=none; b=KlmN2DvR7pcviEARKWWv6dw0WOEiBFnVV9kPLYiG2AwMNLnaW4VGsPX2qEnDA/0nShpwyAuczsfYKgP7vA8T91TwNVplpna8jX/etr7kqaz4hTJFi2PtJsbFUjno0QguzUBv1aouch9vDDfH5Q67pkseoiPtE9NiY3vHTMxrBZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497819; c=relaxed/simple;
	bh=8nS1RBpwG6d1JsACS/1wOAE/JkUezijFhKABtMSTqhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mqAHPdEdPcDFxuXRSKeCUZyOhLCDArTSnXzBF4ClbsLCEvB0cwvkmJ1xojWMlZw1zjh6N5Shd4CVBePQeDj7EyDpCXvrEI/FSQPHtxGDvnQAhnDjhH7w8/Ej1HGEI/GyLxriJtqiIwIyLc10AT4xMhabJ1IDJf4mB9z+sMd1nyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jBfcdnt6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jBfcdnt6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC58C4CED1;
	Fri,  6 Dec 2024 15:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497819;
	bh=8nS1RBpwG6d1JsACS/1wOAE/JkUezijFhKABtMSTqhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jBfcdnt67hWz2D4G0C9FaTLsvihWzs2VgThZ9ZrX5Dqe+gIwhDd2rG35a0vN/GXci
	 OAcyjgal1cA3cBcGiL2KkVDjKmMFJTK8Pq4JhKUhXXB/29iWZzHdH8wx7NniKwO42D
	 7wYLWohw7bIgw/rjeX28/6neGftd6H52Vvom5QLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steen Hegelund <steen.hegelund@microchip.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Daniel Machon <daniel.machon@microchip.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 402/676] net: microchip: vcap: Add typegroup table terminators in kunit tests
Date: Fri,  6 Dec 2024 15:33:41 +0100
Message-ID: <20241206143709.051507650@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit f164b296638d1eb1fb1c537e93ab5c8b49966546 ]

VCAP API unit tests fail randomly with errors such as

   # vcap_api_iterator_init_test: EXPECTATION FAILED at drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c:387
   Expected 134 + 7 == iter.offset, but
       134 + 7 == 141 (0x8d)
       iter.offset == 17214 (0x433e)
   # vcap_api_iterator_init_test: EXPECTATION FAILED at drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c:388
   Expected 5 == iter.reg_idx, but
       iter.reg_idx == 702 (0x2be)
   # vcap_api_iterator_init_test: EXPECTATION FAILED at drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c:389
   Expected 11 == iter.reg_bitpos, but
       iter.reg_bitpos == 15 (0xf)
   # vcap_api_iterator_init_test: pass:0 fail:1 skip:0 total:1

Comments in the code state that "A typegroup table ends with an all-zero
terminator". Add the missing terminators.

Some of the typegroups did have a terminator of ".offset = 0, .width = 0,
.value = 0,". Replace those terminators with "{ }" (no trailing ',') for
consistency and to excplicitly state "this is a terminator".

Fixes: 67d637516fa9 ("net: microchip: sparx5: Adding KUNIT test for the VCAP API")
Cc: Steen Hegelund <steen.hegelund@microchip.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20241119213202.2884639-1-linux@roeck-us.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/microchip/vcap/vcap_api_kunit.c    | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
index 66ef14d95bf6f..88744ae652935 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
@@ -366,12 +366,13 @@ static void vcap_api_iterator_init_test(struct kunit *test)
 	struct vcap_typegroup typegroups[] = {
 		{ .offset = 0, .width = 2, .value = 2, },
 		{ .offset = 156, .width = 1, .value = 0, },
-		{ .offset = 0, .width = 0, .value = 0, },
+		{ }
 	};
 	struct vcap_typegroup typegroups2[] = {
 		{ .offset = 0, .width = 3, .value = 4, },
 		{ .offset = 49, .width = 2, .value = 0, },
 		{ .offset = 98, .width = 2, .value = 0, },
+		{ }
 	};
 
 	vcap_iter_init(&iter, 52, typegroups, 86);
@@ -399,6 +400,7 @@ static void vcap_api_iterator_next_test(struct kunit *test)
 		{ .offset = 147, .width = 3, .value = 0, },
 		{ .offset = 196, .width = 2, .value = 0, },
 		{ .offset = 245, .width = 1, .value = 0, },
+		{ }
 	};
 	int idx;
 
@@ -433,7 +435,7 @@ static void vcap_api_encode_typegroups_test(struct kunit *test)
 		{ .offset = 147, .width = 3, .value = 5, },
 		{ .offset = 196, .width = 2, .value = 2, },
 		{ .offset = 245, .width = 5, .value = 27, },
-		{ .offset = 0, .width = 0, .value = 0, },
+		{ }
 	};
 
 	vcap_encode_typegroups(stream, 49, typegroups, false);
@@ -463,6 +465,7 @@ static void vcap_api_encode_bit_test(struct kunit *test)
 		{ .offset = 147, .width = 3, .value = 5, },
 		{ .offset = 196, .width = 2, .value = 2, },
 		{ .offset = 245, .width = 1, .value = 0, },
+		{ }
 	};
 
 	vcap_iter_init(&iter, 49, typegroups, 44);
@@ -489,7 +492,7 @@ static void vcap_api_encode_field_test(struct kunit *test)
 		{ .offset = 147, .width = 3, .value = 5, },
 		{ .offset = 196, .width = 2, .value = 2, },
 		{ .offset = 245, .width = 5, .value = 27, },
-		{ .offset = 0, .width = 0, .value = 0, },
+		{ }
 	};
 	struct vcap_field rf = {
 		.type = VCAP_FIELD_U32,
@@ -538,7 +541,7 @@ static void vcap_api_encode_short_field_test(struct kunit *test)
 		{ .offset = 0, .width = 3, .value = 7, },
 		{ .offset = 21, .width = 2, .value = 3, },
 		{ .offset = 42, .width = 1, .value = 1, },
-		{ .offset = 0, .width = 0, .value = 0, },
+		{ }
 	};
 	struct vcap_field rf = {
 		.type = VCAP_FIELD_U32,
@@ -608,7 +611,7 @@ static void vcap_api_encode_keyfield_test(struct kunit *test)
 	struct vcap_typegroup tgt[] = {
 		{ .offset = 0, .width = 2, .value = 2, },
 		{ .offset = 156, .width = 1, .value = 1, },
-		{ .offset = 0, .width = 0, .value = 0, },
+		{ }
 	};
 
 	vcap_test_api_init(&admin);
@@ -671,7 +674,7 @@ static void vcap_api_encode_max_keyfield_test(struct kunit *test)
 	struct vcap_typegroup tgt[] = {
 		{ .offset = 0, .width = 2, .value = 2, },
 		{ .offset = 156, .width = 1, .value = 1, },
-		{ .offset = 0, .width = 0, .value = 0, },
+		{ }
 	};
 	u32 keyres[] = {
 		0x928e8a84,
@@ -732,7 +735,7 @@ static void vcap_api_encode_actionfield_test(struct kunit *test)
 		{ .offset = 0, .width = 2, .value = 2, },
 		{ .offset = 21, .width = 1, .value = 1, },
 		{ .offset = 42, .width = 1, .value = 0, },
-		{ .offset = 0, .width = 0, .value = 0, },
+		{ }
 	};
 
 	vcap_encode_actionfield(&rule, &caf, &rf, tgt);
-- 
2.43.0



