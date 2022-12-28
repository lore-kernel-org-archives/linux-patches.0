Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6CE1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 14:48:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A80F6C433EF;
	Wed, 28 Dec 2022 14:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672238914;
	bh=c4hsV7i8ymG8pi0rs0ItIYG7BfhreTpAMJMVsu1akkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dwJvxetBTLaV+WWMePE/2mnqdVKfBFiu5YkpbdBpRjgCP4oQHNsPv+iKMqbyJ7rNW
	 UhtXPs9wXN80lOx/uG9UZHFIITJcoaQnd6IXbvs6Sxj/eCOYsZpmytpPtAWuPVvwp/
	 lhzhyqdxZ5VP3dcywj+G4NcwC4iiVG/rWY5bRueo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Yufen <wangyufen@huawei.com>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 058/731] pstore/ram: Fix error return code in ramoops_probe()
Date: Wed, 28 Dec 2022 15:32:45 +0100
Message-Id: <20221228144258.236173393@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wang Yufen <wangyufen@huawei.com>

[ Upstream commit e1fce564900f8734edf15b87f028c57e14f6e28d ]

In the if (dev_of_node(dev) && !pdata) path, the "err" may be assigned a
value of 0, so the error return code -EINVAL may be incorrectly set
to 0. To fix set valid return code before calling to goto.

Fixes: 35da60941e44 ("pstore/ram: add Device Tree bindings")
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/1669969374-46582-1-git-send-email-wangyufen@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pstore/ram.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index fefe3d391d3a..74e4d93f3e08 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -735,6 +735,7 @@ static int ramoops_probe(struct platform_device *pdev)
 	/* Make sure we didn't get bogus platform data pointer. */
 	if (!pdata) {
 		pr_err("NULL platform data\n");
+		err = -EINVAL;
 		goto fail_out;
 	}
 
@@ -742,6 +743,7 @@ static int ramoops_probe(struct platform_device *pdev)
 			!pdata->ftrace_size && !pdata->pmsg_size)) {
 		pr_err("The memory size and the record/console size must be "
 			"non-zero\n");
+		err = -EINVAL;
 		goto fail_out;
 	}
 
-- 
2.35.1



