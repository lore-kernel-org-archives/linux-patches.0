Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B77E4915AE;
	Sat, 12 Sep 2026 19:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239758; cv=none; b=qXxqV6yx7FvwWkSrCIn9FJ4y7nfF10gvtftSgu4QL55NdywQd8EaJHbobPxOFBuaM1SXqj+OpE8hFEAByi5eeFmu+6fCTVG1uAUjmIQ/nvtxn1mBeQZvgkyunE6j+jooGjXprKFEFzAcgCn9PXGkPmYQIIP+mSp1HC+OhI9sB8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239758; c=relaxed/simple;
	bh=obOr630XbWwJeSJMjxLciFmUAwVUNsqCVqPwbtkVWzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O4dH9nNv2n6DLBCWor7vVi4n/LtInqDHwTQGm5+VdXZzMbCmOb/PTMtxJSk+VXG2KCUv3gacBBqTvGQjMRVBFGo/m8pHynVd9jS9l8MKxqy/EqPPD7sVxqxVqKNN+Bt/M9x9sz5c+X+vUa1Lj5U6l+YsFF03dP2RZgRby/BQoZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sjoQXt2N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sjoQXt2N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE57B1F000FF;
	Sat, 12 Sep 2026 19:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239756;
	bh=hR35La3Zrl40soTpnj0H/y82FjJIWckTNX4nM6dQZgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sjoQXt2NWtW76nWN29hYSxbgntZxuAhc9t9pMJZou9Ju/nlKPS1wZkm4fWY7KXCYo
	 MLBBQPNADYQ77SpdeZ79EPXyLmeTB3IozXqY1aDCQ3kisUWTj6rWkbctbU/laEhMQQ
	 9IZsY9IXjjW3sPGJRllFlEfA0+x4fbSwC35K6CFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tanushree Shah <tshah@linux.ibm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 730/935] perf trace-event: Fix buffer overflow in read_string()
Date: Sat, 12 Sep 2026 09:02:40 +0200
Message-ID: <20260912065543.576636462@linuxfoundation.org>
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
index 8a01af783310a..fd44de3cb873b 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -125,6 +125,11 @@ static char *read_string(void)
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



