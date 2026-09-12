Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC9B82ECD1D;
	Sat, 12 Sep 2026 14:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225145; cv=none; b=SPCSZfX9MTFdVTyvoH5302sMNT8f+ohpM6dgCohTxTxQt/Rb18MkSR0mjrw+/QvDncJ9VWreO1MsU9dBfT0g36oKd8dHg4DphM/OrqVU03cTl1dLlBWyJQ8XKnT/umbiIsR1xS9V2dCWw5HchMWYO8aJSUyh1CEv7cUrB7KuZxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225145; c=relaxed/simple;
	bh=ygg1EN5NgkowJpNfUw1LzXiJyepCGvFyw9C+LpSPoME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oob6UFhijuzhI6h2tl9+mQg3lMJYTSO1w1dCceB/9L0fCbNKu+3Z4pkc0bP9B/Gvn9wR5HaXiXTEE9P6Psm7JVe91fuN4zbKg1e2AR1B/9t02ekSM/2vi5nJ48bx5d6LT4s64zgvmhnpSwFEsrnK79r34FEaD7iCqyWjY1DJh7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sLE7h66D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sLE7h66D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B24D11F00893;
	Sat, 12 Sep 2026 14:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225144;
	bh=RFKx4ogig4RtYLXkWiRoBwUTL6rpGW+tEb7kRkIwEJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sLE7h66DwrpCYeoLbIVqglymjSMRrTsUUX2bv6Un7/e6bfbzNX+7bh1Liif/GJ5Sw
	 7GpJexji5MUeyiPNOa2nZarqsZrL5opD747NHbn/dN44j9odSWaGTsXN79g9Ax+hz0
	 wgdIgn+QNTIaJJ01F07j/YBwW2A0NmllzKCOczzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tanushree Shah <tshah@linux.ibm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1095/1424] perf trace-event: Fix buffer overflow in read_string()
Date: Sat, 12 Sep 2026 08:58:47 +0200
Message-ID: <20260912065631.828567825@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
index 1162c49b80825..72379cb8f5fd3 100644
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



