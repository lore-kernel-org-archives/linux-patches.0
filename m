Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FFA1347FE1;
	Tue, 16 Dec 2025 11:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885387; cv=none; b=VufewVqiEc73wVlJMy3bGqCs6CARyVdHf5r//dI6gR+BBsej3q3xV4fQ3NlaFcDKu2GZ3Oax5E7ghUahtMhlHb4jMpup+bJ00O/hd94JSZiTirvI7km+fdsmfafOiMDl4wa2L46W9/Yy1HHVYJ671Axe+9VrQhSRt25DC/xOfvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885387; c=relaxed/simple;
	bh=44r30ZvOVnJR1qoDfDh+lGUahtu0Ap4Qqn+SaBgBN8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r+0eEub8qtNJ7RbxajsuxglNX1Aw69iIpDQi6UyK576QF7sp6VKazqm5D2GuNlKAlCSAqHalrbfqPYOYZ+UJaWTBPVj/HnANP+oEBQJ5B9T7LRDoXoqvCB/eQWZb+/2HRB4zORhmpXcTzckPD6FPyED0Yanf11Aq8VVN1bOkyHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XzWdocbK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XzWdocbK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20F15C4CEF5;
	Tue, 16 Dec 2025 11:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885387;
	bh=44r30ZvOVnJR1qoDfDh+lGUahtu0Ap4Qqn+SaBgBN8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XzWdocbKF5703hsCqA0BUqyTVnaAljhrvZHDT9zncj+NO9zLoRhP9vNPdKzYCg142
	 2tYoBtbMYIJA0pPLdn8qgBpmvIAZrQKbHVnlFYDVynwgqyqW0d5+aL+RpTTUjF/Ze8
	 TBV9oYWY4OipBygO6PuELroMbW8K+595/qzd7Qgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 124/507] tools/nolibc/stdio: let perror work when NOLIBC_IGNORE_ERRNO is set
Date: Tue, 16 Dec 2025 12:09:25 +0100
Message-ID: <20251216111350.024474258@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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



