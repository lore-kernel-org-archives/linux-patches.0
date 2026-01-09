Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 110662EC54D;
	Fri,  9 Jan 2026 12:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961689; cv=none; b=TjwurSS24wnf5EFbpxOdnH8mOBV8m1cD6j9fk7l6Cso8ljvjlvviW7ISvI7UnCROPTR8HZ3l6FzN+GZQ+THdhVFa/IzDnHLtqzYTPNjkzmzqweGE8goIIU6kE3xMRU7PixBfhEp7F3LF/FIQbtuaz7RDrPh+enLIYtWFonKMj5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961689; c=relaxed/simple;
	bh=2HG0OP1NMjvVE2nV1M/lRza+jirvHLYj68ZV0hW87XU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qFf9wWKxbt1Q+QDnqmp3NYA5yfzKrUOD+irQIvHVEqr0LEo+agDyxE9hcKp1eTd3QfKwqwfSUgmQOXkaq9yCoFmHIvRaClcbgBMDJwtHDfbxW82vdEleZmbhSDaDbelT59xjZkmb+aRFZEcJdFe/RO+MZ3n6zIC9ufrk4O8BZbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VxvS+8Cr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VxvS+8Cr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44B7AC4CEF1;
	Fri,  9 Jan 2026 12:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961688;
	bh=2HG0OP1NMjvVE2nV1M/lRza+jirvHLYj68ZV0hW87XU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VxvS+8CrZypC+8tv6l+AHk+udSLh8OpSJ53xFeOVLGQt1PfUyDFv4X2R/TMconOfn
	 qbIBXrpxzxNRtaQt0SE87bGLdhoTJpyMHh9OUANhm/sFOLzbIUMz2/HUbSB4cGEUiu
	 QV/6Xo2shBnq1zLQFqP1gD7PmWsLnTnbtiL+Q4N0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 069/634] tools/nolibc/stdio: let perror work when NOLIBC_IGNORE_ERRNO is set
Date: Fri,  9 Jan 2026 12:35:47 +0100
Message-ID: <20260109112120.041542543@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit c485ca3aff2442adea4c08ceb5183e671ebed22a ]

There is no errno variable when NOLIBC_IGNORE_ERRNO is defined. As such,
simply print the message with "unknown error" rather than the integer
value of errno.

Fixes: acab7bcdb1bc ("tools/nolibc/stdio: add perror() to report the errno value")
Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/nolibc/stdio.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/include/nolibc/stdio.h b/tools/include/nolibc/stdio.h
index 96ac8afc5aeed..64dcdfbbe3d9c 100644
--- a/tools/include/nolibc/stdio.h
+++ b/tools/include/nolibc/stdio.h
@@ -300,7 +300,11 @@ int printf(const char *fmt, ...)
 static __attribute__((unused))
 void perror(const char *msg)
 {
+#ifdef NOLIBC_IGNORE_ERRNO
+	fprintf(stderr, "%s%sunknown error\n", (msg && *msg) ? msg : "", (msg && *msg) ? ": " : "");
+#else
 	fprintf(stderr, "%s%serrno=%d\n", (msg && *msg) ? msg : "", (msg && *msg) ? ": " : "", errno);
+#endif
 }
 
 /* make sure to include all global symbols */
-- 
2.51.0



