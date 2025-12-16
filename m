Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1B1749C;
	Tue, 16 Dec 2025 12:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887162; cv=none; b=IDk4n0bSMWfeQbzuFwZ50z9SHL0iNDdZOkyg81M6Wud0xgZ9m+ypCQJvE2qeCEQ9QbOZ5C2VtGXDq0G39lDGmGBPj6KROqQ76tTjv6xgMK+85/pQZpl+RP+JgUUA963hcOdlqvwuczWaWJHiJKwyZNZfxmPEXpMDvs6r52Wsy1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887162; c=relaxed/simple;
	bh=VbuXpVj3HEpUWASaDzAOnx1QLsum+nVR8LJjgR0GQ3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rwZwkpedC+2d9T7nXOmE61Y4LSqlYepA2KxP6y0sGdpMg4k3qmiNRcf0OI4Sc+BqLt3pV/Jj4aQeol61GJ11P9Xo5OoC1XIAqmZe69Oa8RuaPE+82uMSX2ucSevd1FbmbU9IRKy/ubnLB7sxQ0ntd1vnA1gVtNBLIBOQD/KGoJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DmOfwOMk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DmOfwOMk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD2BFC4CEF1;
	Tue, 16 Dec 2025 12:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887162;
	bh=VbuXpVj3HEpUWASaDzAOnx1QLsum+nVR8LJjgR0GQ3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DmOfwOMkC8oSE4tY8/YX25v9BLs1VXVzPGm5X6sAQmJCwnkWn2Sql9OYGOzdaCVqC
	 bFW3uytntSuZ5KU2wdC83Dx6a5uvzZONhWyK2wXMrtqiLD4JatAIzb6r6ZNIEXJRGh
	 sK63MB2XnsOLNp0EkzT5/xRcwZCRsOLHaae5dD5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 146/614] tools/nolibc/stdio: let perror work when NOLIBC_IGNORE_ERRNO is set
Date: Tue, 16 Dec 2025 12:08:33 +0100
Message-ID: <20251216111406.627950713@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 7630234408c58..724d05ce69624 100644
--- a/tools/include/nolibc/stdio.h
+++ b/tools/include/nolibc/stdio.h
@@ -600,7 +600,11 @@ int sscanf(const char *str, const char *format, ...)
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



