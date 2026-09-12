Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9FA1F4F1;
	Sat, 12 Sep 2026 18:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238804; cv=none; b=CZia3GujBkssGyr6Qmb9IuJKj3zownUOKOfbUb8NS3VOhQZbr/FefPLm3qOweSD4CGxEw3dwe2WyycYDlPNzAIPj00PB23pbNB4EO2qjatFeW7EOZWjIUZ+pB+LT8Ifual8G7bhET/ZtKLRFg1HI3QmUnhOKZlsN6pyUd+ZfGwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238804; c=relaxed/simple;
	bh=98bB6iOHlW8jGyzRqIAMwUPkJM7YmwImy90FRTajt6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dcV0hwsJxs4CdmWoT0MW2SKw3MY7fizyJyk43iqeatFtr+N72oqkoBdWn9SES/Ta1yI2JXGDpD/WMIhoFnto1U7l5RwZth38KoebXXutk21WRsVotfP/DZGuJuztz9AFrrQcpzVSJFF6hxifmOpd4DBNwhPY7PycSBVAWhjcrns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AhwVDFvD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AhwVDFvD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D948D1F000FF;
	Sat, 12 Sep 2026 18:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238802;
	bh=/aHr4UKrRuWR1hsO4BSfWPSqEf8N0CbfxLGkifketh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AhwVDFvDI4SV61CPi7+d+LPysRq+7fodozG+UpArnLZNZKhdyFuR14Qk2XIWODdrL
	 6RoSreye72OyK7q2XxYyGIR6MIGSZAR+gBB7DISkjn3lrfFC1Oe0kgY1yH64EiIzhi
	 yL0tGasfqvIxsHyO209b++FNqhKYW7WceH6tuHdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 534/935] gpu: host1x: Avoid stack over-read in debug output helpers
Date: Sat, 12 Sep 2026 08:59:24 +0200
Message-ID: <20260912065539.068575644@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8a14880c61bbd..d3001229be270 100644
--- a/drivers/gpu/host1x/debug.c
+++ b/drivers/gpu/host1x/debug.c
@@ -30,7 +30,7 @@ void host1x_debug_output(struct output *o, const char *fmt, ...)
 	int len;
 
 	va_start(args, fmt);
-	len = vsnprintf(o->buf, sizeof(o->buf), fmt, args);
+	len = vscnprintf(o->buf, sizeof(o->buf), fmt, args);
 	va_end(args);
 
 	o->fn(o->ctx, o->buf, len, false);
@@ -42,7 +42,7 @@ void host1x_debug_cont(struct output *o, const char *fmt, ...)
 	int len;
 
 	va_start(args, fmt);
-	len = vsnprintf(o->buf, sizeof(o->buf), fmt, args);
+	len = vscnprintf(o->buf, sizeof(o->buf), fmt, args);
 	va_end(args);
 
 	o->fn(o->ctx, o->buf, len, true);
-- 
2.53.0



