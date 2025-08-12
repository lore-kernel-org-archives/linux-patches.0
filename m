Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F07A561FFE;
	Tue, 12 Aug 2025 18:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023259; cv=none; b=auq6VZJZbxFkUogppSE0a0waEmw763+SJZrRMG6sD8vh/BB685ypov9lp+Ai1/stxdVPWyaMnQxndnkInDHhcuipszGstUG0n1O/R3Zrr5/rJWN8/7e/wirsRPpd+Fgw0kHN63PyEdwz8phbwsHtylvEchlS78c862XZXjJQgAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023259; c=relaxed/simple;
	bh=OClbtLQbIRAcvNHD7b9rlxaOPuAGFLtAihK/EtEQZ4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oUcmj+EFSpo51ulGsnGTCXMPno1eSi3nlnsaspdbRGQnWt8RUKXBqK3UVkvDKfI+S40YkEvLj2PVx7pSa58sMlzGnB0BX0jZ0Ez6OkolckBuEXt1zRSZyv3HEXoQ7t5nEBuyW2ceo4oJYCTq2HaljqIps3CDhD9z9N27niliv/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v63OUtsI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v63OUtsI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ED34C4CEF1;
	Tue, 12 Aug 2025 18:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023258;
	bh=OClbtLQbIRAcvNHD7b9rlxaOPuAGFLtAihK/EtEQZ4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v63OUtsIU8Er4/6DoQAPKXSJGyp4dVDWCOV4Oz6CAgKYmRuca4JJjxLyth+/Joj1z
	 2nxzMnEELd8ZCOWoqr6I7yIPvn8z9WV1NTT1CRutRo0q21XcvV+hmRgLzvBmO2gk9c
	 Kx1MOxy+WrsI+9kB0vQL4usxbrlYDMuRjD+mzpfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tingmao Wang <m@maowtm.org>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 007/627] landlock: Fix warning from KUnit tests
Date: Tue, 12 Aug 2025 19:25:02 +0200
Message-ID: <20250812173419.600450115@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tingmao Wang <m@maowtm.org>

[ Upstream commit e0a69cf2c03e61bd8069becb97f66c173d0d1fa1 ]

get_id_range() expects a positive value as first argument but
get_random_u8() can return 0.  Fix this by clamping it.

Validated by running the test in a for loop for 1000 times.

Note that MAX() is wrong as it is only supposed to be used for
constants, but max() is good here.

  [..]     ok 9 test_range2_rand1
  [..]     ok 10 test_range2_rand2
  [..]     ok 11 test_range2_rand15
  [..] ------------[ cut here ]------------
  [..] WARNING: CPU: 6 PID: 104 at security/landlock/id.c:99 test_range2_rand16 (security/landlock/id.c:99 (discriminator 1) security/landlock/id.c:234 (discriminator 1))
  [..] Modules linked in:
  [..] CPU: 6 UID: 0 PID: 104 Comm: kunit_try_catch Tainted: G                 N  6.16.0-rc1-dev-00001-g314a2f98b65f #1 PREEMPT(undef)
  [..] Tainted: [N]=TEST
  [..] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
  [..] RIP: 0010:test_range2_rand16 (security/landlock/id.c:99 (discriminator 1) security/landlock/id.c:234 (discriminator 1))
  [..] Code: 49 c7 c0 10 70 30 82 4c 89 ff 48 c7 c6 a0 63 1e 83 49 c7 45 a0 e0 63 1e 83 e8 3f 95 17 00 e9 1f ff ff ff 0f 0b e9 df fd ff ff <0f> 0b ba 01 00 00 00 e9 68 fe ff ff 49 89 45 a8 49 8d 4d a0 45 31

  [..] RSP: 0000:ffff888104eb7c78 EFLAGS: 00010246
  [..] RAX: 0000000000000000 RBX: 000000000870822c RCX: 0000000000000000
            ^^^^^^^^^^^^^^^^
  [..]
  [..] Call Trace:
  [..]
  [..] ---[ end trace 0000000000000000 ]---
  [..]     ok 12 test_range2_rand16
  [..] # landlock_id: pass:12 fail:0 skip:0 total:12
  [..] # Totals: pass:12 fail:0 skip:0 total:12
  [..] ok 1 landlock_id

Fixes: d9d2a68ed44b ("landlock: Add unique ID generator")
Signed-off-by: Tingmao Wang <m@maowtm.org>
Link: https://lore.kernel.org/r/73e28efc5b8cc394608b99d5bc2596ca917d7c4a.1750003733.git.m@maowtm.org
[mic: Minor cosmetic improvements]
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/landlock/id.c | 69 +++++++++++++++++++++++++-----------------
 1 file changed, 42 insertions(+), 27 deletions(-)

