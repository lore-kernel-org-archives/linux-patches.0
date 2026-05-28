Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC5034F483;
	Thu, 28 May 2026 20:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001583; cv=none; b=eI3qIrQ2NoylubJtSXhs/UvFf3xn8DjAg5p5LA5qAjGdUJDwHn3IDfHlQ28Hg7uq1E9Ht5FBfiv0a8zlrnvYmZlKAOzIRrzeNTbBZnkHAsqs1yDqXPu+Dh1kunSQ7hXzn3TjWIqamnE44h3I31gWyW91SrWmAiJgHn0rEGNgVnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001583; c=relaxed/simple;
	bh=PHPOJOq08XWNjM8QzN5pZd3KGPxNMv5ZFNl/ExylTgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vAKEUNApu0+DCF0GF64yCBKhXEPPUEh5DVpjM+du00fVJk8g/a3Rly8coMN9NMiW2wK9HUww/iH1ZNoyaCOu9yRgbUtZYtOQOVsK+/tw245Nx/MAcqOhSwhCRIq8J/KS1idel3DltuUROgOgTuoZ7CIfW8Lw9NSirmYwePmyfTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bGx4FwSh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bGx4FwSh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1DDF1F000E9;
	Thu, 28 May 2026 20:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001582;
	bh=60Ie6kAZsZ9daF94hguqaF5Vzv397WX6pTwtRvsGw7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bGx4FwSh7fI5LdmliqoLyZpvNU0VrPextKznjNkbOln2blZ37nIG/5YN4gDi8zZpo
	 MqQuQjgBECKBDYYt8Rpvzr2aXhodIOJBzp1YYyu0qBnrJ4UDe6btV2+OmCM8qfKboF
	 xYrl1LrErGutAmsQWLAY2vmgl0qrZ3EyJUqhuWfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	Andy Shevchenko <andy@kernel.org>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 178/186] string: add mem_is_zero() helper to check if memory area is all zeros
Date: Thu, 28 May 2026 21:50:58 +0200
Message-ID: <20260528194933.793615204@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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
index ce137830a0b99..bbcaceb8fb6f5 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -212,6 +212,18 @@ static inline void memcpy_flushcache(void *dst, const void *src, size_t cnt)
 void *memchr_inv(const void *s, int c, size_t n);
 char *strreplace(char *str, char old, char new);
 
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



