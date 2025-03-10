Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 639CE22AE7C;
	Mon, 10 Mar 2025 17:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629187; cv=none; b=nSr+RDpCs/+GnVeNFDZsEGVop+BhAVosfPPEDOjNzlhn+Xw13T8Y9aJNM4+nLELf8bxhDXK5qWJnLmj7PdzqoAgMCwZNy8bm3H+ZS+cX8QYPGgZFG6PgoIlRmdCo7PRnpINOq9Tq+MJkUZlI8To6hItUY/UvR0c07cq32tNMemE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629187; c=relaxed/simple;
	bh=sa9EIE04LEBfTX6RvKjzgHk4Dm9SwO0xb0TMifbJsI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N1m477J8RLMukt9/Vuw8mIlkOyi+mMB76YrJX1zhDeeH3loFa80gJYpIjOPkbbTKjm/bUAswadwDPZIti7z6/u17UTZ3UzDOekHVGd8UmY9koboItLYuH7lSTawuRr0uEiKVciDcro0jtgjfCEQ10b9v1ZUgnNiVqmE5KY3C6L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cOsmwMnB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cOsmwMnB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83CE7C4CEEC;
	Mon, 10 Mar 2025 17:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629186;
	bh=sa9EIE04LEBfTX6RvKjzgHk4Dm9SwO0xb0TMifbJsI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cOsmwMnBycLk6SzmZcp785UZdlU3IJKh2xZQfrEL0gpjeBPmZ7eI6sSi0kaRuDbp2
	 vB0s20kw9A/2DcqPkiBYEzGvoJpf3AiI4qP3wrQ04mo7UO0Ofo+tiZ38Z03uBJ0bcN
	 lKuNlY08o7dnytDtGORDXGwnzpBKLbyObX/6qbPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 207/620] printk: Fix signed integer overflow when defining LOG_BUF_LEN_MAX
Date: Mon, 10 Mar 2025 18:00:53 +0100
Message-ID: <20250310170553.797863918@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5e81d2a79d5cc..113990f38436e 100644
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



