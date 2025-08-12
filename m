Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04A129BD9A;
	Tue, 12 Aug 2025 19:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026543; cv=none; b=Y1dcoM3rLLIbb6XvkjgxJh6AjoqL0vZLg6jmEiyThh/lYD8gWmN9DvHEUDvhYMdc4dvU4E0buo5LKb9dcylCWC91ugb7Xb+w8k/SUZqU4QCkY2j1/91Uaer1j+JxNZ6FbSdY/wlBBovwNadSMzF5W1rEjNT3fguZmemN78Z5jrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026543; c=relaxed/simple;
	bh=96GINPaF4i9ltDbp31Ox5wGb/S8A7YhXiJk6gQsz+Nk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pfijBCpD3fnSOK61YaqYdcRR/q+Zf2f+KPc8g0YCTuRHVQSo4HWrkOKCy6eMhkovaXMM6c8RV/1H7UdRT9+wov6ac/9B1h/liCb8hez+Tq8AC2Ohh8kd9LJyB766haRNsQNw53fk3AzXYPEdJ8SePFKQxZZQ0xdmVOVNgRdzDO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YA94jDaT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YA94jDaT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F28D4C4CEF0;
	Tue, 12 Aug 2025 19:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026542;
	bh=96GINPaF4i9ltDbp31Ox5wGb/S8A7YhXiJk6gQsz+Nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YA94jDaT9ax790EcJhOIow/AhpAP/FS0io6v3MXkQKteDbZNbP4uj1rZZ7QxMwyYB
	 9jgu5qHRkjbVinTFPIr/y0SkwVu3T1dcvEr0xObZlVVxyXPr6paLWG1IX8+pKdHXau
	 0zAO51iiRujj+efmSpKTI8zqVxXQfUHf3jP5Il24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 335/480] apparmor: Fix unaligned memory accesses in KUnit test
Date: Tue, 12 Aug 2025 19:49:03 +0200
Message-ID: <20250812174411.259940020@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

[ Upstream commit c68804199dd9d63868497a27b5da3c3cd15356db ]

The testcase triggers some unnecessary unaligned memory accesses on the
parisc architecture:
  Kernel: unaligned access to 0x12f28e27 in policy_unpack_test_init+0x180/0x374 (iir 0x0cdc1280)
  Kernel: unaligned access to 0x12f28e67 in policy_unpack_test_init+0x270/0x374 (iir 0x64dc00ce)

Use the existing helper functions put_unaligned_le32() and
put_unaligned_le16() to avoid such warnings on architectures which
prefer aligned memory accesses.

Signed-off-by: Helge Deller <deller@gmx.de>
Fixes: 98c0cc48e27e ("apparmor: fix policy_unpack_test on big endian systems")
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/policy_unpack_test.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/security/apparmor/policy_unpack_test.c b/security/apparmor/policy_unpack_test.c
index 5b2ba88ae9e2..cf18744dafe2 100644
--- a/security/apparmor/policy_unpack_test.c
+++ b/security/apparmor/policy_unpack_test.c
@@ -9,6 +9,8 @@
 #include "include/policy.h"
 #include "include/policy_unpack.h"
 
+#include <linux/unaligned.h>
+
 #define TEST_STRING_NAME "TEST_STRING"
 #define TEST_STRING_DATA "testing"
 #define TEST_STRING_BUF_OFFSET \
@@ -80,7 +82,7 @@ static struct aa_ext *build_aa_ext_struct(struct policy_unpack_fixture *puf,
 	*(buf + 1) = strlen(TEST_U32_NAME) + 1;
 	strscpy(buf + 3, TEST_U32_NAME, e->end - (void *)(buf + 3));
 	*(buf + 3 + strlen(TEST_U32_NAME) + 1) = AA_U32;
-	*((__le32 *)(buf + 3 + strlen(TEST_U32_NAME) + 2)) = cpu_to_le32(TEST_U32_DATA);
+	put_unaligned_le32(TEST_U32_DATA, buf + 3 + strlen(TEST_U32_NAME) + 2);
 
 	buf = e->start + TEST_NAMED_U64_BUF_OFFSET;
 	*buf = AA_NAME;
@@ -103,7 +105,7 @@ static struct aa_ext *build_aa_ext_struct(struct policy_unpack_fixture *puf,
 	*(buf + 1) = strlen(TEST_ARRAY_NAME) + 1;
 	strscpy(buf + 3, TEST_ARRAY_NAME, e->end - (void *)(buf + 3));
 	*(buf + 3 + strlen(TEST_ARRAY_NAME) + 1) = AA_ARRAY;
-	*((__le16 *)(buf + 3 + strlen(TEST_ARRAY_NAME) + 2)) = cpu_to_le16(TEST_ARRAY_SIZE);
+	put_unaligned_le16(TEST_ARRAY_SIZE, buf + 3 + strlen(TEST_ARRAY_NAME) + 2);
 
 	return e;
 }
-- 
2.39.5



