Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162473B8950;
	Tue, 21 Jul 2026 21:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669469; cv=none; b=eJ3dq3wIY+mGebuO2SIM2SaCo3SM2jf+sVrELVQYb+3K7HsxcMsWRNgQTPFH7A4cUO4WDMjNHwNFusQ1sXG1HvmlTKhReM7WiDIsfhXwDrUoUITTVWHLElRcNLu1KhFrSUu9HCdC2PMhKK+aH1c0J7khV7yLTkKZhXzHxDkxIbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669469; c=relaxed/simple;
	bh=Rt3Zqz2dP+5y2olJX8sbwov9YzdlZmzduqpz7tOVkCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VkKEgyI86hav0jTh3vUqKfivNFIXjoKzD7al+XH2Mjelk50beVuLJxk04kFSo2a3X2WqC6OhFGr8bD727OgLQteKZPPsrfenfFccpmlKYZBOaJkrkhvTjNXzkgIbnHQh5guU8wVKLhSMqoCHyB64sVkIP4s8pprXedsjJhCaXnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g5ZrMUwc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g5ZrMUwc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3870F1F000E9;
	Tue, 21 Jul 2026 21:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669467;
	bh=jWIRd4e9F3E1cq0lOxnFJDoIAVWvVF7xNvHlk3s2ffI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g5ZrMUwcvV9Ei2JLTCE4Fhr+5XJaD7s/WroaU3QmYeyJLEE5V3a9UtXOa5gU4KTmb
	 Y4RhVzbkJB1mz/T890zOhJD5PbaVAj9YFW0Y0HE3I7u/lRwwYf3gjCr6LChvzUnSYs
	 IIHCdq2Lxin3fFDBHq8+si8/r/nE4CYq6oxDlnm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Don Zickus <dzickus@redhat.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0523/1067] perf tools: Fix get_max_num() size_t underflow on empty sysfs file
Date: Tue, 21 Jul 2026 17:18:44 +0200
Message-ID: <20260721152436.310440495@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 370bc498b7a2e4..4a882d4e183f26 100644
--- a/tools/perf/util/cpumap.c
+++ b/tools/perf/util/cpumap.c
@@ -366,6 +366,12 @@ static int get_max_num(char *path, int *max)
 
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



