Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CDA2335BA;
	Thu, 13 Feb 2025 15:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460090; cv=none; b=d1ak5IjPVWVbgKcpCJtG7cIqXLJsQ+hawOWJ7cJ6aqRVE1oF5ZJFH2SJttTEcxuNXEVUvsTz7MdhCe4arEB2i5CZoXjsHIwV4+/Pz3fbITLTMR6IcEdfq2TxqcySPZYUFDycRG2eogO/i1O+6j0cT6+TYPvw92lAQKb1uQv2b0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460090; c=relaxed/simple;
	bh=YCejsGl3/qENvzspttpFEuQ3rsctAj2owTWFOwzeVBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fm7hkRaz1e034SdVHf5DALRlDYhy0T60bH2/jqE/F9uF8g4nVIJlWDgfO2aBTcE6+XSopbfYgEB8M6491lwWaETHMyPwIPmGMKcBaIsOwTtRbwY42UZlPVKZ/oPczkwERa6vsVXNXCfgIX5BivMdSvoQtFBmS1dFRq2fkJiSbyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F8K6NkHW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F8K6NkHW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A485C4CED1;
	Thu, 13 Feb 2025 15:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460089;
	bh=YCejsGl3/qENvzspttpFEuQ3rsctAj2owTWFOwzeVBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F8K6NkHWnfIpjmFfxlIEa5STcDPMaqMpZVuNNVllAzHBz4hE726uWmOvk0/+JE3Z0
	 AoZudaG344Isz24nOo/ArPXTkdz8mta0GVnfV0WmZjADihcYevYsyPbaei/JPwd97f
	 SVT2WocZw2ZU6NC8dIW7ppYj+qT99BNQQrRje9ok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 012/273] printk: Fix signed integer overflow when defining LOG_BUF_LEN_MAX
Date: Thu, 13 Feb 2025 15:26:24 +0100
Message-ID: <20250213142407.847665652@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0fca282c0a254..dcdf449615bda 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -474,7 +474,7 @@ static struct latched_seq clear_seq = {
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



