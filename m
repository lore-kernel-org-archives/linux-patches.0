Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 822D51BB6B4;
	Thu, 15 Aug 2024 14:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731004; cv=none; b=bL0DwQ3JtB5zdtIhs9Vij1BPHh8zBcwrL0TC0TxiUL0DcGhpD/JORUy5RZcjmMQkSO5XMURBHsmM6fWrRFPcSGhprUawy6Jy6TqwT1fRvBEVcw5w6uDyARopkhAV6RFZF31cfPH4yr3dmju526Yu9oWfMADqONzx1mM7GJW3rEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731004; c=relaxed/simple;
	bh=3wcse9R1u6p0nRAHZozFronHV/EOOJRLhSveaREiuOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qVzb02b0QeRu6+Lsfz33AfN+SpQfe5I88NQRdy5jze4pA9es6Sdd9q07pcFn6UacWH3oJ9xyEz3Z5lP4phkFxobWqsoYIMapWGmSjaGMcelYXsjs7OksU1han0Tf45IS4E+gwA0hrq/y7vzJu7krBBPi4ANSzmJbUl8VDZM0XKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gfau0JmP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gfau0JmP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2BDBC4AF0A;
	Thu, 15 Aug 2024 14:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731004;
	bh=3wcse9R1u6p0nRAHZozFronHV/EOOJRLhSveaREiuOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gfau0JmPfW+EgKU4jJwxGusxGQgGwPqzYvfbIEnTCUc8eB5tfayuo/rWfsMdzrEYN
	 knEuEe1nJjTfK4+EkPoa6j9LmuIlQD5e7aCS7ymgpWgrTEMV1wsGrKIYKDnPq+8SLZ
	 0haKXk3R9+MlV4S5oKUMO9KQerHvtnzpF7l8wxEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan ORear <sorear@fastmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Greg Ungerer <gerg@linux-m68k.org>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 61/67] binfmt_flat: Fix corruption when not offsetting data start
Date: Thu, 15 Aug 2024 15:26:15 +0200
Message-ID: <20240815131840.643145788@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131838.311442229@linuxfoundation.org>
References: <20240815131838.311442229@linuxfoundation.org>
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

From: Kees Cook <kees@kernel.org>

[ Upstream commit 3eb3cd5992f7a0c37edc8d05b4c38c98758d8671 ]

Commit 04d82a6d0881 ("binfmt_flat: allow not offsetting data start")
introduced a RISC-V specific variant of the FLAT format which does
not allocate any space for the (obsolete) array of shared library
pointers. However, it did not disable the code which initializes the
array, resulting in the corruption of sizeof(long) bytes before the DATA
segment, generally the end of the TEXT segment.

Introduce MAX_SHARED_LIBS_UPDATE which depends on the state of
CONFIG_BINFMT_FLAT_NO_DATA_START_OFFSET to guard the initialization of
the shared library pointer region so that it will only be initialized
if space is reserved for it.

Fixes: 04d82a6d0881 ("binfmt_flat: allow not offsetting data start")
Co-developed-by: Stefan O'Rear <sorear@fastmail.com>
Signed-off-by: Stefan O'Rear <sorear@fastmail.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Acked-by: Greg Ungerer <gerg@linux-m68k.org>
Link: https://lore.kernel.org/r/20240807195119.it.782-kees@kernel.org
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/binfmt_flat.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
index c26545d71d39a..cd6d5bbb4b9df 100644
--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -72,8 +72,10 @@
 
 #ifdef CONFIG_BINFMT_FLAT_NO_DATA_START_OFFSET
 #define DATA_START_OFFSET_WORDS		(0)
+#define MAX_SHARED_LIBS_UPDATE		(0)
 #else
 #define DATA_START_OFFSET_WORDS		(MAX_SHARED_LIBS)
+#define MAX_SHARED_LIBS_UPDATE		(MAX_SHARED_LIBS)
 #endif
 
 struct lib_info {
@@ -880,7 +882,7 @@ static int load_flat_binary(struct linux_binprm *bprm)
 		return res;
 
 	/* Update data segment pointers for all libraries */
-	for (i = 0; i < MAX_SHARED_LIBS; i++) {
+	for (i = 0; i < MAX_SHARED_LIBS_UPDATE; i++) {
 		if (!libinfo.lib_list[i].loaded)
 			continue;
 		for (j = 0; j < MAX_SHARED_LIBS; j++) {
-- 
2.43.0



