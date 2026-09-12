Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03EB1288B9;
	Sat, 12 Sep 2026 16:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231001; cv=none; b=LahyC/Zfej02At0lTIoP6OLy3N+fhbcoBA+woQgAkHXXOfwv4Qz3EGibfps1hW3pvJ4IvlhLCFSjIYJS2ZG0QS+ij++j5bA+vWiOs6fVnVoB0Y9mqy5fKEy6PfiqL7DisIliXAC9gdVRgCDMt5HsV2eY/MvZKn0BahCDKhrqJno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231001; c=relaxed/simple;
	bh=LELzi6GuKcwPozkEAAiwvd6xtI/thcrhDmNmM4ezB/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HbwGeLhSAVV33IcWTaz66C5XImewghqeNQitbkEfS1X7yzC4OKj7v0Qk9hNC6uCVcHmnuN/jVf6oyyB4eqoVKpT2HaprGZzDrZNKH4F/FtJ6K338Ie+O6OVKCymC+EClza6qBs9C9JVaCvHetCc7k1B+KMpB708aatDkf4JalZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qGfAQxt9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qGfAQxt9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9EA51F000FF;
	Sat, 12 Sep 2026 16:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230999;
	bh=LcTRJ7W0kPoMCZ4SwD/XCBe1GGOk+QKxeEixHvoEL2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qGfAQxt9kTlID1ru+GEEscHLghMaDRtugq8keMj2vs6g/pj2l19TfvQRYLdwOD2cI
	 hXLriveeP6f6mbcWHEc4kGiSlpd85b1gv10kDvw17q/QqXgUZAaVi3ati/umQ0/U6S
	 vVlXgc3TniRaxXz3gnq5Gpyyq+YNgGLEb2izToWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tanushree Shah <tshah@linux.ibm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0908/1191] perf trace-event: Fix buffer overflow in read_string()
Date: Sat, 12 Sep 2026 09:00:36 +0200
Message-ID: <20260912065608.627107180@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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



