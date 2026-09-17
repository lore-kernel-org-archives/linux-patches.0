Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873734F93AD;
	Thu, 17 Sep 2026 17:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665754; cv=none; b=EClbp5vPVDEDgTYPmlAW2n1dbiev0PVTw8I2S+f1t5SlFKcSXF9O9zorRH9h+0WYm1P9CLuPzr2Q7rlNGSeBHtCZrbcWA4DuKR2fNr+qN994PxJfKsSCeMHDGQyFtEd0MG7dZSP9g2sdtZv6zP127L3Za8w5cKexs1VE+c1TTRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665754; c=relaxed/simple;
	bh=vSjKnR3E1zY0NcJMSjMKPvN0I7Z6aFoJqO+jP0FJ8QA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OI2b48NeeyqwqDMmd4Jy+J+4wh7gtSPpxaKMX4/Hnm+GDtmbCSfXb6BRtpTOCsml0e3tKTQGJwDgIDxAJcJbNTAAjJIZonxwl+g9HcD7p4bkl5i3UtJbjIp1uiMLNWrC1L/8QX+Vj9jcPg4WmlgUDK3ypcif7VDoFCxN9JDfEWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0rk9ts/V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0rk9ts/V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC11A1F000FF;
	Thu, 17 Sep 2026 17:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665753;
	bh=gqkzBFysKa4g2lJjFvS3nMnozSSEw3rEZHzePAkm4lQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0rk9ts/VIpF3FXdujf/SKg82LBKuWo961xGXKHiHqnexI/liUgOO7XtcpZCyr5mMA
	 4Wea/t00mshBsg2rRtTWVFKrsU0YAiI1Oomf4l/4WZ7vqyPven/Xgycv5Kd0KUAJO9
	 sgydNYdZDS34z1YcOkqjxqSVyNIwoxn0aGkwTmJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0808/1250] powerpc/kexec_file: Use inclusive range checks for excluded memory
Date: Thu, 17 Sep 2026 16:10:03 +0100
Message-ID: <20260917151613.815992160@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit 449f60f99f8f3cbe80a9bd2242945e827c5ed003 ]

arch_check_excluded_range() checks if a kexec segment overlaps an
excluded memory range.

Both ranges use inclusive end addresses, but the overlap check uses
exclusive comparisons. This skips ranges with start == ->ranges[i].end
or end == ->ranges[i].start. Use inclusive comparisons instead.

Fixes: 6e5250eaa665 ("powerpc/crash: use generic APIs to locate memory hole for kdump")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260810145827.157972-3-thorsten.blum@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kexec/file_load_64.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kexec/file_load_64.c b/arch/powerpc/kexec/file_load_64.c
index c2ed0d1c92e75..d990880b77dfd 100644
--- a/arch/powerpc/kexec/file_load_64.c
+++ b/arch/powerpc/kexec/file_load_64.c
@@ -57,7 +57,7 @@ int arch_check_excluded_range(struct kimage *image, unsigned long start,
 
 	emem = image->arch.exclude_ranges;
 	for (i = 0; i < emem->nr_ranges; i++)
-		if (start < emem->ranges[i].end && end > emem->ranges[i].start)
+		if (start <= emem->ranges[i].end && end >= emem->ranges[i].start)
 			return 1;
 
 	return 0;
-- 
2.53.0



