Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB08042885F;
	Sat, 12 Sep 2026 12:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217442; cv=none; b=B3thwI7aT8fgLAH1q4tFnE8tBcAKPWbyf74lGneCy4CbbiKRGQpRGVDbtc6syewSudAUNQlayc0zq8aXNu5hz8ceIcziNyIdQsTmd8vveMBsgib95QFvARMd1ulYTuAxZ6p+pM7NeJbtgm8KALrvEd4PtGcT/Q9T7/lPiAdpYsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217442; c=relaxed/simple;
	bh=yiYgN7R2Y7S3FxNlBMAnPUp2yfOH9nr9wQWhrhpY84E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i99RMkNZE1I9kkbhkjeVV9DMqTuwbe44VNRZKbhBJshS0yHEUVhtZEcUSwGrPTVw3V29CzzThmT7gHQNHVSMss1zv2uWhv6diJICt3JzOKDt/aaN6jggnPE1ZxMwcVg3igDM3NCCS1+4a04c63wyLs9bUYOUuJipbKH6o62WN3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0yt8WMOY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0yt8WMOY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EC321F000FF;
	Sat, 12 Sep 2026 12:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217439;
	bh=JIvl/OJ1LRWX6Bs8ekr2qt8nmuSHEhu+k2ml+echUgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0yt8WMOYJNbPxjwg+0oL7+IcaZI4H+7j60Sf+xNPjVIJ8YEYGFY5qEmG2Zj7arHd1
	 dpjrso88QazkG/GBjrLQBpCKN0Vnv6ebhuDT0NimRi8LlSoCnj/6F7HEhJeD4O5ZK2
	 V/G4wOVEZT2m9qkNrMuYJaOQC1KMLGTu3HRy3D+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tanushree Shah <tshah@linux.ibm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0942/1376] perf trace-event: Fix buffer overflow in read_string()
Date: Sat, 12 Sep 2026 08:56:08 +0200
Message-ID: <20260912065628.554663344@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



