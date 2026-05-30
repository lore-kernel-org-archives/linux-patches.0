Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39911362157;
	Sat, 30 May 2026 17:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162583; cv=none; b=LuMxkuEwvQKRaIxnbOtuBXtxTbyejp94Ueca8uSkfl1vfaGs0mdqzpOpcZNp20xDyk7/Uz+NiXcdmborX+Iw34ZPs24CQCOWIaB3MZdWP3bce3auEwcXnUHqA1x2QWK7Eflv1JdiWmXqn4spOr0Vl5cXXk+Z4kiCNAxWDlGrNqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162583; c=relaxed/simple;
	bh=HxW+vLvlQPap0LNFvPt5agITtc5h6Aqau/SjqEP1rQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fMqMTGkOwdefOKaejPAtgo+a2aWgXo/3iWPBEo7P9ep1zYZJd2E6puNWgYG+q0MUZr/znUI8VuN1fqrFgkVmhj7LcL0lzmOCEPXVwPWR5mzzcy4RNLLyb6UmeSGTwZVZOzhsK1JxolCQuG6vLS+xQbWz02zpXP2tlVM12MsM6dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u8VoO7vx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u8VoO7vx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D0FA1F00898;
	Sat, 30 May 2026 17:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162580;
	bh=YT67YPcAHqJc0XRgh/MgCp+orC08vt6Z0wMo0xmVDPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u8VoO7vxU8bXzWvdZUlis+YOS4GLTjuqsJxO2dnMwJCVx6pB8nBpRHfkZcRuZE8aC
	 KMMzDqUpWQEAqcUBIYjRNx8KCsZDqy1dh8E7RUVCAEGSSg9Vjn7xB/8qmuEbUSiB4j
	 IwUB+N3srXP2uOjq6k1vNJEOcnYO4An82E4i1xeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	Andy Shevchenko <andy@kernel.org>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 965/969] string: add mem_is_zero() helper to check if memory area is all zeros
Date: Sat, 30 May 2026 18:08:09 +0200
Message-ID: <20260530160327.422923242@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e7ade5223d422..356b941d1ddac 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -212,6 +212,18 @@ static inline void memcpy_flushcache(void *dst, const void *src, size_t cnt)
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



