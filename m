Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF543B7767;
	Sat, 17 Oct 2026 17:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258936; cv=none; b=CjWsXjpN77zuw689mjdRmJjFfuPgg6twyE3CZf6DYX9fuemCqA1OILyp8yLIjF8uCJFwu+XIP9bsAU/iEJDtQVfJcJLqSXpe10ZFqXxsM16xOnmUodtFCR2fTgPu8AcsNcVExG/ypD9oOPkKLexw0qUJ4nMBWbOsRtQBYu8uvG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258936; c=relaxed/simple;
	bh=aQpb1dyRoFBMbaIhSV21fkjSzA8aXShFrAl76pRXP5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sh+aJcX4QZNGT5cD1zSKZgP+LiYTRXXlrkpl32KjqK1ayz8DjSfXEhPN/xmBDOL/6rfB1nmCjQXPythy8Do2s6GEu3mA3k6qWAlwgBGbU8ev2aM7uUzy4VqRboVn7l+gWfshYmrsl3mvu1CIoB2/beXAdN+Djb7PrjwuFWtB97I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1WJ9Mfno; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1WJ9Mfno"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67EEC1F000C4;
	Sat, 17 Oct 2026 17:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258935;
	bh=DFa9NloQ9FAAF/DnRTotvnrP2PU8UDzAx3iu1hIIpgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1WJ9Mfno+zzQXyDC2BK+xmFGkFsbjryN4Efh5N1Tz/cXDsvFnShVl2eE552E+2nsP
	 clJnnUkHQlo1Yrhu2b8SV4PQOP5AmLqczR9EqqRLsAH8zQwNSmtF+nsj+EG5F1bZyw
	 RHXUTPs1WeQERzbguQxgzpv4OOCF9UfPOJj++BsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kartik <kkartik@nvidia.com>,
	Kees Cook <keescook@chromium.org>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1047/1674] mm/util: Introduce kmemdup_array()
Date: Sat, 17 Oct 2026 17:55:19 +0200
Message-ID: <20261017160458.007711457@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Kartik <kkartik@nvidia.com>

[ Upstream commit 7092e9b3bed1252c7d3f5812b9fb9d82375b73a6 ]

Introduce kmemdup_array() API to duplicate `n` number of elements
from a given array. This internally uses kmemdup to allocate and duplicate
the `src` array.

Signed-off-by: Kartik <kkartik@nvidia.com>
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Stable-dep-of: b62eb8dcf2c4 ("netfilter: x_tables: allocate hook ops while under mutex")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/string.h |  1 +
 mm/util.c              | 17 +++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/include/linux/string.h b/include/linux/string.h
index bbcaceb8fb6f5..2722badba6ace 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -232,6 +232,7 @@ extern char *kstrndup(const char *s, size_t len, gfp_t gfp);
 extern void *kmemdup(const void *src, size_t len, gfp_t gfp) __realloc_size(2);
 extern void *kvmemdup(const void *src, size_t len, gfp_t gfp) __realloc_size(2);
 extern char *kmemdup_nul(const char *s, size_t len, gfp_t gfp);
+extern void *kmemdup_array(const void *src, size_t element_size, size_t count, gfp_t gfp);
 
 extern char **argv_split(gfp_t gfp, const char *str, int *argcp);
 extern void argv_free(char **argv);
diff --git a/mm/util.c b/mm/util.c
index 08d4948965522..b8a7ec4471922 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -135,6 +135,23 @@ void *kmemdup(const void *src, size_t len, gfp_t gfp)
 }
 EXPORT_SYMBOL(kmemdup);
 
+/**
+ * kmemdup_array - duplicate a given array.
+ *
+ * @src: array to duplicate.
+ * @element_size: size of each element of array.
+ * @count: number of elements to duplicate from array.
+ * @gfp: GFP mask to use.
+ *
+ * Return: duplicated array of @src or %NULL in case of error,
+ * result is physically contiguous. Use kfree() to free.
+ */
+void *kmemdup_array(const void *src, size_t element_size, size_t count, gfp_t gfp)
+{
+	return kmemdup(src, size_mul(element_size, count), gfp);
+}
+EXPORT_SYMBOL(kmemdup_array);
+
 /**
  * kvmemdup - duplicate region of memory
  *
-- 
2.53.0



