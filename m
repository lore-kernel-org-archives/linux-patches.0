Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C542931FB;
	Sat, 12 Sep 2026 08:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200130; cv=none; b=H9DUMvXoVbSoccPfDYeLuJxsi0J0a9FiPnAixVkJh33MWGF17djogxw1E56PQcEX+Icv+51U44OIocHtx17SXK7+AzWD2DbTObYa4TtH+DYgnVJE8wt72tqtc1eYM4UmXWZkMLMDkTlAYXqvOtFSmzq4up2fOyHNpwNtVxTtdxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200130; c=relaxed/simple;
	bh=uvLVhzsMvwzadSr05aaOAYvJpKjPtsocT20WJb8zSFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BEcZto6nteOT1H/wDnWswD7hcqpBvKnqGTe8LKUTi6brCS/v9zgcpTog7oUmCsEmId5B9zDK+hFhmHwvQOjRNDonEQEEpk+5zrXkpZtKZLAdy41gHaMf7ifD+dKwVQtnJ/8FUlnW8B5vY629bRQSbnytgaVI6/piX2B4mXKIs1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F7DqaWR6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F7DqaWR6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F033E1F000FF;
	Sat, 12 Sep 2026 08:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200129;
	bh=Q4/TkRpbboLU9qEEDPqiINBq9j0lm5jVQezgvBTBZfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F7DqaWR6RsTZTVuv/8A32Kjcz3g69JAfLV8q93gH4Mnu9wu+kMMiD6YfvyafTuMUH
	 mHUP+B5287e96Zd6kx1KvedKLb1LOqygMp9dOagIAeD5Yi3vo1pdytl8ysi+ge4psv
	 Wyk/iZCeBxubjtqT7d7sERx6uRRdg+UqJj2jP+Bg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+cae54346a70bbceeff2c@syzkaller.appspotmail.com,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0725/1815] nilfs2: fix infinite loop in nilfs_clean_segments()
Date: Sat, 12 Sep 2026 08:41:15 +0200
Message-ID: <20260912065705.920770358@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Crofts <joshua.crofts1@gmail.com>

[ Upstream commit ce5a5ad1a8330a2fcfdd9ec2ab341be739e89a18 ]

syzbot reported a hung task in nilfs_transaction_begin(). This occurs
because the cleaner ioctl falls into an infinite loop if
nilfs_segctor_construct() repeatedly returns -EROFS (e.g. the device
is remounted as read-only after an I/O error).

Currently in nilfs_clean_segments(), if err is non-zero, it logs the
error and sleeps but doesn't abort when it encounters a terminal error
like -EROFS. This causes the thread to loop forever.

Fix this by breaking out of the loop if nilfs_segctor_construct()
returns -EROFS. This matches the behaviour in
nilfs_segctor_write_out(), which also handles -EROFS.

Reported-by: syzbot+cae54346a70bbceeff2c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=cae54346a70bbceeff2c
Fixes: 9ff05123e3bf ("nilfs2: segment constructor")
Assisted-by: gemini:gemini-3.1-pro
Signed-off-by: Joshua Crofts <joshua.crofts1@gmail.com>
Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/segment.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 9332f5ac60833..2189267894d2c 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2561,6 +2561,10 @@ int nilfs_clean_segments(struct super_block *sb, struct nilfs_argv *argv,
 			break;
 
 		nilfs_warn(sb, "error %d cleaning segments", err);
+
+		if (unlikely(err == -EROFS))
+			goto out_unlock;
+
 		set_current_state(TASK_INTERRUPTIBLE);
 		schedule_timeout(sci->sc_interval);
 	}
-- 
2.53.0



