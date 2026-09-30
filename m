Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 369F04F68A7;
	Wed, 30 Sep 2026 15:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782544; cv=none; b=d7ukUAMIv4RTLCDwNrh3xg/R6R1H6tC/h2aEdCns+M0Pzse77CPZK9uOu+Y40k4hPdufp6+YmonN4tb5TWtU9KQCuICAJhEVhctUHP1YtjdWfRjWd9KkTBWYeItpffTAPd1h9VAr4hq2nkMqnfltj/1aqf9RIAyr30mNBQ5DKpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782544; c=relaxed/simple;
	bh=cu/hx0ITGlvCXySP4brIxBCDkXyyvYtWOhE3XdW387o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e8KVUmP75bdusr7CioxulV/+6+uuw0R5Nd+GqETjqL9YzdjEsWCWNHeB5VBp0V1GK0jbE4ykrd+yyOQw6y5zsN1lOnerMk1AdFA63HrBi78Mn7QtU6OqgcOtSQFfJV3NBlRyvqQsxCmMIkI/8YucWvthehRd/Geb3twrgxjsQoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DCl1/w1c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DCl1/w1c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 244B61F0089B;
	Wed, 30 Sep 2026 15:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782541;
	bh=BccRhgv1C+bX41hVJlPQT/Lcg1JWbMYk2+oIx2H0mFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DCl1/w1cvPrDCJZ0X0kFV8Wo96vTFo3f4n2VKlheDYq+XLWmORH0Xa/c2uHrA0dG/
	 TOj/sWSuWBsDPC71lBNKVyxdqhrUQXyNJROwBm6Ok0hanhkitvNjUUXvxcX7K/Oh25
	 GBbSi86QIsnR+PoRMEJ/oy3AHfRXrph40Pf4M9o0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Courbot <acourbot@nvidia.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 083/595] scripts: modpost: detect and report truncated buf_printf() output
Date: Wed, 30 Sep 2026 17:19:36 +0200
Message-ID: <20260930152349.524212880@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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
index 379d03d0c5e6d..f5c166bf20fdd 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -2146,8 +2146,17 @@ void __attribute__((format(printf, 2, 3))) buf_printf(struct buffer *buf,
 
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



