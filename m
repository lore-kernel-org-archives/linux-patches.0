Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3051714A8;
	Thu, 15 Aug 2024 13:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729122; cv=none; b=MJHB5czP8fNmxGpwtcKW8lTjxJdF/TVjmTBfeXDcMCDwiylApegEP1eU1KQ0ACvlrbPGs6zMsFqj1SGW1wDkltnEm3uFG9nQk6CuJww6u2pccPHwyv6T3sESgr/2g1cBF8tlWkkSxMswU1fE9bGGKSKe43JHzyGFBvzfzIl/sqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729122; c=relaxed/simple;
	bh=QQXOn/ZRm/rfhhm23ttsJrXs67JCG2fE53rjTQoBHs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DvMK8e6uvKJOJyFb2zeCs8vFu27ImVBmplb7vrlIie2S+iQGrmQqQcbUfDeIAp+b2yRD8IrnUtm76Czgt+befD15PtqiZ6FtmNgOyiamyVcrtxkQHrNYxsRBu8wpUDg5YQbBZnmGUzsB0Xe/fTRXhIe3Rd08lLWHZA9ZNFpinYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UvqUn6RQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UvqUn6RQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E2AAC32786;
	Thu, 15 Aug 2024 13:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729122;
	bh=QQXOn/ZRm/rfhhm23ttsJrXs67JCG2fE53rjTQoBHs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UvqUn6RQJ6nwctev4NOD9bV5nan0hiNOnfm8r4cYTLQdNNxXH0l2HokkUJqMHCTTf
	 tRF5+qi2faba9ZITr/XdvTtHKi3bw+oOK/zSMmC+XIN+FxvqHRPngPoI+b0gjUkC2e
	 fhBVnXqDtG10YGEYkMS6yapHTZxuO6fR5ZsSk5O0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan ORear <sorear@fastmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Greg Ungerer <gerg@linux-m68k.org>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 20/22] binfmt_flat: Fix corruption when not offsetting data start
Date: Thu, 15 Aug 2024 15:25:28 +0200
Message-ID: <20240815131832.035944988@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131831.265729493@linuxfoundation.org>
References: <20240815131831.265729493@linuxfoundation.org>
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



