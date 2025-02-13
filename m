Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62FFB281341;
	Thu, 13 Feb 2025 14:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457254; cv=none; b=F2nfF6SVJVhwtX8nG7d26OofkAKAf5YHyRn5jUhz7e+JClO92cGQWXqa/mqT8lNER1dug2mZr+eg7sn2HUVoUaUGA2tS3v3fQWJCGUyNRWnzcfKuIv5vq34O2ej4HdlamfPw+ebSxGF9ZWq/4FpNcTPrGOqjrolJd/4m4kM6UT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457254; c=relaxed/simple;
	bh=Aqzu/+kAodyRcIvXUPVGwyPcwGhXekt4Q58uoiHQts0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cbGPrDQE2AhXWoKMUOaixUc0zRl7feupSDcmFnMfSAUK68dAZt4q2+1JetDwd7FGu0q2bombhTjtHmY1S/GzW3awNZDCCi4ZTBCburv86NcJNt1LozTx6KZGq6pCVPA9V1UIEyWCBSaLWEP4dyzlGastQ1zX28QQgd0hmF4QVfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tibCQ/dM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tibCQ/dM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62E24C4CEE8;
	Thu, 13 Feb 2025 14:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457253;
	bh=Aqzu/+kAodyRcIvXUPVGwyPcwGhXekt4Q58uoiHQts0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tibCQ/dM7OhMHAfe4hNEvo/3O5O4UVZyU9zXOEIGdcD7J1fJWiguw5QJ3eq5R+yIf
	 9s/9KZ5PwvWRbDhfv3ODrTzbyA0/HynlQDDQoG5hSNDgQa/oQCZcHjYJQtJlg5WHJN
	 p3JU8940UrWGFbzDHWDqFIXwWZqUF5CABPVlUyJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 027/422] printk: Fix signed integer overflow when defining LOG_BUF_LEN_MAX
Date: Thu, 13 Feb 2025 15:22:56 +0100
Message-ID: <20250213142437.602690031@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7530df62ff7cb..3b75f6e8410b9 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -523,7 +523,7 @@ static struct latched_seq clear_seq = {
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



