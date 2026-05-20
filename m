Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193293EC2DB;
	Wed, 20 May 2026 17:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298713; cv=none; b=RxLkGplMD4dEKD1tKiQ0qvS7BpN/NNtU5ix0b9LQOaLyVFrbg9ZLVmhjynG9lUV3v+pEGJ/SBnw8HIHIw+lFH+UxLCNeXcWLwB7rWLI/ZTl8dsyrCUOZRmu+WgJeETpWwkgvQTGYuSV5wv7yi9xRFq5Okh8ofiGxlV/Y6wDyHE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298713; c=relaxed/simple;
	bh=bujyJXahSibZa6Wk/rxg01V3xsyEaXMulNx3Qz7IpV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q4CEEYorVGxXMJ3UfRXZhLiQOBYlt90ziRoxYvsrRR/mSwhi5MdJBL71d48DT8QUeelSAtrnu6vbYqc1hqcp3+jC5nbFd3mJaMlhSNIu9dJzOJKYFM+CCBTxQWB7p8gqj5lZBEGYwUcZWHBA27KANSJvkJf+y6cwUfqhU+GvsiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P31wOB6k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P31wOB6k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36A6E1F000E9;
	Wed, 20 May 2026 17:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298711;
	bh=NgBYQ9agorpr6wjhG6RL0+bQonirOVxxrf5cl8uz9X0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P31wOB6k6iJXdv+2l2vegaK/WJvLY6Yf8lrzR6rxdPRGCb3esefmC5Yfm0vQ0yH63
	 SqqbXst+2HycFYwTbfRZn4b9GPpVvSiWLNXnrtT92oi5KnOd6le7mSNoq99VS9JtMk
	 QZB6qAUXK99K7DJGySeGWnK5vdgjOOOgDy22VbGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Zhang <zhangjian.3032@bytedance.com>,
	Corey Minyard <corey@minyard.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 514/957] ipmi: ssif_bmc: fix missing check for copy_to_user() partial failure
Date: Wed, 20 May 2026 18:16:37 +0200
Message-ID: <20260520162145.683327874@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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



