Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A01C23368B6;
	Wed, 20 May 2026 18:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300957; cv=none; b=GQO6PML6YqCT7hnLkrkCbuJHPBhvGaHQoeIYj3cFQsM0/n2Fn5QxMSlCnE7M/dYjUa+rBrk5zwPPVGvS4G/BoxjIRMigggM/Olhd3or8jJTEmDkwahbn/iMcqjYlwYLQl4vP8TPz3HwP/0c1FJG4KlDm0BNALMIabtcYQuA8D1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300957; c=relaxed/simple;
	bh=dfS5NYYpXiyL7Q4kSg9zCIstm41PDkpLI6mzHj6qfyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fzkgmVjjXj2UYEU0ZkA6GwN8LwQfi6p2UyetJfWPFYxF6IiPIBRPZZrrYnxZDVXFSNTmXILhDZqYYj/ldK9ihScZ2L4YRxJ+S8kv9i5rj3eEOPn3oQxCO5FhP/le7MeVXZpC9WW5G9g0PEznC8DPlzT42QMfxQm/2F57o/Hj8kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A9VjTwc0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A9VjTwc0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 110B51F000E9;
	Wed, 20 May 2026 18:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300956;
	bh=Hxfs8w/EZ+L4PRE3OEWcdGv0SFOujIWLt76wIMqEtBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A9VjTwc0CqQPboT6N4duXEviY1ECTFdi3Gvywh1gb/rcH5Qm+sX6TBsUeHt17diw4
	 3T+i2B1DPP/Q7VjJFjEVfg5YU78u3vp5JoMI+jYSSkGuqUYOfF1th6RYHHhPXIMtM3
	 y0Gsoiv6Aco5MU2LauHoUL5SuUarBJO4RY8kXYrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Zhang <zhangjian.3032@bytedance.com>,
	Corey Minyard <corey@minyard.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 371/666] ipmi: ssif_bmc: fix missing check for copy_to_user() partial failure
Date: Wed, 20 May 2026 18:19:42 +0200
Message-ID: <20260520162119.284132357@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

From: Jian Zhang <zhangjian.3032@bytedance.com>

[ Upstream commit ea641be7a4faee4351f9c5ed6b188e1bbf5586a6 ]

copy_to_user() returns the number of bytes that could not be copied,
with a non-zero value indicating a partial or complete failure. The
current code only checks for negative return values and treats all
non-negative results as success.

Treating any positive return value from copy_to_user() as
an error and returning -EFAULT.

Fixes: dd2bc5cc9e25 ("ipmi: ssif_bmc: Add SSIF BMC driver")
Signed-off-by: Jian Zhang <zhangjian.3032@bytedance.com>
Message-ID: <20260403090603.3988423-2-zhangjian.3032@bytedance.com>
Signed-off-by: Corey Minyard <corey@minyard.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ssif_bmc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/char/ipmi/ssif_bmc.c b/drivers/char/ipmi/ssif_bmc.c
index 310f17dd9511a..c2e59899f1c4c 100644
--- a/drivers/char/ipmi/ssif_bmc.c
+++ b/drivers/char/ipmi/ssif_bmc.c
@@ -163,6 +163,8 @@ static ssize_t ssif_bmc_read(struct file *file, char __user *buf, size_t count,
 		spin_unlock_irqrestore(&ssif_bmc->lock, flags);
 
 		ret = copy_to_user(buf, &msg, count);
+		if (ret > 0)
+			ret = -EFAULT;
 	}
 
 	return (ret < 0) ? ret : count;
-- 
2.53.0



