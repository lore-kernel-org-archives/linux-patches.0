Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB1403D3CEF;
	Wed, 30 Sep 2026 18:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794223; cv=none; b=cT23GVg1dD8DYRCu81s9IoPr8racgQ6TYWzNjm2x0fNck+pPaM9altXPqLiSP3rdqWVYTN0qCqlONSoHcZm5SFOgfI+G+QENVBqQ703jbKJrcDOyI5Puu8og3osgn0r4ey6UhMYOcMCLpO2dJrxbKEhKNVERKsiPfP7x2A2oZGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794223; c=relaxed/simple;
	bh=GXwGAoRd0yij8qzDYe20L9m/R5wycLa6JQZmz0BsWBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jSVUuuRXQUUmKN9dWSYyLejteJFdvPRiXPwKM6IxzGbO6nUsiEEcf5r2MlyXqt3Rmgh13UAa4/j/Wfc8p5hhI7Wf5d/Zuv3fnJzBh7TWx01mtLRehByE/Dp4j+VSrw0K4/rKpo9mEEfifBddz0zdCP++tap04J6Bs26lz+xJ+0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WujEiCSA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WujEiCSA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA9F1F000FF;
	Wed, 30 Sep 2026 18:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794222;
	bh=iG+6VJzzHZ6qsvnMyIYK3t/MSjRoFi9bYeIUbLmnfrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WujEiCSArv2qOYXa9i5tsRt04UAf9KFhUATRq50+rk16hjb6CEUVO+D441rIfJtrq
	 LlOMd2swqIuIXzcSBt4s5D09n/lPVnj9ZHY94qFog6wngusxP+Jl77rrDZwQ72zv+o
	 mjOD+vuS9/OAHc2xrV0ENAzVVN/Dad6hH9RfQVUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Courbot <acourbot@nvidia.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0134/1193] scripts: modpost: detect and report truncated buf_printf() output
Date: Wed, 30 Sep 2026 17:13:38 +0200
Message-ID: <20260930152437.188908119@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index cfcf2c1bb5ece..41e40c9d3108d 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1730,8 +1730,17 @@ void __attribute__((format(printf, 2, 3))) buf_printf(struct buffer *buf,
 
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



