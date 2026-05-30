Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2BE137750;
	Sat, 30 May 2026 18:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166952; cv=none; b=Qr8R1IIQAlhHubSytEsm4MeDwxvi3tYon9DhxaXYmXYtwfLaAfO1xocRDlxiFCERHKfecbTW+J4UVVSZXTTWYogg7BujaQrlhC+nZx/bABKftWHIMLAw976eA2u74nhPnvp5dH2GLftvWdVfw4fwB556exdnA+x34RlOzyyoX5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166952; c=relaxed/simple;
	bh=ViX5VdLJuiTK/dMoJlPpyS1DU9vv2ri9Nc3vBnmZWS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dh+Lh9TkDBajMCDNYhdU1BbavKBFelqcrKj2Xmrp12gmU9/6T6t/18md3eWGc5XO7WmjsWVbPpVsPxKmWuQn8hKxXGaHdn8yFfVvLWN8d13PadyNb+dqe4Enst2PnT07lKtxfnxNDfE9bs4eS1KVT99/fFkUh7YjMPukko7wnMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yyRTccY0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yyRTccY0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD6C41F00893;
	Sat, 30 May 2026 18:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166951;
	bh=FarddmOWscuFnz8E4mlbCQMTcIDaL4X5GEbIouEdqhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yyRTccY0yzkWw9S0lN1qbE1GN7WDh8ldH52uqn/Y8+Z4reEwPDWE/bCQGWl4d2wk0
	 9jlp8A2o3hYarTPSi9a2bI+qxMhIbhDJZYjHefLVYZ//G9qjsloTMBEoQQ6Z2sKeKe
	 GgEHPvRx8YYaEYPI8XJ7CpYMHF0JDTNpU0EMuHOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Benjamin Block <bblock@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 521/589] s390/debug: Reject zero-length input before trimming a newline
Date: Sat, 30 May 2026 18:06:42 +0200
Message-ID: <20260530160238.310839706@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit c366a7b5ed7564e41345c380285bd3f6cb98971b ]

debug_get_user_string() copies the userspace buffer into a newly
allocated NUL-terminated buffer and then unconditionally looks at
buffer[user_len - 1] to strip a trailing newline.

A zero-length write reaches this helper unchanged, so the newline trim
reads before the start of the allocated buffer.

Reject empty writes before accessing the last input byte.

Fixes: 66a464dbc8e0 ("[PATCH] s390: debug feature changes")
Cc: stable@vger.kernel.org
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Reviewed-by: Vasily Gorbik <gor@linux.ibm.com>
Tested-by: Vasily Gorbik <gor@linux.ibm.com>
Link: https://lore.kernel.org/r/20260417073530.96002-1-pengpeng@iscas.ac.cn
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/debug.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/s390/kernel/debug.c b/arch/s390/kernel/debug.c
index ece21ebf6558f..a347f6244654a 100644
--- a/arch/s390/kernel/debug.c
+++ b/arch/s390/kernel/debug.c
@@ -1211,6 +1211,9 @@ static inline char *debug_get_user_string(const char __user *user_buf,
 {
 	char *buffer;
 
+	if (!user_len)
+		return ERR_PTR(-EINVAL);
+
 	buffer = kmalloc(user_len + 1, GFP_KERNEL);
 	if (!buffer)
 		return ERR_PTR(-ENOMEM);
-- 
2.53.0



