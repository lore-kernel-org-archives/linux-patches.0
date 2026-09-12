Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF723415F0E;
	Sat, 12 Sep 2026 10:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207507; cv=none; b=aQxCOIas0NM4m+V7m85ehLSkWlPkvjH9/Tl5H4S/oal8kXvCOrTbeJpAtkwVmLGv89SXBVrUsMM8Esk9XnbnbjAs1VGTK/44ayWMzLhYGvhC01gNfz0EjysBxxRu0liD6t/3B3s+vydHx+UxH2hu8RVnpc9vOVi/eVGfPw4W2yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207507; c=relaxed/simple;
	bh=wtsFEQR4/8iDNHBpmVBBecv5b23HJVpXRWlkMJ2tJG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pZsBQv3vtrth4BoBNySSqmZQSqh2fWw3ZwqUfraVGrhR4h5PGN6UErqHP1JqoSmOEfW6lmTywwTiLAmMhBjpzYNuqOUB3Je26zddGKM3Qo5xyJIdlY74M7Y4aqWSDY0SZt+T504M6mGRRI/ND7CIftbCTt9/wIwH5E6311gipi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ss0NXL4r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ss0NXL4r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 321991F000FF;
	Sat, 12 Sep 2026 10:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207505;
	bh=526sklgyZZvaCMlse8Dke1UOz6Koi5/muDoEGz1LKvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ss0NXL4r2IvUPhZ/fjJFFjnVIE/U19grHHbn36/419V+5o4eUTLpobpSRzfST74nJ
	 vaAD5tHknQ0gjdn4oFPKHIFolGOiSOO5TJh+SisULwijrGzx9vCzZCgR2BJAaQ6ASd
	 VKpKJdtKEq018FdISbGM3EQcEYyRFhv/lqZLYsg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0427/1518] gpu: host1x: Avoid stack over-read in debug output helpers
Date: Sat, 12 Sep 2026 08:43:16 +0200
Message-ID: <20260912065633.110372330@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikko Perttunen <mperttunen@nvidia.com>

[ Upstream commit bc17ac285fb708f22a8fa2c0ed32eceb1d37e6d6 ]

host1x_debug_output() and host1x_debug_cont() used vsnprintf(), which
returns the length the formatted string would have reached with an
unbounded buffer. That return value was passed straight to o->fn as
the number of bytes to emit.

This could cause a read past end of the output buffer if a call to
host1x_debug_* produced a string longer than 256 bytes. This only
affected the debugfs files as the printk debug sink ignores the
number of bytes. In practice, this is very unlikely to occur.

Fix by switching to vscnprintf(), which returns the number of bytes
actually written.

Fixes: 6236451d83a7 ("gpu: host1x: Add debug support")
Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://patch.msgid.link/20260609-b4-host1x-small-fixes-a-v1-4-7c1131c0b3ad@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/host1x/debug.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/host1x/debug.c b/drivers/gpu/host1x/debug.c
index 6433c00d5d7e0..b828f773fc065 100644
--- a/drivers/gpu/host1x/debug.c
+++ b/drivers/gpu/host1x/debug.c
@@ -31,7 +31,7 @@ void host1x_debug_output(struct output *o, const char *fmt, ...)
 	int len;
 
 	va_start(args, fmt);
-	len = vsnprintf(o->buf, sizeof(o->buf), fmt, args);
+	len = vscnprintf(o->buf, sizeof(o->buf), fmt, args);
 	va_end(args);
 
 	o->fn(o->ctx, o->buf, len, false);
@@ -43,7 +43,7 @@ void host1x_debug_cont(struct output *o, const char *fmt, ...)
 	int len;
 
 	va_start(args, fmt);
-	len = vsnprintf(o->buf, sizeof(o->buf), fmt, args);
+	len = vscnprintf(o->buf, sizeof(o->buf), fmt, args);
 	va_end(args);
 
 	o->fn(o->ctx, o->buf, len, true);
-- 
2.53.0



