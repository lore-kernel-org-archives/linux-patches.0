Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4CD2135B0;
	Thu, 12 Dec 2024 15:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018426; cv=none; b=lr01rR06UXbiIX3frIcVcBLbvIJyTxLABDJHJLeKePZMWkVA+cxxgMBireFVtwSaP9XUZiOX21wLPH3rXBLJ6r50zh6T4/avCh9znQQr3Wkon7uTtM4WFtlBsJLfL1qFDZt66GfYatkzoYrcPLqbUNzMSdjJnUxMFUiGWp6rWa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018426; c=relaxed/simple;
	bh=Z6KLf2tSCwTi/DbUlj9cz49k8UoVoe6zumr3I8NUtA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MwUmSROT0URmyPFHRrRRAvFdVTP6l/eG0/G90bMB4X03HO5EtwmhOvPGuLrI+4/kYeTuXxKMbBBIH1RDIFw9KGOAlrt68nO5WGlwcD8uuPu0E01Hmo23uW61+UDMbA2fVZ8t8xlMdbzhTbdD32LBQr3fBYmcWoYhocxsYPewZ18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0V7gsE2U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0V7gsE2U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28BD2C4CECE;
	Thu, 12 Dec 2024 15:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018426;
	bh=Z6KLf2tSCwTi/DbUlj9cz49k8UoVoe6zumr3I8NUtA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0V7gsE2UuhR6JKKVSXXqteqTnv2metVsS3ZvW6+1BRHSPYeKU80Ref+r6u96VNzJL
	 LhkVXFT55zpXXEMFToZVL58Vr2bZXP3FVnkOb+JoFXjnH8x0yjWAVi1JDi+DxApdit
	 UFVA/EKVo/UGIX5lgFSAiQfGkgN6wIfFK5seSkgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+aa0730b0a42646eb1359@syzkaller.appspotmail.com,
	Qianqiang Liu <qianqiang.liu@163.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 288/356] KMSAN: uninit-value in inode_go_dump (5)
Date: Thu, 12 Dec 2024 16:00:07 +0100
Message-ID: <20241212144255.953817504@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Qianqiang Liu <qianqiang.liu@163.com>

[ Upstream commit f9417fcfca3c5e30a0b961e7250fab92cfa5d123 ]

When mounting of a corrupted disk image fails, the error message printed
can reference uninitialized inode fields.  To prevent that from happening,
always initialize those fields.

Reported-by: syzbot+aa0730b0a42646eb1359@syzkaller.appspotmail.com
Signed-off-by: Qianqiang Liu <qianqiang.liu@163.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 09285dc782cf8..49684bc82dc16 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -1567,11 +1567,13 @@ static struct inode *gfs2_alloc_inode(struct super_block *sb)
 	if (!ip)
 		return NULL;
 	ip->i_no_addr = 0;
+	ip->i_no_formal_ino = 0;
 	ip->i_flags = 0;
 	ip->i_gl = NULL;
 	gfs2_holder_mark_uninitialized(&ip->i_iopen_gh);
 	memset(&ip->i_res, 0, sizeof(ip->i_res));
 	RB_CLEAR_NODE(&ip->i_res.rs_node);
+	ip->i_diskflags = 0;
 	ip->i_rahead = 0;
 	return &ip->i_inode;
 }
-- 
2.43.0



