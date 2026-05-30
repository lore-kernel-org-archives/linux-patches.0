Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F93F26FA60;
	Sat, 30 May 2026 18:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780167177; cv=none; b=jCHdH0VwU3IdnugzPyWUZCH5r9NZuud4yxr9FEqQKrAklg5OQbr1J7ABCDJj7Akft0N+OzsQpZkYYYCONT7cLqqj4YcyhtZYJYcXGU3upOJsw35PImOX0J5ZkbAvi4z2B4NeaToUcGBWsg2Ud1HCBxktTi9Lo0k9uSCJ02VIDXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780167177; c=relaxed/simple;
	bh=MYA1K4ViHd1+ZQ4IyvTs4O+t+jxs7b6kFc+hrDlNiFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uQUyrTibbp7MKZvRSN1olt4jO/UZYbw+PBn1o17RY9lp4cPuBRjofrxLET1DCgmL/amajtBA5nUZuAcdcBTPsJRCAivNG1dg+p2Yvp7q/8bUHl5olyot449xGp9wcYnVwSe06fS9vXRpU0C5ZYfSJcpXhgp2GqxbUjDbNjqk8OM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z1a5EP2T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z1a5EP2T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE0D11F00893;
	Sat, 30 May 2026 18:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780167175;
	bh=NexSRb1Jmm0PG+xfdpxH0RlKpjC+k56DCWx2mm1t8Lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z1a5EP2TjWrVGCmOCArlxaMWXZ+srzEhuQ+RV6fflqjqXjqVmXM49In7Nr2+6rmRo
	 IipFUiCVraPB+xOwIhO9xmFBpz3UiNaj60i/EKidYKsWMB9Rn8XwUrITBI76jgPCED
	 LkKoCvgLgCgliN7z+mrwQtjx5uqwmsSZVNist0TQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	Andy Shevchenko <andy@kernel.org>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 586/589] string: add mem_is_zero() helper to check if memory area is all zeros
Date: Sat, 30 May 2026 18:07:47 +0200
Message-ID: <20260530160239.989962360@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit 3942bb49728ad9e1f94d953a88af169a8f5d8099 ]

Almost two thirds of the memchr_inv() usages check if the memory area is
all zeros, with no interest in where in the buffer the first non-zero
byte is located. Checking for !memchr_inv(s, 0, n) is also not very
intuitive or discoverable. Add an explicit mem_is_zero() helper for this
use case.

Reviewed-by: Kees Cook <kees@kernel.org>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240814100035.3100852-1-jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Stable-dep-of: 3e6ccd790ed6 ("gpio: cdev: check if uAPI v2 config attributes are correctly zeroed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/string.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/string.h b/include/linux/string.h
index 0cef345a6e87a..98b053d9c7005 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -170,6 +170,18 @@ static inline void memcpy_flushcache(void *dst, const void *src, size_t cnt)
 void *memchr_inv(const void *s, int c, size_t n);
 char *strreplace(char *s, char old, char new);
 
+/**
+ * mem_is_zero - Check if an area of memory is all 0's.
+ * @s: The memory area
+ * @n: The size of the area
+ *
+ * Return: True if the area of memory is all 0's.
+ */
+static inline bool mem_is_zero(const void *s, size_t n)
+{
+	return !memchr_inv(s, 0, n);
+}
+
 extern void kfree_const(const void *x);
 
 extern char *kstrdup(const char *s, gfp_t gfp) __malloc;
-- 
2.53.0



