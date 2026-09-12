Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1412B456DEA;
	Sat, 12 Sep 2026 10:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210061; cv=none; b=FfyifOGTntCVkj8QZzWfYFMsxALBxiiIqCVwdKlDszyaz8JO9MmWbk6Q1WETQ8PcCiqnj4UGtpZg27kp19opk/1Fnr688sbq6M5NUpNXlLSTwxy65RGTdlOl93TsaRsP8I6s3M2fnfT+rfKOps67EG7ctX6dgtSNh7pmltaFlQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210061; c=relaxed/simple;
	bh=CzhkWyoP6P26j169zLjE+BJmwq3akT5a1dqiyO1oKLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b+rTIb0at+Q58wihP0vrjyMezHxVq7EaQOX+zUN8ptKdnMu4DN/3GuC8GJOPmBIKqwgMnHSVw8T7MFQcEQiSW0KneWPNewdUDksA0xZiNZc3r0P2Kl+nkwF2tO0yMme8WyvKZv2UfpJ8d8whSV9lH5bkmSrcu2pH7hzz227+qEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y/9waopO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y/9waopO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBE701F000FF;
	Sat, 12 Sep 2026 10:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210060;
	bh=BXPhmyZpDHPSHoujarW7P7Lf0lNnwR3rcuC0xBpppD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y/9waopOyEQ4Ovb1kkE+hjabfVVlmBVqkISaA3H502D1KcBsBCwdeMaEGwxqMky0F
	 4T1Upjl985fOXRgsMFXmF2vUInVuysd4loLwiudl5fd4MYBmT4LWwEdifAZKj6uUV2
	 M5eF6M8HZY6mLmANNQWyO7W58cts4W2Ulxwe8DSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tanushree Shah <tshah@linux.ibm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0948/1518] perf trace-event: Fix buffer overflow in read_string()
Date: Sat, 12 Sep 2026 08:51:57 +0200
Message-ID: <20260912065644.902553849@linuxfoundation.org>
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

From: Tanushree Shah <tshah@linux.ibm.com>

[ Upstream commit 1121a7af1833f8b5723f1e32685b461614353d5d ]

read_string() writes into buf[BUFSIZ] one byte at a time without
checking 'size' against the buffer bound before each write. A
string longer than BUFSIZ in the input overflows the stack buffer.

Add a bounds check before each write to prevent overflow. On
overflow the function returns NULL, matching its other error paths.

Fixes: 9215545e99d8 ("perf: Convert perf tracing data into a tracing_data event")
Signed-off-by: Tanushree Shah <tshah@linux.ibm.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/trace-event-read.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index ecbbb93f01853..afd458cf1387d 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -127,6 +127,11 @@ static char *read_string(void)
 			}
 		}
 
+		if (size >= (int)sizeof(buf) - 1) {
+			pr_debug("string too long (max %zu bytes)", sizeof(buf) - 1);
+			goto out;
+		}
+
 		buf[size++] = c;
 
 		if (!c)
-- 
2.53.0



