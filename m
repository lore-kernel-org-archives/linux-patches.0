Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA442FAC06;
	Tue, 12 Aug 2025 18:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024843; cv=none; b=A5/1uZyOYRpKTxDeCQApciyTTvONW8g+CQgh2jCXCyLAKHwednGCxY+NxNwdOK8QeX8ny0rpw9v0AoTRnzKNJudbeihjZkTGBjvpabZhYRJ7NgtoFjExTvDbGH0F+9wJkEoSmnh+Uxj0UaE0BbrdOgvNzoycRpdN1xEF08yP04Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024843; c=relaxed/simple;
	bh=6GxUVc54Z25alAVPLa6t9W12IdCl37j69YaivzeCkws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g464sIapEtBogkezFqxhF2jwb647K1MVBsPdf5h50gXM5A/0RkI8LK2xGEI7ZZwAmRYiu843ONIS/0wCf2KHbnWkWwyPSj3K27t7mefOx92ZjlNwLSZkSCBLDyiK0b0PZhOvdm2mF87JBqMkyv8lPmxe2AAn8/d1pRxOHdWXaFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VnZMCUbG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VnZMCUbG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E205C4CEF1;
	Tue, 12 Aug 2025 18:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024843;
	bh=6GxUVc54Z25alAVPLa6t9W12IdCl37j69YaivzeCkws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VnZMCUbGm+r6g+6oVrk3pNp98988fb6sulzcEUYbhNF49nCgpiMjC7TkdwcxeBh9G
	 Ec6wJbKT/M/+qEc53fNKfz9Hpu9z6ZKoN/4FprnajINKxcdV8cEwEM1Bf8WeRC5C/2
	 R8FYDA7bLjqDXA2KVmoxGmV0e6jBvzWSgJUGFqcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 460/627] apparmor: Fix unaligned memory accesses in KUnit test
Date: Tue, 12 Aug 2025 19:32:35 +0200
Message-ID: <20250812173439.017865946@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

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