diff --git a/security/landlock/id.c b/security/landlock/id.c
index 56f7cc0fc744..838c3ed7bb82 100644
--- a/security/landlock/id.c
+++ b/security/landlock/id.c
@@ -119,6 +119,12 @@ static u64 get_id_range(size_t number_of_ids, atomic64_t *const counter,
 
 #ifdef CONFIG_SECURITY_LANDLOCK_KUNIT_TEST
 
+static u8 get_random_u8_positive(void)
+{
+	/* max() evaluates its arguments once. */
+	return max(1, get_random_u8());
+}
+
 static void test_range1_rand0(struct kunit *const test)
 {
 	atomic64_t counter;
@@ -127,9 +133,10 @@ static void test_range1_rand0(struct kunit *const test)
 	init = get_random_u32();
 	atomic64_set(&counter, init);
 	KUNIT_EXPECT_EQ(test, get_id_range(1, &counter, 0), init);
-	KUNIT_EXPECT_EQ(
-		test, get_id_range(get_random_u8(), &counter, get_random_u8()),
-		init + 1);
+	KUNIT_EXPECT_EQ(test,
+			get_id_range(get_random_u8_positive(), &counter,
+				     get_random_u8()),
+			init + 1);
 }
 
 static void test_range1_rand1(struct kunit *const test)
@@ -140,9 +147,10 @@ static void test_range1_rand1(struct kunit *const test)
 	init = get_random_u32();
 	atomic64_set(&counter, init);
 	KUNIT_EXPECT_EQ(test, get_id_range(1, &counter, 1), init);
-	KUNIT_EXPECT_EQ(
-		test, get_id_range(get_random_u8(), &counter, get_random_u8()),
-		init + 2);
+	KUNIT_EXPECT_EQ(test,
+			get_id_range(get_random_u8_positive(), &counter,
+				     get_random_u8()),
+			init + 2);
 }
 
 static void test_range1_rand15(struct kunit *const test)
@@ -153,9 +161,10 @@ static void test_range1_rand15(struct kunit *const test)
 	init = get_random_u32();
 	atomic64_set(&counter, init);
 	KUNIT_EXPECT_EQ(test, get_id_range(1, &counter, 15), init);
-	KUNIT_EXPECT_EQ(
-		test, get_id_range(get_random_u8(), &counter, get_random_u8()),
-		init + 16);
+	KUNIT_EXPECT_EQ(test,
+			get_id_range(get_random_u8_positive(), &counter,
+				     get_random_u8()),
+			init + 16);
 }
 
 static void test_range1_rand16(struct kunit *const test)
@@ -166,9 +175,10 @@ static void test_range1_rand16(struct kunit *const test)
 	init = get_random_u32();
 	atomic64_set(&counter, init);
 	KUNIT_EXPECT_EQ(test, get_id_range(1, &counter, 16), init);
-	KUNIT_EXPECT_EQ(
-		test, get_id_range(get_random_u8(), &counter, get_random_u8()),
-		init + 1);
+	KUNIT_EXPECT_EQ(test,
+			get_id_range(get_random_u8_positive(), &counter,
+				     get_random_u8()),
+			init + 1);
 }
 
 static void test_range2_rand0(struct kunit *const test)
@@ -179,9 +189,10 @@ static void test_range2_rand0(struct kunit *const test)
 	init = get_random_u32();
 	atomic64_set(&counter, init);
 	KUNIT_EXPECT_EQ(test, get_id_range(2, &counter, 0), init);
-	KUNIT_EXPECT_EQ(
-		test, get_id_range(get_random_u8(), &counter, get_random_u8()),
-		init + 2);
+	KUNIT_EXPECT_EQ(test,
+			get_id_range(get_random_u8_positive(), &counter,
+				     get_random_u8()),
+			init + 2);
 }
 
 static void test_range2_rand1(struct kunit *const test)
@@ -192,9 +203,10 @@ static void test_range2_rand1(struct kunit *const test)
 	init = get_random_u32();
 	atomic64_set(&counter, init);
 	KUNIT_EXPECT_EQ(test, get_id_range(2, &counter, 1), init);
-	KUNIT_EXPECT_EQ(
-		test, get_id_range(get_random_u8(), &counter, get_random_u8()),
-		init + 3);
+	KUNIT_EXPECT_EQ(test,
+			get_id_range(get_random_u8_positive(), &counter,
+				     get_random_u8()),
+			init + 3);
 }
 
 static void test_range2_rand2(struct kunit *const test)
@@ -205,9 +217,10 @@ static void test_range2_rand2(struct kunit *const test)
 	init = get_random_u32();
 	atomic64_set(&counter, init);
 	KUNIT_EXPECT_EQ(test, get_id_range(2, &counter, 2), init);
-	KUNIT_EXPECT_EQ(
-		test, get_id_range(get_random_u8(), &counter, get_random_u8()),
-		init + 4);
+	KUNIT_EXPECT_EQ(test,
+			get_id_range(get_random_u8_positive(), &counter,
+				     get_random_u8()),
+			init + 4);
 }
 
 static void test_range2_rand15(struct kunit *const test)
@@ -218,9 +231,10 @@ static void test_range2_rand15(struct kunit *const test)
 	init = get_random_u32();
 	atomic64_set(&counter, init);
 	KUNIT_EXPECT_EQ(test, get_id_range(2, &counter, 15), init);
-	KUNIT_EXPECT_EQ(
-		test, get_id_range(get_random_u8(), &counter, get_random_u8()),
-		init + 17);
+	KUNIT_EXPECT_EQ(test,
+			get_id_range(get_random_u8_positive(), &counter,
+				     get_random_u8()),
+			init + 17);
 }
 
 static void test_range2_rand16(struct kunit *const test)
@@ -231,9 +245,10 @@ static void test_range2_rand16(struct kunit *const test)
 	init = get_random_u32();
 	atomic64_set(&counter, init);
 	KUNIT_EXPECT_EQ(test, get_id_range(2, &counter, 16), init);
-	KUNIT_EXPECT_EQ(
-		test, get_id_range(get_random_u8(), &counter, get_random_u8()),
-		init + 2);
+	KUNIT_EXPECT_EQ(test,
+			get_id_range(get_random_u8_positive(), &counter,
+				     get_random_u8()),
+			init + 2);
 }
 
 #endif /* CONFIG_SECURITY_LANDLOCK_KUNIT_TEST */
-- 
2.39.5



