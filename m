Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E81D132FA3D;
	Fri,  9 Jan 2026 11:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959579; cv=none; b=QYWr2XDGrgdWQgDdFdMm0JYOF8yiDNVBHFPG2ffCKrJCfbxf9FVKXma+ACIvZnOBdGJPBlVq5vPZ13sbpiBk/3dR6okK5ogSmpZ3SrK4kVrPbm6DWFQ3nsR5KskKZOfa45WJBh+DgaOcyofy6K8D/z8fL33cfaGm1vm650rLKKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959579; c=relaxed/simple;
	bh=svqDqcR1YIhSJGO2/morTMh1X5ZqN2NUwKHximS5obU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JbTftn9z4XwmU6JJkPpxadMecn2OBIB8Ne0W4H+rGwW0QlRmFICBpDp2Ft4hQmSKTWthLdWq3fQd2/h/NlwaObjMqRNbkR0a91Ze8+wP+aNFskuYEfyw0yON2Os3f/G37FCJPG5pz3tiICrf4p3lG1JaAwSGnz+Rk/tuMds2fu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VNzYKeDJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VNzYKeDJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74643C16AAE;
	Fri,  9 Jan 2026 11:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959578;
	bh=svqDqcR1YIhSJGO2/morTMh1X5ZqN2NUwKHximS5obU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VNzYKeDJaDajx3SjqCE9RW417FSxemn7mSR68JthwuXL6yVt75/EGA6aTsG543Ilj
	 MzU3S3u5b7DJghid3tXzYN9k+u+KZToEtVBvx2BoIT+ib/JqHVHPNg+3xbpLOQTyoO
	 HO0PQHmhIq+7WT9Py8lngaWAwQtVOO2Er3b5hwsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 100/737] tools/nolibc/stdio: let perror work when NOLIBC_IGNORE_ERRNO is set
Date: Fri,  9 Jan 2026 12:33:59 +0100
Message-ID: <20260109112137.764454257@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index cae402c11e575..36952314eef6f 100644
--- a/tools/include/nolibc/stdio.h
+++ b/tools/include/nolibc/stdio.h
@@ -352,7 +352,11 @@ int printf(const char *fmt, ...)
 static __attribute__((unused))
 void perror(const char *msg)
 {
+#ifdef NOLIBC_IGNORE_ERRNO
+	fprintf(stderr, "%s%sunknown error\n", (msg && *msg) ? msg : "", (msg && *msg) ? ": " : "");
+#else
 	fprintf(stderr, "%s%serrno=%d\n", (msg && *msg) ? msg : "", (msg && *msg) ? ": " : "", errno);
+#endif
 }
 
 static __attribute__((unused))
-- 
2.51.0



