Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F79017CA1F;
	Sun,  1 Sep 2024 16:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208653; cv=none; b=mClaYHEdIPPMh59e20m5Y5wnxCWJ+Sqv/98NMIeJmZuPGebus0aj8oq42Bmpo3NZW+t4lc8+PMmXH4moCmsrquHe3RicnsTGeqBW6X0b2wI0GUjHydOWmqahc6r2WvIpdv1qWnxIhwhdkVGNWwpFZpV0M8Gw8UCR1YHB8/hK0Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208653; c=relaxed/simple;
	bh=2WzH4BwU+PsJrgyzSKaPmh8vaT9pcUz6wdQrSXOIRjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=thu9Zn2NJOXiDOJeE/OS/9MOPf13jyQcFHylZQh/YtW9fHnv0He47MOi09bPnaxhPy/LDyutHF2J5jwk3TwtRlY5M1GeN77eR8hM7VG8Qpv7xNfF3GlC+Gw4mpMnIx5rGTyP7fQ0rqd7P4HuNMKZ8/r8cft31wft2yrdZVr26eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=APuMTx4F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="APuMTx4F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E5CBC4CEC3;
	Sun,  1 Sep 2024 16:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208652;
	bh=2WzH4BwU+PsJrgyzSKaPmh8vaT9pcUz6wdQrSXOIRjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=APuMTx4FAkc5tn4QuxNdPZs9zBH8JV4pUtrjLOcbRQpiF8Gru+m8wm4ZC6NSbiy8H
	 MwmjxY/O7GjQiOVh3g0iEFS8KJnf+OcX2h4aoVb/MwIOYApemv4mX6l6U4EO1r7LmJ
	 A1JfMudHBD6+DBurtNR2mZpaWRTySPcV11c6T1h0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brendan Higgins <brendanhiggins@google.com>,
	Kees Cook <keescook@chromium.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 148/149] apparmor: fix policy_unpack_test on big endian systems
Date: Sun,  1 Sep 2024 18:17:39 +0200
Message-ID: <20240901160823.011775196@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 98c0cc48e27e9d269a3e4db2acd72b486c88ec77 ]

policy_unpack_test fails on big endian systems because data byte order
is expected to be little endian but is generated in host byte order.
This results in test failures such as:

 # policy_unpack_test_unpack_array_with_null_name: EXPECTATION FAILED at security/apparmor/policy_unpack_test.c:150
    Expected array_size == (u16)16, but
        array_size == 4096 (0x1000)
        (u16)16 == 16 (0x10)
    # policy_unpack_test_unpack_array_with_null_name: pass:0 fail:1 skip:0 total:1
    not ok 3 policy_unpack_test_unpack_array_with_null_name
    # policy_unpack_test_unpack_array_with_name: EXPECTATION FAILED at security/apparmor/policy_unpack_test.c:164
    Expected array_size == (u16)16, but
        array_size == 4096 (0x1000)
        (u16)16 == 16 (0x10)
    # policy_unpack_test_unpack_array_with_name: pass:0 fail:1 skip:0 total:1

Add the missing endianness conversions when generating test data.

Fixes: 4d944bcd4e73 ("apparmor: add AppArmor KUnit tests for policy unpack")
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/policy_unpack_test.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/security/apparmor/policy_unpack_test.c b/security/apparmor/policy_unpack_test.c
index 5c9bde25e56df..2b8003eb4f463 100644
--- a/security/apparmor/policy_unpack_test.c
+++ b/security/apparmor/policy_unpack_test.c
@@ -80,14 +80,14 @@ static struct aa_ext *build_aa_ext_struct(struct policy_unpack_fixture *puf,
 	*(buf + 1) = strlen(TEST_U32_NAME) + 1;
 	strscpy(buf + 3, TEST_U32_NAME, e->end - (void *)(buf + 3));
 	*(buf + 3 + strlen(TEST_U32_NAME) + 1) = AA_U32;
-	*((u32 *)(buf + 3 + strlen(TEST_U32_NAME) + 2)) = TEST_U32_DATA;
+	*((__le32 *)(buf + 3 + strlen(TEST_U32_NAME) + 2)) = cpu_to_le32(TEST_U32_DATA);
 
 	buf = e->start + TEST_NAMED_U64_BUF_OFFSET;
 	*buf = AA_NAME;
 	*(buf + 1) = strlen(TEST_U64_NAME) + 1;
 	strscpy(buf + 3, TEST_U64_NAME, e->end - (void *)(buf + 3));
 	*(buf + 3 + strlen(TEST_U64_NAME) + 1) = AA_U64;
-	*((u64 *)(buf + 3 + strlen(TEST_U64_NAME) + 2)) = TEST_U64_DATA;
+	*((__le64 *)(buf + 3 + strlen(TEST_U64_NAME) + 2)) = cpu_to_le64(TEST_U64_DATA);
 
 	buf = e->start + TEST_NAMED_BLOB_BUF_OFFSET;
 	*buf = AA_NAME;
@@ -103,7 +103,7 @@ static struct aa_ext *build_aa_ext_struct(struct policy_unpack_fixture *puf,
 	*(buf + 1) = strlen(TEST_ARRAY_NAME) + 1;
 	strscpy(buf + 3, TEST_ARRAY_NAME, e->end - (void *)(buf + 3));
 	*(buf + 3 + strlen(TEST_ARRAY_NAME) + 1) = AA_ARRAY;
-	*((u16 *)(buf + 3 + strlen(TEST_ARRAY_NAME) + 2)) = TEST_ARRAY_SIZE;
+	*((__le16 *)(buf + 3 + strlen(TEST_ARRAY_NAME) + 2)) = cpu_to_le16(TEST_ARRAY_SIZE);
 
 	return e;
 }
-- 
2.43.0



