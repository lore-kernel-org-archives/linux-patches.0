Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13BD025A2DE;
	Mon, 18 Aug 2025 13:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523614; cv=none; b=Fh0wHXtNQOJeh7OeObpfsuDCqt87rQf4Fd6IcHXXvuwNhqIuzL050LYIXhctp9z9OMTSX/t0uePbDKg7rNubwAenZjmY5SOonFKp/yRwzs/za3mI68w5YJXHnpjkqfX2ln3vh8iost9RiB3P4xn10tv00mu1V5Nvzfc/0m6na9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523614; c=relaxed/simple;
	bh=k4t9SKnTn+oCiWNJMRJtJigHJqdHpBUWSku9SZN3Seg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hNX1TIL13dFxhlQKtB+KNBibGhlcyhdMFblilu8Tqh/9ilAsYFMVQ3TrBKTBS96nQPeLsXSEyQZz6ipsV9aWGrZbqLPFMGp8nP1B/KRd//OjXZXeIcld3+JdoW3UcckaIeOwX0rB8LG6cDkwxnZDg4Bo3cPZG8xgM7E3IfxfytE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hDzwmVdr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hDzwmVdr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29161C4CEEB;
	Mon, 18 Aug 2025 13:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523613;
	bh=k4t9SKnTn+oCiWNJMRJtJigHJqdHpBUWSku9SZN3Seg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hDzwmVdrhNLlRwQc6yfH/Yz8Bo7/MvWOnICkdXC0CIKTKM++WavJLTRbV6hGyACzz
	 wBhadDwdS0+fgR7rrlzlydWB8Hjvisu3QVNWEwB7SM987D13+uJ0BkCShKcEwLT7sI
	 5XlQy/LDsePFEN6ct2SbVuFCW2H/Qo8uoZLDAPMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Hutchings <benh@debian.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 193/515] bootconfig: Fix unaligned access when building footer
Date: Mon, 18 Aug 2025 14:42:59 +0200
Message-ID: <20250818124505.799414759@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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



