Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE30033E3
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:43:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E8C0C433EF;
	Mon,  8 May 2023 11:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683546232;
	bh=rlsRX6LZY4isiFob/7yTl8dcBKH0/qJJmNNOtO1ZwQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sbeQYr7LAvDu3Qkf7HaRnB3tnOdwRWfN1hAJ5v1WtOmMUkYPmz5IjthG2tw25zKJQ
	 QhlG6qlfSB00RUnHuirCevYEWdlQTa4KQvEen0iw5FspSmNt1vDfR4JneMrDeWsMTA
	 p7ZFb0TyHXu5JX/795/vuK4q0O1ySrrBDrk55Mio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 301/371] fs/ntfs3: Add check for kmemdup
Date: Mon,  8 May 2023 11:48:22 +0200
Message-Id: <20230508094824.002251306@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
References: <20230508094811.912279944@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit e6c3cef24cb0d045f99d5cb039b344874e3cfd74 ]

Since the kmemdup may return NULL pointer,
it should be better to add check for the return value
in order to avoid NULL pointer dereference.

Fixes: b46acd6a6a62 ("fs/ntfs3: Add NTFS journal")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/fslog.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ntfs3/fslog.c b/fs/ntfs3/fslog.c
index 20abdb2682860..88218831527c2 100644
--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -4256,6 +4256,10 @@ int log_replay(struct ntfs_inode *ni, bool *initialized)
 	rec_len -= t32;
 
 	attr_names = kmemdup(Add2Ptr(lrh, t32), rec_len, GFP_NOFS);
+	if (!attr_names) {
+		err = -ENOMEM;
+		goto out;
+	}
 
 	lcb_put(lcb);
 	lcb = NULL;
-- 
2.39.2



