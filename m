Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888B9416853;
	Sat, 12 Sep 2026 08:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202275; cv=none; b=fwsHRXI82bLfP4Xmkhhl79m3NKzu7Wc6zz6Lnwifg6t4XVhEFmGLsORmoiVpz1nmoCLRImqeYHS3xm0OV2VxAe5fYzeR+oPkAFvgUsMEHygerOCdHNQ6m9CN3bOL3VFQvwZrOgT4OupaVNqxP2N2Thq+h2Ne4cURelCsSIiQFgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202275; c=relaxed/simple;
	bh=cnUC5UJVCTrxcBWtwOdcqMs93e/FT3cR0t0TQ136p/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s7BMGxhAmWDqJyPLNPp/IWZimXlfbYwl0V3oC2bN/EN63bULpf6xm95jMJ8Fo9wgC+R9LXX8rKGl5qC0ePadlxjUYnkyGH9gN+SQY3vgkyIbQ3DTnmvvbtW6OaqL16577Ix9vWucCah+CMkRWfMTrbtQ3FaB1LciyK/beBJ2c4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lgr67PkD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lgr67PkD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89C5C1F00893;
	Sat, 12 Sep 2026 08:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202273;
	bh=vsuwEi6vfJunECnyv/E4n+KWD+cCy9iLg4fpRrZeI/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lgr67PkD6Ng/0iyNGF79e0T+PT0zlF0di4DR0at5+BwhlmV/En2zfGieryeKa78pr
	 mrMUmpJM7M63d45hHlnORIwkWU5tUySGK6bK6P3POmsJURRrR0KRw2rjI9eEW+KcHp
	 xCrQMVSUDhs1uE4fOwNVMlSdDHu0BiQOGjdhFs3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tanushree Shah <tshah@linux.ibm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1169/1815] perf trace-event: Fix buffer overflow in read_string()
Date: Sat, 12 Sep 2026 08:48:39 +0200
Message-ID: <20260912065716.458057391@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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



