Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB3E1D0429;
	Wed,  2 Oct 2024 13:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875217; cv=none; b=d+IeVcVYHYEw2+MvmyPQBJNT/jW8UJxxVaF2IzYIcKRw2JUTg0eExxJ8G5j0SI0IrCKet7duNbHpUcpn5mlqtEgusbTPcINghAU4TSketmvjbFSQCauqCSyw7tQoJ59srVaP6C6+Xxxazc1Q1cOSspKKHw32pzc9Tje1XTylASg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875217; c=relaxed/simple;
	bh=rsWizMjMdedGVVnEPJ+ArmvMXUTUZyHP4MSiGe4aY3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LBuQ49gjKtlZb6yx7ocdjeEKWxvZIH9rZfKtG7MHyTEUfKj0RKLqMJEHkRifM4hmamaA9UQoNcXTuOKUBktUAvIs2V5QGegDfazMgnDzgHaHBRdix4PL9+V3sZdVuD3FinHo/frHOV1Bvh7Ta1PRTHUG8tKhAqUFMEXnjuZbbzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n2YffQoA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n2YffQoA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 097DDC4CEC5;
	Wed,  2 Oct 2024 13:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875217;
	bh=rsWizMjMdedGVVnEPJ+ArmvMXUTUZyHP4MSiGe4aY3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n2YffQoAVPiPF1XGATTgRj1SwjicgVs4cR2tfuLl/J/HNxt6N00dDklqN53Z7PZHy
	 BgYoQiWBLo8960vFK2mSyD5ODrVlcsLw+pyBznsDpxJjChbnmiuTD3lEve7qtgGFjI
	 6RqORREATWuYjkX+o3NMincvKheNrk+yulaES9GA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksa Sarai <cyphar@cyphar.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 031/695] autofs: fix missing fput for FSCONFIG_SET_FD
Date: Wed,  2 Oct 2024 14:50:29 +0200
Message-ID: <20241002125823.735354964@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksa Sarai <cyphar@cyphar.com>

[ Upstream commit 6a64c5220c5df235448b846aeff3c0660d4cc83e ]

If you pass an fd using FSCONFIG_SET_FD, autofs_parse_fd() "steals" the
param->file and so the fs_context infrastructure will not do fput() for
us.

Fixes: e6ec453bd0f0 ("autofs: convert autofs to use the new mount api")
Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
Link: https://lore.kernel.org/r/20240731-fsconfig-fsparam_fd-fixes-v2-1-e7c472224417@cyphar.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/autofs/inode.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/autofs/inode.c b/fs/autofs/inode.c
index cf792d4de4f1b..64faa6c51f60a 100644
--- a/fs/autofs/inode.c
+++ b/fs/autofs/inode.c
@@ -172,8 +172,7 @@ static int autofs_parse_fd(struct fs_context *fc, struct autofs_sb_info *sbi,
 	ret = autofs_check_pipe(pipe);
 	if (ret < 0) {
 		errorf(fc, "Invalid/unusable pipe");
-		if (param->type != fs_value_is_file)
-			fput(pipe);
+		fput(pipe);
 		return -EBADF;
 	}
 
-- 
2.43.0



