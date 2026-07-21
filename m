Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E4332EBB8D;
	Tue, 21 Jul 2026 20:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666386; cv=none; b=tEDXgXI8IK8/DcqM6V/hSbLyGW1qTDaILFIubBBSN8np31KY67YdQ4HznzVhVR4vdB2JYnecYrzLkZK4RKyc7v4IvY2mI/sGEpSROPHMfefPuOIucrvtv3zmm3cSTJ3RNprvvsj3dR62afYy8YiRM9pWHLCHUPOSRlJDMnf10Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666386; c=relaxed/simple;
	bh=h6yRZeDTEkOAOHSbb/+z2jMptmkI+gvCfS5pux1uCcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X3rH0qfDbRmCW/zfa3vhbLiz9d+o7xVWaj/FS9eYgqE2r+YK/6912F1IrBKe4+xyziuKr06JqM4fTDjVoZ+aqz6DDSj/aocRYA5Wl9BDQ02yrI3WLq9rVxcaPmnCwTME2GAntGnKBTkU88pdgnpVWaLbdkvV0pMJREJUophz8r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fj8HOlhI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fj8HOlhI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D29131F000E9;
	Tue, 21 Jul 2026 20:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666385;
	bh=erYHab/QfNn8LheXb3pdrZHF8WDcYJ45E6vdHDpw/Nw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fj8HOlhIFysZGCpj7HPdU0Arpijqi881mGGljJnGxy0tKroKK4CXfT4LLbs+ZffX2
	 xKrJZoM3sJPqijaOLxhUMrbXz8an3BgeE6iadJIK6YGXtX06Lj3151rdnXi+8tQ+eO
	 g5n1FXDChJarxNzDN+wj952EpDUYWGcDDSGComgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Don Zickus <dzickus@redhat.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0663/1266] perf tools: Fix get_max_num() size_t underflow on empty sysfs file
Date: Tue, 21 Jul 2026 17:18:20 +0200
Message-ID: <20260721152456.695379804@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 0a012113bb3a44482c163f16f4db03ccaa37a339 ]

get_max_num() reads a sysfs file (cpu/possible, cpu/present, or
node/possible) and scans backward from the end to find the last
number.  If the file is empty, filename__read_str() returns num == 0.
The loop `while (--num)` decrements the size_t from 0 to SIZE_MAX,
reading backward across the heap until a comma or hyphen is found
or unmapped memory is hit.

Add an early return for empty files before the backward scan.

Fixes: 7780c25bae59fd04 ("perf tools: Allow ability to map cpus to nodes easily")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Ian Rogers <irogers@google.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/cpumap.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/perf/util/cpumap.c b/tools/perf/util/cpumap.c
index 75d9f5d6d185d1..de4a710e242146 100644
--- a/tools/perf/util/cpumap.c
+++ b/tools/perf/util/cpumap.c
@@ -378,6 +378,12 @@ static int get_max_num(char *path, int *max)
 
 	buf[num] = '\0';
 
+	/* empty file — nothing to parse */
+	if (num == 0) {
+		err = -1;
+		goto out;
+	}
+
 	/* start on the right, to find highest node num */
 	while (--num) {
 		if ((buf[num] == ',') || (buf[num] == '-')) {
-- 
2.53.0



