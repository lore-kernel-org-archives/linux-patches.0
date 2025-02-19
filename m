Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B441CD208;
	Wed, 19 Feb 2025 09:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956849; cv=none; b=SaSjn1s+Z5pWqoJCTDg7WDO/oS39n4W38gf/GxKVSTil0CZSQ9EpZE4l8pVPVQDjdopPofz5WM65t/outQacXDWNufIn0M5M6+/1nijepFmJwHiFAvkNaC5DI2tX1HkiBOsAHQHN0EqIMI90+vY/CHfer/Yc4ibC5IR2HPcr/8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956849; c=relaxed/simple;
	bh=68ltqnvDpZ2YwTpMQbjvQ3pvV8DRmE4m9wmQRhqXvi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=frummYhdzQ/8eOZf29yDxfpfgviRgcjcKR5qAVrCp+GZlyVcz7nuZD5mdlR0hEGWGD+22XoM8/xPyoN2pRXZ5aeBPQ7FHPVQNWh4FEF0dZgLJBGDlVwegDPu9WvYHGoIMkh8b+Kp8Un+IMiaIAL3a21YaLC6ZQ5xPJkdEqXQ+vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QmvVw3Yp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QmvVw3Yp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0930C4CED1;
	Wed, 19 Feb 2025 09:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956849;
	bh=68ltqnvDpZ2YwTpMQbjvQ3pvV8DRmE4m9wmQRhqXvi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QmvVw3Ypt2UMyBQBxt5JJ3IX5ipl6rcVNWm9cNVzCoL8qMGiuGmEyC39QLxAYaVHR
	 4gln8igCDRn3SJu9hY8Y0oMCCzGyCKczvCwaXHJFGuGfo/SNPFaVwj5p+X3TfsjpEl
	 SXGbkunx6cWjB3yOHLbZABE7f+JLUB+lzJGgB5JM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 279/578] printk: Fix signed integer overflow when defining LOG_BUF_LEN_MAX
Date: Wed, 19 Feb 2025 09:24:43 +0100
Message-ID: <20250219082703.993383484@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuan-Wei Chiu <visitorckw@gmail.com>

[ Upstream commit 3d6f83df8ff2d5de84b50377e4f0d45e25311c7a ]

Shifting 1 << 31 on a 32-bit int causes signed integer overflow, which
leads to undefined behavior. To prevent this, cast 1 to u32 before
performing the shift, ensuring well-defined behavior.

This change explicitly avoids any potential overflow by ensuring that
the shift occurs on an unsigned 32-bit integer.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Acked-by: Petr Mladek <pmladek@suse.com>
Link: https://lore.kernel.org/r/20240928113608.1438087-1-visitorckw@gmail.com
Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/printk/printk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 5a88134fba79f..c93beab96c860 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -403,7 +403,7 @@ static struct latched_seq clear_seq = {
 /* record buffer */
 #define LOG_ALIGN __alignof__(unsigned long)
 #define __LOG_BUF_LEN (1 << CONFIG_LOG_BUF_SHIFT)
-#define LOG_BUF_LEN_MAX (u32)(1 << 31)
+#define LOG_BUF_LEN_MAX ((u32)1 << 31)
 static char __log_buf[__LOG_BUF_LEN] __aligned(LOG_ALIGN);
 static char *log_buf = __log_buf;
 static u32 log_buf_len = __LOG_BUF_LEN;
-- 
2.39.5



