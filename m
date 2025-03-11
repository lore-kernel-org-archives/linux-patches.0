Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285CD33EA;
	Tue, 11 Mar 2025 15:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706684; cv=none; b=MkoovskRd4oT10nH6okwt4rGTRtYV4XNs4wpEdlbHUXYMynAg9XmJ5HiSGV/nTQkNAMcd72ptuEyheH7NG+zmR9r18ePdijfOfQIDpXmIALTIAd8/JK85NqK+XB1ixEoZ7pGcnYqscDEeXgx5SZy7dW0+YubiVPOYnulATDSXgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706684; c=relaxed/simple;
	bh=8LhqeJbBdxYK5bpROu2NeTldNTBgbZrCiJ5RNrHVUb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c5QDWzWT0CBpMezZ3nl5bcE6HmFVs8pb0vmyPlptIYhWTs9/6uLD9ncFTUbjChib5kbHMR+VEAO19SoVbvYkYVrvcRMJJv/vtuR2ITPkz2amqaaSdBgQqrPt3E/AttD00e/kh+HC8jgErAZZH2n2nczVwtYKSor40iPiar8qEkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gpd0/xzh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gpd0/xzh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FCBDC4CEE9;
	Tue, 11 Mar 2025 15:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706684;
	bh=8LhqeJbBdxYK5bpROu2NeTldNTBgbZrCiJ5RNrHVUb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gpd0/xzhbn8IpAj1ZaD9v9t79Wr6by/ikY5+TmAw+nqKwhJnFzuVJVe+mXt8akCfs
	 QNJflDqa90mmwx8njT3VThLogA2gUfhmDz5Cn/y4vxBqn5erPEp/VirD+Xg6+9qGvG
	 rPoGabWj+PXYuBN41HOVjG51cCQ1W2OIrAQzLu7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 131/462] printk: Fix signed integer overflow when defining LOG_BUF_LEN_MAX
Date: Tue, 11 Mar 2025 15:56:37 +0100
Message-ID: <20250311145803.532601228@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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
index a8af93cbc2936..3a7fd61c0e7be 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -420,7 +420,7 @@ static u64 clear_seq;
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



