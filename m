Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2383069E08;
	Wed, 21 Feb 2024 13:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522733; cv=none; b=AnswBJY09UZhP+eaCVkNWO+p9hbOtp6t6UQhFTSZJk0H6ixBraeKOIk2EKNYYTHDZ6g8UamomtRjPGNwm5O7TW+0ZbwtwYYfArQnzkCYY5Sp9sWND0TmrKCxNhp9jVe4331xUJVM34/4BzByFyaiuxBNKLutizPOSeO3h4WQQN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522733; c=relaxed/simple;
	bh=Ozw+Enq0DRSfuZwtO+er6txZ4gCIx3Qqgdhw6UjSLuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DgcPiswkbrZTyv8zWV08wl9p9bwsATkXlonjZa1uJAsuMAUwl/9nxmykrM1Z7yifNJGHv2FmvRH/WcC9bRRCfqmuqC6CwA2eIgS6dZVLcLCgsC74dFbg0PMzBQUF6d7lH8tM/fatZLQsxRM4nQwj4BIDw5Rax/rPvtddu8krcKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HLDG0bkl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HLDG0bkl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8280C433F1;
	Wed, 21 Feb 2024 13:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522733;
	bh=Ozw+Enq0DRSfuZwtO+er6txZ4gCIx3Qqgdhw6UjSLuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HLDG0bklUfyryDA9ZkBbHFDDY4YRGS4aIC6MUtZbe/RGPBXwmqmkyZcHnZZdmxPIQ
	 L4+SOUxfTbCdWb2/yBZ7EdN+eIBjXjU2ktC+e1hYo4H+3B33XvlthOeC5zLg7s99Bd
	 GccEf+fbzkdVmjnhzgcyCB5VmwnUcr0Ycen7NDmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 214/476] f2fs: fix write pointers on zoned device after roll forward
Date: Wed, 21 Feb 2024 14:04:25 +0100
Message-ID: <20240221130015.813920492@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit 9dad4d964291295ef48243d4e03972b85138bc9f ]

1. do roll forward recovery
2. update current segments pointers
3. fix the entire zones' write pointers
4. do checkpoint

Reviewed-by: Daeho Jeong <daehojeong@google.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/recovery.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index da0801aa4118..f07ae58d266d 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -871,6 +871,8 @@ int f2fs_recover_fsync_data(struct f2fs_sb_info *sbi, bool check_only)
 	if (!err && fix_curseg_write_pointer && !f2fs_readonly(sbi->sb) &&
 			f2fs_sb_has_blkzoned(sbi)) {
 		err = f2fs_fix_curseg_write_pointer(sbi);
+		if (!err)
+			err = f2fs_check_write_pointer(sbi);
 		ret = err;
 	}
 
-- 
2.43.0



