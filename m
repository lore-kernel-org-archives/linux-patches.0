Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA69A463B8B;
	Wed, 30 Sep 2026 16:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784383; cv=none; b=HhRzSFKjSYgmmtaVrl4o2D4M4HEFolHnggOnGgWVEq/hIpvPtkHPO2eIH+Zui3A1pFI43olXNLXDOUnrOVER5atktDuMDCu8TyjZS7oIeiAuQW4dmNl8619kYU3PUUf1CxKJCeRGBj/JVHCe6EZDbFunfp11Ez5VneGgopn3BnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784383; c=relaxed/simple;
	bh=c450vveyCK86zi16emSCRmRohGLVW2gqMXtgj/xaNwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AVnHLkHrnqlYdy+tsdg1cXwN1pQwMN3mPAq4H5eJTDvzIOl+3KnbRwTFS6aP87Wkn9fcRKx1G3E/sLHWLJr7E12c5sTgdJtXg+Aej4xqb/CXovUayhVSI1ErHGafZQWITP4cThuitxnL5LQR71hMcXSIWxLDaJafTgRBV7kLBhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vD7XKHgd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vD7XKHgd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E905E1F00898;
	Wed, 30 Sep 2026 16:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784377;
	bh=NzCFeJL6ZeQPc2NnI7jN4OuED+p2/UPghGwZxW6KTiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vD7XKHgdv9hLr8OY835iTAjh1EYjZg4z1K5P/b5AhdD41J2JBUJ3yMJFbxTU7vf2D
	 RTqGfD1vaj5jtLVW4jJiAREpvKuFVGvpnEdz79X4XPG469K7ZZQpHXbJxmFGm3dM9K
	 4hetkzCkLkFvABY/41kDWGqUw4r+cFGqj+gniwfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Courbot <acourbot@nvidia.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 117/982] scripts: modpost: detect and report truncated buf_printf() output
Date: Wed, 30 Sep 2026 17:14:13 +0200
Message-ID: <20260930152419.332657001@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Alexandre Courbot <acourbot@nvidia.com>

[ Upstream commit d7231d8cb262b1e350c00271bf53d54414b4f3b1 ]

buf_printf() uses a fixed-size stack buffer. vsnprintf() returns the
number of bytes that *would* have been written to that buffer, which can
be larger than the size of said buffer if the formatted string is too
long.

The problem is that whenever this happens buf_printf() currently passes
this length, unchecked, to buf_write(), which silently reads past the
stack buffer and copies invalid data into the output buffer.

Fix this by detecting vsnprintf() failures and truncations before
appending to the output buffer, and report a fatal error instead of
producing corrupt symbol names.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
Link: https://patch.msgid.link/20260527-nova-exports-v2-1-06de4c556d55@nvidia.com
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/mod/modpost.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index b2388814fe976..990e514cd747d 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1861,8 +1861,17 @@ void __attribute__((format(printf, 2, 3))) buf_printf(struct buffer *buf,
 
 	va_start(ap, fmt);
 	len = vsnprintf(tmp, SZ, fmt, ap);
-	buf_write(buf, tmp, len);
 	va_end(ap);
+
+	if (len < 0) {
+		perror("vsnprintf failed");
+		exit(1);
+	}
+	if (len >= SZ)
+		fatal("buf_printf output truncated for string %s: %d bytes needed, %d available\n",
+		      tmp, len + 1, SZ);
+
+	buf_write(buf, tmp, len);
 }
 
 void buf_write(struct buffer *buf, const char *s, int len)
-- 
2.53.0



