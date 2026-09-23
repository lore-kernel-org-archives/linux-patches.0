Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B17C533582;
	Wed, 23 Sep 2026 14:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174155; cv=none; b=KjhOha4I4RElYGgCUOsXHzjfzw1/f2R5ug7Vy4FJJ8Ugg2u7CCS3cVit2OlltukLUzmgXUZMR1fCE2JNlZ7z25k5kbioN+WG+qmq1Uj4TUpMuw6+cJ+KxOX6jz56s5t9/03qRooH8/c41lp6x4DK5Ge1gVCQ/i1WKmsY8Mu1X5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174155; c=relaxed/simple;
	bh=3NB5wOK0m7OwVeZQ8wk/lzGt0nz14Tf/ZKElrhpbXhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nuxEyRm3oeULPfl0fnLP2F9MQSjYU0g0LmD22Gplk95J6882FvSQmV11qfA+8XvFcBIEm3uF86dUcALogZheslpe20bLynDd4uzKrinnBQ6JokcCOcOT0FYuAXZgYoj2xZrxiyctTBvBV0O5+P2uSob5y7co+E96C2x/DMc9W/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yhPUfXAP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yhPUfXAP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F32101F000FF;
	Wed, 23 Sep 2026 14:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174154;
	bh=vLvPHRWruPQHLlw8b/yd4/gUIkimxRKuvuJXtNzWFd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yhPUfXAPhMhMnkd4YxPeXIMxHqOpco1TnG1wvDuuk66mh8t05ij+SUCrwTEGKpEfU
	 rQA0jetzRW/eHyYuNMyLL6gWX/blG+7LTpC1NVt7aEeZCLUhA6RM2I/IHY/LQw4ajj
	 O3Q/Y+vYNMWFjN2Cxre2pODybeYnpso8ZrtEJYs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xixin Liu <liuxixin@kylinos.cn>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 027/398] firmware: arm_scpi: reject DVFS OPP count above MAX_DVFS_OPPS
Date: Wed, 23 Sep 2026 16:01:41 +0200
Message-ID: <20260923140644.135787540@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Xixin Liu <liuxixin@kylinos.cn>

[ Upstream commit 32471d84a487c7fd74532bc96be56f8028cf4a3f ]

scpi_dvfs_get_info() already rejected a zero opp_count, but still trusted
any larger value from the SCP firmware. The shared-memory reply only holds
MAX_DVFS_OPPS entries in buf.opps[]; a bigger count over-reads that array
and then sizes the allocated OPP table incorrectly (garbage OPPs / OOB).
The missing upper bound dates back to the original SCPI DVFS support.

Reject zero and out-of-range counts in one check and return -EINVAL.

Fixes: 8cb7cf56c9fe ("firmware: add support for ARM System Control and Power Interface(SCPI) protocol")
Signed-off-by: Xixin Liu <liuxixin@kylinos.cn>
Link: https://patch.msgid.link/022802f0b38f.v2.1785200642.git.liuxixin@kylinos.cn
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scpi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/arm_scpi.c b/drivers/firmware/arm_scpi.c
index 398642cc25d90..b8b7907089d78 100644
--- a/drivers/firmware/arm_scpi.c
+++ b/drivers/firmware/arm_scpi.c
@@ -631,8 +631,8 @@ static struct scpi_dvfs_info *scpi_dvfs_get_info(u8 domain)
 	if (ret)
 		return ERR_PTR(ret);
 
-	if (!buf.opp_count)
-		return ERR_PTR(-ENOENT);
+	if (!buf.opp_count || buf.opp_count > MAX_DVFS_OPPS)
+		return ERR_PTR(-EINVAL);
 
 	info = kmalloc(sizeof(*info), GFP_KERNEL);
 	if (!info)
-- 
2.53.0



