Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E325C6D1A1;
	Tue, 14 May 2024 11:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685235; cv=none; b=YcYFH86Q8b51rSGNEA1gXnug7++YTE4v71DHkI/Vv6Yn1FUs9Erh91ZRjwkDhCmIa16gSOJB/jtXFnNUXQ/b9JFMPcZoNGCo8y9n7JFeU5OtZwyuN8rkCTs1oESGu3APmaQDiiLpFJU/N1x5wbJ6fCrKow8pYmkRM59mc9uJ/k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685235; c=relaxed/simple;
	bh=hu+b8m8k09YP0v1+5RfhKamhyWegKKK1EcZTkQFFzKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KqI5jf2XlYlPoNVgPNo9HwrxuD+ivYD1Yu+V9g6AYQufZzNmRERINdmU9p8E3Vty3TDAb1CZrswye5fcvsSBJVBElFM7ZoNbc3CLW/FD7V7Ufa5ascpQaJu6c/qYgj/1zxA3t6iZBZhuhxkk3Qd9Y0aWghGSatwNX/8XCwqtA0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B+I3iDYJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B+I3iDYJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB4F4C2BD10;
	Tue, 14 May 2024 11:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685234;
	bh=hu+b8m8k09YP0v1+5RfhKamhyWegKKK1EcZTkQFFzKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B+I3iDYJOqrrcreqky8uWxq3/4V5T5OmfRHciKuEnHiU7U5fffXrJJz4V9I+GD86X
	 wcTDedYxnRrPagCP4NLzTx41894rlFXwFsiiYXSv8kYv3SXLwZB1+htDvcueiUijcN
	 ALH0Ceb1smqIsU2ijkKxpigugunUlVTgJ1EDsL4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Smythies <dsmythies@telus.net>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 129/301] tools/power turbostat: Fix added raw MSR output
Date: Tue, 14 May 2024 12:16:40 +0200
Message-ID: <20240514101037.118542562@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Doug Smythies <dsmythies@telus.net>

[ Upstream commit e5f4e68eed85fa8495d78cd966eecc2b27bb9e53 ]

When using --Summary mode, added MSRs in raw mode always
print zeros. Print the actual register contents.

Example, with patch:

note the added column:
--add msr0x64f,u32,package,raw,REASON

Where:

0x64F is MSR_CORE_PERF_LIMIT_REASONS

Busy%   Bzy_MHz PkgTmp  PkgWatt CorWatt     REASON
0.00    4800    35      1.42    0.76    0x00000000
0.00    4801    34      1.42    0.76    0x00000000
80.08   4531    66      108.17  107.52  0x08000000
98.69   4530    66      133.21  132.54  0x08000000
99.28   4505    66      128.26  127.60  0x0c000400
99.65   4486    68      124.91  124.25  0x0c000400
99.63   4483    68      124.90  124.25  0x0c000400
79.34   4481    41      99.80   99.13   0x0c000000
0.00    4801    41      1.40    0.73    0x0c000000

Where, for the test processor (i5-10600K):

PKG Limit #1: 125.000 Watts, 8.000000 sec
MSR bit 26 = log; bit 10 = status

PKG Limit #2: 136.000 Watts, 0.002441 sec
MSR bit 27 = log; bit 11 = status

Example, without patch:

Busy%   Bzy_MHz PkgTmp  PkgWatt CorWatt     REASON
0.01    4800    35      1.43    0.77    0x00000000
0.00    4801    35      1.39    0.73    0x00000000
83.49   4531    66      112.71  112.06  0x00000000
98.69   4530    68      133.35  132.69  0x00000000
99.31   4500    67      127.96  127.30  0x00000000
99.63   4483    69      124.91  124.25  0x00000000
99.61   4481    69      124.90  124.25  0x00000000
99.61   4481    71      124.92  124.25  0x00000000
59.35   4479    42      75.03   74.37   0x00000000
0.00    4800    42      1.39    0.73    0x00000000
0.00    4801    42      1.42    0.76    0x00000000

c000000

[lenb: simplified patch to apply only to package scope]

Signed-off-by: Doug Smythies <dsmythies@telus.net>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 785de89077de0..9602a4798f383 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -1811,9 +1811,10 @@ int sum_counters(struct thread_data *t, struct core_data *c, struct pkg_data *p)
 	average.packages.rapl_dram_perf_status += p->rapl_dram_perf_status;
 
 	for (i = 0, mp = sys.pp; mp; i++, mp = mp->next) {
-		if (mp->format == FORMAT_RAW)
-			continue;
-		average.packages.counter[i] += p->counter[i];
+		if ((mp->format == FORMAT_RAW) && (topo.num_packages == 0))
+			average.packages.counter[i] = p->counter[i];
+		else
+			average.packages.counter[i] += p->counter[i];
 	}
 	return 0;
 }
-- 
2.43.0



