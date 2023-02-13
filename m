Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4F68F57
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 14:57:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12AE0C433EF;
	Mon, 13 Feb 2023 14:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300274;
	bh=k7PqQOrF5xspToiOfP7aPjQqI1WWJ+YcXR8QTunBXBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l904CMeKjRUT885gFwODlLYUPznNB2sfSPitekTUHy5roqAlj5ieqoOAkZPbJQF4f
	 wEI8VPIo50dJthXRhDkWgoXnGScrExCYMRQsAsm8RnnhnVG3XQ3/UZk7Z9ieDGkjBd
	 sFV27KPE3IxKJOU8hslGATy6181P1YE2fzdxppgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dean Luick <dean.luick@cornelisnetworks.com>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 16/67] IB/hfi1: Restore allocated resources on failed copyout
Date: Mon, 13 Feb 2023 15:48:57 +0100
Message-Id: <20230213144733.111928702@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144732.336342050@linuxfoundation.org>
References: <20230213144732.336342050@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dean Luick <dean.luick@cornelisnetworks.com>

[ Upstream commit 6601fc0d15ffc20654e39486f9bef35567106d68 ]

Fix a resource leak if an error occurs.

Fixes: f404ca4c7ea8 ("IB/hfi1: Refactor hfi_user_exp_rcv_setup() IOCTL")
Signed-off-by: Dean Luick <dean.luick@cornelisnetworks.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Link: https://lore.kernel.org/r/167354736291.2132367.10894218740150168180.stgit@awfm-02.cornelisnetworks.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/file_ops.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index 686d170a5947e..1c1172aeb36e9 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -1318,12 +1318,15 @@ static int user_exp_rcv_setup(struct hfi1_filedata *fd, unsigned long arg,
 		addr = arg + offsetof(struct hfi1_tid_info, tidcnt);
 		if (copy_to_user((void __user *)addr, &tinfo.tidcnt,
 				 sizeof(tinfo.tidcnt)))
-			return -EFAULT;
+			ret = -EFAULT;
 
 		addr = arg + offsetof(struct hfi1_tid_info, length);
-		if (copy_to_user((void __user *)addr, &tinfo.length,
+		if (!ret && copy_to_user((void __user *)addr, &tinfo.length,
 				 sizeof(tinfo.length)))
 			ret = -EFAULT;
+
+		if (ret)
+			hfi1_user_exp_rcv_invalid(fd, &tinfo);
 	}
 
 	return ret;
-- 
2.39.0



