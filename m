Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC98196D86;
	Thu,  6 Jun 2024 14:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682900; cv=none; b=TyYa8+4EUT2hDfiIR2M8J/fg30NskV1Lbpgwvv13SjwyRgSvR4Zx6zwNzhhWe1erGSmU6C8vBzykbCzL0mJy1z00HeUrjS4UCg3+1zLhNZa16jjJNuCbNE1ohMS1Xc+T0oazMOJP1Kfpt6ghVAu1mYALN2SSUmWN+w3Hd3GXSkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682900; c=relaxed/simple;
	bh=Z8cK9KMcjFg40NQ1Xo+JA38MsCPA/9YoBUX/m+1vjb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LB8akN4yx+ypgld1LzvbnVvpx4O+RPNB7ml0x3N4HYSdhvKN+6/XQTii5YqNbMBEjrR4aslZsYa29xA/RxNY17+qMVm21pPLvdmZjtw8GhUkhA3JRmUR5O4wxCwfCAheQp9Y+vTifr7kFvUWaIGqq4duomIU7XLxg2Qb+Nk1gwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sQAlIlbY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sQAlIlbY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A92DC4AF07;
	Thu,  6 Jun 2024 14:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682899;
	bh=Z8cK9KMcjFg40NQ1Xo+JA38MsCPA/9YoBUX/m+1vjb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sQAlIlbY+QpKpuro8FA5AU5n6h+kAhQcdcNVE+vj462vdgjqk6ix0asbNHV+AsTpp
	 PGyh8N22AWdMX8axm/toyqlCH40e2KTr9L1ctmqNHWodRcSeDq26Ej86h2ouT5GQ5P
	 KlJV+OUFfhYtamCzKkg6H+BjXg+nt4LUk5CSTnbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Thomas Richter <tmricht@linux.ibm.com>,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sven Schnelle <svens@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 018/374] perf report: Fix PAI counter names for s390 virtual machines
Date: Thu,  6 Jun 2024 15:59:57 +0200
Message-ID: <20240606131652.385659822@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Richter <tmricht@linux.ibm.com>

[ Upstream commit b74bc5a633a7d72f89141d481d835e73bda3c3ae ]

s390 introduced the Processor Activity Instrumentation (PAI) counter
facility on LPAR and virtual machines z/VM for models 3931 and 3932.

These counters are stored as raw data in the perf.data file and are
displayed with:

 # perf report -i /tmp//perfout-635468 -D | grep Counter
	Counter:007 <unknown> Value:0x00000000000186a0
	Counter:032 <unknown> Value:0x0000000000000001
	Counter:032 <unknown> Value:0x0000000000000001
	Counter:032 <unknown> Value:0x0000000000000001
 #

However on z/VM virtual machines, the counter names are not retrieved
from the PMU and are shown as '<unknown>'.  This is caused by the CPU
string saved in the mapfile.csv for this machine:

   ^IBM.393[12].*3\.7.[[:xdigit:]]+$,3,cf_z16,core

This string contains the CPU Measurement facility first and second
version number and authorization level (3\.7.[[:xdigit:]]+).  These
numbers do not apply to the PAI counter facility.  In fact they can be
omitted.

Shorten the CPU identification string for this machine to manufacturer
and model. This is sufficient for all PMU devices.

Output after:

 # perf report -i /tmp//perfout-635468 -D | grep Counter
	Counter:007 km_aes_128 Value:0x00000000000186a0
	Counter:032 kma_gcm_aes_256 Value:0x0000000000000001
	Counter:032 kma_gcm_aes_256 Value:0x0000000000000001
	Counter:032 kma_gcm_aes_256 Value:0x0000000000000001
 #

Fixes: b539deafbadb2fc6 ("perf report: Add s390 raw data interpretation for PAI counters")
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Acked-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Richter <tmricht@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Link: https://lore.kernel.org/r/20240404064806.1362876-1-tmricht@linux.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/pmu-events/arch/s390/mapfile.csv | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/pmu-events/arch/s390/mapfile.csv b/tools/perf/pmu-events/arch/s390/mapfile.csv
index a918e1af77a57..b22648d127517 100644
--- a/tools/perf/pmu-events/arch/s390/mapfile.csv
+++ b/tools/perf/pmu-events/arch/s390/mapfile.csv
@@ -5,4 +5,4 @@ Family-model,Version,Filename,EventType
 ^IBM.296[45].*[13]\.[1-5].[[:xdigit:]]+$,1,cf_z13,core
 ^IBM.390[67].*[13]\.[1-5].[[:xdigit:]]+$,3,cf_z14,core
 ^IBM.856[12].*3\.6.[[:xdigit:]]+$,3,cf_z15,core
-^IBM.393[12].*3\.7.[[:xdigit:]]+$,3,cf_z16,core
+^IBM.393[12].*$,3,cf_z16,core
-- 
2.43.0



