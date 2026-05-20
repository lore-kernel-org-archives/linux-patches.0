Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274933E314D;
	Wed, 20 May 2026 16:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296056; cv=none; b=uRmtSyJSXVryhUttlmZ2OLyN2uZ3fGnIvs5BIkQgrNJ0cwe7EpDMTu7BjC/jo3L2Ga9F9SJA6dGXx1jBk0yiWoMfsfNZSxGkiIL+M5hAhKqppVQWnCTGNV+vKSq3Q0Kr77L/+rXXE4Z0dYjgPRZupPQgdh4ocXYMfIGDOwY8ci0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296056; c=relaxed/simple;
	bh=GiUB/xUfmNR/I+Fa9lO0hXIxUrQjNeu1Y4kRAkdOXag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eVEoJJZp2hSuRh5+3Hmcpzg1zjGktBeX7lwtXkXBsSJfH1YA+33Y4/b0OaIMf88rnPqxe8QNQs/QwqHzF/YubyxSHL97/cqpD6KV5HTc8+c23X9NYjdKSGXgYJb9rn7wQxBFOeUpYuOEV3pHvNk/cNRgWMFnqfkB0Y4Rtxx/ZeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QVnzmyI0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QVnzmyI0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DF0D1F000E9;
	Wed, 20 May 2026 16:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296055;
	bh=bhAHFvtgB00aLHLfGOko8E4r6DlQk+p9pp+imZQ21OU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QVnzmyI00vsuSP3c8tIuvS2W6puL2M7DeQnsn5nCm2J/fjhSQmWa07hoIiTp4Tsjb
	 PNb0qsInsQNiSYHO+dHPPu9WJ7YV/WZBkJQrB64dLhKvql4PliNGG8ATqcDb1J4iaK
	 62OZAmlXesgA1k0NgJz0V+VegjLAIpX1dU1hCvxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Zhang <zhangjian.3032@bytedance.com>,
	Corey Minyard <corey@minyard.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0647/1146] ipmi: ssif_bmc: fix missing check for copy_to_user() partial failure
Date: Wed, 20 May 2026 18:14:57 +0200
Message-ID: <20260520162202.827476522@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 7a52e3ea49ed8..6cc5c210799ca 100644
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



