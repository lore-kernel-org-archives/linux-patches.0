Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF2F26FD9D;
	Mon, 18 Aug 2025 12:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521926; cv=none; b=u3K/Auebdu+2xShReR9Cc8fZo/x81M8WtsENdX6gMyI4fotc0oOkhgmTj+/arTKe1UV8hxT05yKqJqmKsZ2gkcCOrPv62zD8i8xqsQAIu5dlu2kd5xgZx1ba/5nKNUbp2CiQLZlsAR+bDJZXFlIyIndzHbs6L09X70UiFq/aihQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521926; c=relaxed/simple;
	bh=A/CvHRfITogCSDPhhUr09v1TyJfE1Jm9crk6r3gCCnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cHoSI/EJioA4MKtw4c5CSxjkRXn6SKNG08vbtZEoPjH2zEziZc3czHIekbD3uz/foJxKe0Zd4bfH64ElOJ7LaBWotjtSqkFFoar9By805i2k8buNSQeQY1eavsMe/NvyEomIz4QhlhJt9wq50PjYCteBIquyKgo9VFk6OjlfSjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e6lU9qd9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e6lU9qd9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6B58C4CEEB;
	Mon, 18 Aug 2025 12:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521926;
	bh=A/CvHRfITogCSDPhhUr09v1TyJfE1Jm9crk6r3gCCnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e6lU9qd9/zZBHMNsk2PWR1nKrCI5wZ2Oxdekww1E2AuTxUaMNF4OfFlQQnhadWH7b
	 VjDAHkhEOmx6oyrgk9JWCjywz2plIBorTdiO6YYBAB/O5DbybkwSOuOYu8RKStoIsE
	 XTPBsy7N7FcIVvJyNHPtGjowjqlG3TLq3GqYSBgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Hutchings <benh@debian.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 164/444] bootconfig: Fix unaligned access when building footer
Date: Mon, 18 Aug 2025 14:43:10 +0200
Message-ID: <20250818124455.045136639@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <benh@debian.org>

[ Upstream commit 6ed5e20466c79e3b3350bae39f678f73cf564b4e ]

Currently we add padding between the bootconfig text and footer to
ensure that the footer is aligned within the initramfs image.
However, because only the bootconfig data is held in memory, not the
full initramfs image, the footer may not be naturally aligned in
memory.

This can result in an alignment fault (SIGBUS) when writing the footer
on some architectures, such as sparc.

Build the footer in a struct on the stack before adding it to the
buffer.

References: https://buildd.debian.org/status/fetch.php?pkg=linux&arch=sparc64&ver=6.16%7Erc7-1%7Eexp1&stamp=1753209801&raw=0
Link: https://lore.kernel.org/all/aIC-NTw-cdm9ZGFw@decadent.org.uk/

Signed-off-by: Ben Hutchings <benh@debian.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bootconfig/main.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/tools/bootconfig/main.c b/tools/bootconfig/main.c
index 8a48cc2536f5..dce2d6ffcca5 100644
--- a/tools/bootconfig/main.c
+++ b/tools/bootconfig/main.c
@@ -11,6 +11,7 @@
 #include <string.h>
 #include <errno.h>
 #include <endian.h>
+#include <assert.h>
 
 #include <linux/bootconfig.h>
 
@@ -359,7 +360,12 @@ static int delete_xbc(const char *path)
 
 static int apply_xbc(const char *path, const char *xbc_path)
 {
-	char *buf, *data, *p;
+	struct {
+		uint32_t size;
+		uint32_t csum;
+		char magic[BOOTCONFIG_MAGIC_LEN];
+	} footer;
+	char *buf, *data;
 	size_t total_size;
 	struct stat stat;
 	const char *msg;
@@ -430,17 +436,13 @@ static int apply_xbc(const char *path, const char *xbc_path)
 	size += pad;
 
 	/* Add a footer */
-	p = data + size;
-	*(uint32_t *)p = htole32(size);
-	p += sizeof(uint32_t);
+	footer.size = htole32(size);
+	footer.csum = htole32(csum);
+	memcpy(footer.magic, BOOTCONFIG_MAGIC, BOOTCONFIG_MAGIC_LEN);
+	static_assert(sizeof(footer) == BOOTCONFIG_FOOTER_SIZE);
+	memcpy(data + size, &footer, BOOTCONFIG_FOOTER_SIZE);
 
-	*(uint32_t *)p = htole32(csum);
-	p += sizeof(uint32_t);
-
-	memcpy(p, BOOTCONFIG_MAGIC, BOOTCONFIG_MAGIC_LEN);
-	p += BOOTCONFIG_MAGIC_LEN;
-
-	total_size = p - data;
+	total_size = size + BOOTCONFIG_FOOTER_SIZE;
 
 	ret = write(fd, data, total_size);
 	if (ret < total_size) {
-- 
2.39.5



