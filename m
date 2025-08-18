Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A37531B100;
	Mon, 18 Aug 2025 13:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525372; cv=none; b=h6QHhsIVqFfmXUX8epSQ6u/ztkE4PIP5gkRWq3WQs074opdeXJ8BrX9FbXP///eKvpq4oFMfzqyWqe+B4FYr/T+sY9bqNUuZ7W487esTqMIg7ejng+gSZbA4FB2W8jV1dyRAn8prT6RwXwYDeEGzb2DY8ClYbFX7aSB4p82cFe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525372; c=relaxed/simple;
	bh=/e9LzIx9uZAmpDlAo7zqXJM8UHjZu35SAZ4mzRSmfEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SX07gO4gCXRIccltsyt+ZwEAmKwPVjAYU2LD/S7UopS/oQ5o6DIF6eKLBKDp34Dk76SXiWFkOMwPtYBcg2W2IifMFrhr0Qea4C4OLKY/fCgtp3+MrsiT+qGU7+v16nDETOZ6T9KGDSsuZ9bQczLvtw3YUKuC/4t+8T6BDPx1arA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yf7pivxY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yf7pivxY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 101A3C4CEEB;
	Mon, 18 Aug 2025 13:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525372;
	bh=/e9LzIx9uZAmpDlAo7zqXJM8UHjZu35SAZ4mzRSmfEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yf7pivxYMx4eE1vKEY2H8W+TNmihFbkrHtvGJDs43hitaUZyZCpfWBkhiSD/l7NEs
	 fhsTYVCJiZZsAh8uGfSYea/no7tJt7upbwxbueSw4PQkqfi4COPMZ7wioAV8KBSQBm
	 cmwmWGb/36d2jCoJVlXxTPAFP1RH7kk7vopXJw/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Hutchings <benh@debian.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 209/570] bootconfig: Fix unaligned access when building footer
Date: Mon, 18 Aug 2025 14:43:16 +0200
Message-ID: <20250818124513.854983152@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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



