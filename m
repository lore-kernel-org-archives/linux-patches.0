Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A99183CDC;
	Sun,  1 Sep 2024 16:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209320; cv=none; b=O33kwvBz5U/UpxpoMOd2h4fy2FIrbF6fKiQMJIlCN0NwO2ocq3HgocNyjHVjI8HhL15ci4Pmqqpbhq9XVFHeap6YLeF5QkiwlONcRkPXVT2FEdFxyUTw6RWa1Kogm/Oa9yzPEl3SgWoj2fWrhfjq2rXqb2Ar9uR6T+e731f9DSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209320; c=relaxed/simple;
	bh=Ev/xt/P7k4UuUDeuPeGznF7oWyBWMuYDSAclM8VA8zU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M4O12G10AFbDX9pl39aQFyIJBG2IpzVNTIj+9Gf5YHrLbVJcpgTD5LFvc0sxXtHSGKW11Ey+SOR6Yt7NU8A+qu8koV2lZH/2ICMCO9WTprAi4SeJf45cRAjyTHsWtmoVFOzEThUK3a+giKVEFskhe9r8HOA3dkdsaGoABbtJeec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=neHTSQr9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="neHTSQr9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48E26C4CEC3;
	Sun,  1 Sep 2024 16:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209320;
	bh=Ev/xt/P7k4UuUDeuPeGznF7oWyBWMuYDSAclM8VA8zU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=neHTSQr9F4cpdmDg6Bcrh3BBkyIQrAnNeMg5kEz0hmLrjhPNnvLJysZ4sajz0z6O0
	 obVfOp1C3FRQBNr896srj7bZqp1ewIYhDS9VQ/bRGusVZNFUNleNc1kCeQCZGe21cI
	 KgUCsrZvdNykDdIqKwHUxO4mi/B0+zAvCnzC5qmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brendan Higgins <brendanhiggins@google.com>,
	Kees Cook <keescook@chromium.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 70/71] apparmor: fix policy_unpack_test on big endian systems
Date: Sun,  1 Sep 2024 18:18:15 +0200
Message-ID: <20240901160804.529724268@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160801.879647959@linuxfoundation.org>
References: <20240901160801.879647959@linuxfoundation.org>
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
index f25cf2a023d57..0711a0305df34 100644
--- a/security/apparmor/policy_unpack_test.c
+++ b/security/apparmor/policy_unpack_test.c
@@ -81,14 +81,14 @@ static struct aa_ext *build_aa_ext_struct(struct policy_unpack_fixture *puf,
 	*(buf + 1) = strlen(TEST_U32_NAME) + 1;
 	strcpy(buf + 3, TEST_U32_NAME);
 	*(buf + 3 + strlen(TEST_U32_NAME) + 1) = AA_U32;
-	*((u32 *)(buf + 3 + strlen(TEST_U32_NAME) + 2)) = TEST_U32_DATA;
+	*((__le32 *)(buf + 3 + strlen(TEST_U32_NAME) + 2)) = cpu_to_le32(TEST_U32_DATA);
 
 	buf = e->start + TEST_NAMED_U64_BUF_OFFSET;
 	*buf = AA_NAME;
 	*(buf + 1) = strlen(TEST_U64_NAME) + 1;
 	strcpy(buf + 3, TEST_U64_NAME);
 	*(buf + 3 + strlen(TEST_U64_NAME) + 1) = AA_U64;
-	*((u64 *)(buf + 3 + strlen(TEST_U64_NAME) + 2)) = TEST_U64_DATA;
+	*((__le64 *)(buf + 3 + strlen(TEST_U64_NAME) + 2)) = cpu_to_le64(TEST_U64_DATA);
 
 	buf = e->start + TEST_NAMED_BLOB_BUF_OFFSET;
 	*buf = AA_NAME;
@@ -104,7 +104,7 @@ static struct aa_ext *build_aa_ext_struct(struct policy_unpack_fixture *puf,
 	*(buf + 1) = strlen(TEST_ARRAY_NAME) + 1;
 	strcpy(buf + 3, TEST_ARRAY_NAME);
 	*(buf + 3 + strlen(TEST_ARRAY_NAME) + 1) = AA_ARRAY;
-	*((u16 *)(buf + 3 + strlen(TEST_ARRAY_NAME) + 2)) = TEST_ARRAY_SIZE;
+	*((__le16 *)(buf + 3 + strlen(TEST_ARRAY_NAME) + 2)) = cpu_to_le16(TEST_ARRAY_SIZE);
 
 	return e;
 }
-- 
2.43.0



