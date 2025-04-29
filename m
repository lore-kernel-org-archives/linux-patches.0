Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80EE61DF73C;
	Tue, 29 Apr 2025 17:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946607; cv=none; b=FPGQ1dZAU1qi62LkttMSvUQKH1uaPmv43J7biOrhjJ5TxZMB/rg7fukwXYqaWtctjmOQsf6PjbuCFm/IGoruG6q95PyewPKvbgr8cj9b2WdEmsCSWZawWiCeOWDj4aVp1WYQF98K/0cx57To9f9VhqiplEEc6TSxSSKGcnQJs9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946607; c=relaxed/simple;
	bh=XhhZPtw5xIDdjCD4t6PgS7QF0+pv3+XxAclFBmDkUv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hfbk9l/UZ0l5IUm3yeOoapPCVkktxR3e0F5QtGA9G+kCrFhJbif3oiPDCGqZNAXTxmNCZ/7GAo0QjHRRvEGlrIrhsmSLHmWdygluoFI9InTzLom3RF7vBVwDLjzOULFW9C4gEDH3oLHI8E4H+6WzbKvSkSMOXeHDb6N959+/x60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uKUV1wH8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uKUV1wH8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94940C4CEE3;
	Tue, 29 Apr 2025 17:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946607;
	bh=XhhZPtw5xIDdjCD4t6PgS7QF0+pv3+XxAclFBmDkUv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uKUV1wH8Dmb1dnhG2FmRbzawr06UXjqC13BYZFFu7f2tZD1flZ9RlRTO3v+MRZSKO
	 8atxSIimj9YrslH7jTWyqeoS4jBRKjFhaQd0nvtz8OTcfONrXkX6Wz88cR2SuVT/TE
	 DTfzuCTCtxa6LidEmVxHSZSVOixMsPpT/s3HaoBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhongqiu Han <quic_zhonhan@quicinc.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 011/286] pm: cpupower: bench: Prevent NULL dereference on malloc failure
Date: Tue, 29 Apr 2025 18:38:35 +0200
Message-ID: <20250429161108.318769156@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhongqiu Han <quic_zhonhan@quicinc.com>

[ Upstream commit 208baa3ec9043a664d9acfb8174b332e6b17fb69 ]

If malloc returns NULL due to low memory, 'config' pointer can be NULL.
Add a check to prevent NULL dereference.

Link: https://lore.kernel.org/r/20250219122715.3892223-1-quic_zhonhan@quicinc.com
Signed-off-by: Zhongqiu Han <quic_zhonhan@quicinc.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/cpupower/bench/parse.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/power/cpupower/bench/parse.c b/tools/power/cpupower/bench/parse.c
index e63dc11fa3a53..48e25be6e1635 100644
--- a/tools/power/cpupower/bench/parse.c
+++ b/tools/power/cpupower/bench/parse.c
@@ -120,6 +120,10 @@ FILE *prepare_output(const char *dirname)
 struct config *prepare_default_config()
 {
 	struct config *config = malloc(sizeof(struct config));
+	if (!config) {
+		perror("malloc");
+		return NULL;
+	}
 
 	dprintf("loading defaults\n");
 
-- 
2.39.5



