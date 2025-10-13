Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0BE92FB978;
	Mon, 13 Oct 2025 15:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368961; cv=none; b=raIkpjDjkBIFuDls22S3AHUzA9cn8FUkVHgkMnTesGWPk7Z9tGwWJiJ2Y3u4ANq1hAvHpeV8irIwdE859zFg2YLLEmx0MY2lTQQcVsi+s4JmdkdkCvh+dCF1RkpSRDK7SEtzzxN2u4lKe26AAqkYPMfqpFUMCzOdmN5b/e1FIOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368961; c=relaxed/simple;
	bh=wBeZAVmiSaRD6DYB0mC5zn3w95yzJPpJtSLIqJeQou0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JK+zYJtxSTc3DmeV0LndQ1m9kLFLUGl7dE2m7tlQdAiTeWvxiCBTUmBtCZ4bMRhijs9tDgCUQUnY71vVb4DXnRkz67Rt0XXjHyBdrFELrwxPFf9Zax0FIj0P6fT4igY0pJ+bhaBI5EGQaSnH7bj4b0W9ssW2rXvcHJOqlZmXvt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IjAQtTnV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IjAQtTnV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BA63C116B1;
	Mon, 13 Oct 2025 15:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368961;
	bh=wBeZAVmiSaRD6DYB0mC5zn3w95yzJPpJtSLIqJeQou0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IjAQtTnV33JElFr11FDNjniZTEUcR8j7RgqE8nFWFzHT8lbtkx2BRURdpnudAxNjA
	 Zb3W89cq67BGTw/Bs0742WQYZi0tWXgaZdPNrlb7uF3qT9ukzLMP3zKebAV1hzqCMj
	 8tFTmCbCPDnWWqywv2Mbnum//HJWw9ulVgNGWgm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Willy Tarreau <w@1wt.eu>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 079/563] tools/nolibc: avoid error in dup2() if old fd equals new fd
Date: Mon, 13 Oct 2025 16:39:00 +0200
Message-ID: <20251013144414.152157352@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit d1ff0e2d13d6ac3a15be7870e15216726b0a809a ]

dup2() allows both 'old' and 'new' to have the same value, which dup3()
does not. If libc dup2() is implemented through the dup3() system call,
then it would incorrectly fail in this case.

Avoid the error by handling old == new explicitly.

Fixes: 30ca20517ac1 ("tools headers: Move the nolibc header from rcutorture to tools/include/nolibc/")
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Acked-by: Willy Tarreau <w@1wt.eu>
Link: https://lore.kernel.org/r/20250820-nolibc-dup2-einval-v2-1-807185a45c56@linutronix.de
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/nolibc/sys.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/tools/include/nolibc/sys.h b/tools/include/nolibc/sys.h
index 295e71d34abad..90aadad31f6cb 100644
--- a/tools/include/nolibc/sys.h
+++ b/tools/include/nolibc/sys.h
@@ -238,6 +238,19 @@ static __attribute__((unused))
 int sys_dup2(int old, int new)
 {
 #if defined(__NR_dup3)
+	int ret, nr_fcntl;
+
+#ifdef __NR_fcntl64
+	nr_fcntl = __NR_fcntl64;
+#else
+	nr_fcntl = __NR_fcntl;
+#endif
+
+	if (old == new) {
+		ret = my_syscall2(nr_fcntl, old, F_GETFD);
+		return ret < 0 ? ret : old;
+	}
+
 	return my_syscall3(__NR_dup3, old, new, 0);
 #elif defined(__NR_dup2)
 	return my_syscall2(__NR_dup2, old, new);
-- 
2.51.0



