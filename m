Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C042951815C;
	Wed, 30 Sep 2026 17:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788138; cv=none; b=Qa0k5oMLBns7Tc4J1soqxr6/OS6OR7jwJ0cKksbdlsJ6MdIwvysL+ZCqQPRdpHd8aiDOaSTsM7IccEwWOgWVGpZ6wZ8I4xZI7JQnqMkhfgsyCX29NCn7JtRfnXSY+6fILk7tE9uBowhtzigPwm3rAA8Ovo3WjNjJHSv+Be6pGqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788138; c=relaxed/simple;
	bh=ZySdX+NbxVcE4WgBVcIH1Qq1cLNmulO2+0j4p0v+iqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kClj0fMwT5D+x4xrq1KgaQ9NO6REo4c8c+SjvVACiRZAJQmBn9jK5yqc0eCnUCu0c9Zl8X4M1c8eeCEJA3cSt2qMkHYAunkj+LZ4gLK98yt4pMEuaJFVpZNwR2iDWX/8ZmhYIvD8HSkHi+cyVFz3EPFze1cGMwpZnhiepPmExpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S6yTaDVR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S6yTaDVR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E9FD1F000FF;
	Wed, 30 Sep 2026 17:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788137;
	bh=DIB57U6hDmfNAhxfN30F4o5tggp0uIPf9aqvbXq/2FE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S6yTaDVRiz9Zz+jPEH6o6VlEwZcRi58vemuHl9QFUkXwD7lq6ZzZHEe4Gqjlzeqjc
	 WsaJVY8oI68N7H73Cj/j4XulzIh0HhMTvLBC6OcqcnYshi45QuH0CUfAQUXHWrLyy0
	 dDuAbU5uoA5WaohQAeX8WwNXg7J5kl4Epwz8dR1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasily Gorbik <gor@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 008/877] s390/boot: Add sized_strscpy() to enable strscpy() usage
Date: Wed, 30 Sep 2026 17:15:19 +0200
Message-ID: <20260930152414.925723629@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasily Gorbik <gor@linux.ibm.com>

[ Upstream commit f271df9d41c216f6189c40fa1cb83839a6117c3e ]

Add a simple sized_strscpy() implementation to allow the use of strscpy()
in the decompressor.

Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/boot/string.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/s390/boot/string.c b/arch/s390/boot/string.c
index f6b9b1df48a82..bd68161434a60 100644
--- a/arch/s390/boot/string.c
+++ b/arch/s390/boot/string.c
@@ -29,6 +29,18 @@ int strncmp(const char *cs, const char *ct, size_t count)
 	return 0;
 }
 
+ssize_t sized_strscpy(char *dst, const char *src, size_t count)
+{
+	size_t len;
+
+	if (count == 0)
+		return -E2BIG;
+	len = strnlen(src, count - 1);
+	memcpy(dst, src, len);
+	dst[len] = '\0';
+	return src[len] ? -E2BIG : len;
+}
+
 void *memset64(uint64_t *s, uint64_t v, size_t count)
 {
 	uint64_t *xs = s;
-- 
2.53.0



