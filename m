Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD45158858;
	Tue,  9 Jul 2024 11:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524574; cv=none; b=UJSg+2wFUf//ucQsXe8k8HxCgvceg8AVxD20crKrGi/YYuxUMGHB3ZjsrfZRSRwj+TE0yGkzn0uT/kxoH/khioInmxqNc1DgBdkjpV0Uij3h2Y7ahy1rAAdZmn4SPicxXnveEeQjz48Ek90Fq/AyiFSNhaZGqc2sdzmNOiakomE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524574; c=relaxed/simple;
	bh=PVe8iGc+bTwL46Z9+gixqumflAsVO3F4Dbp/2+rqZg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YtzLTCxKR/QmtTYoItojbtsQEeOhirO7mDGIqF5vUnaCxZxYbbnZeuqjAUuKEYC/5CMiJeiylQJr62a7rNPbXkK9RyTpIozrBw/MIGPbKDHwdQwngUhRBRVuVIsPvuLw/nmoaxP0fepMHgAxwBaQGfphWiFCnDKkwSu58iKWQTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aRzkFfnY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aRzkFfnY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5E16C3277B;
	Tue,  9 Jul 2024 11:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524574;
	bh=PVe8iGc+bTwL46Z9+gixqumflAsVO3F4Dbp/2+rqZg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aRzkFfnYmkd32l/r/ZWrNQGeCTCvHM47BsYyhfon4OAEYxktIbG9gIyegl/gNrvnb
	 fVozJAtsg4T/WltLdLkDyYDuDmhjqPgGT+EeZdDYzdbjG3M9wUIj1g1jod+VAN+M04
	 NYE7tMyhbhtlWxIeoK6hDj0do0CMse6iLzGg3ZpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Marshall <hubcap@omnibond.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 029/102] orangefs: fix out-of-bounds fsid access
Date: Tue,  9 Jul 2024 13:09:52 +0200
Message-ID: <20240709110652.504127691@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
References: <20240709110651.353707001@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Marshall <hubcap@omnibond.com>

[ Upstream commit 53e4efa470d5fc6a96662d2d3322cfc925818517 ]

Arnd Bergmann sent a patch to fsdevel, he says:

"orangefs_statfs() copies two consecutive fields of the superblock into
the statfs structure, which triggers a warning from the string fortification
helpers"

Jan Kara suggested an alternate way to do the patch to make it more readable.

I ran both ideas through xfstests and both seem fine. This patch
is based on Jan Kara's suggestion.

Signed-off-by: Mike Marshall <hubcap@omnibond.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/orangefs/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/orangefs/super.c b/fs/orangefs/super.c
index 4ca8ed410c3cf..24e028c119c1b 100644
--- a/fs/orangefs/super.c
+++ b/fs/orangefs/super.c
@@ -201,7 +201,8 @@ static int orangefs_statfs(struct dentry *dentry, struct kstatfs *buf)
 		     (long)new_op->downcall.resp.statfs.files_avail);
 
 	buf->f_type = sb->s_magic;
-	memcpy(&buf->f_fsid, &ORANGEFS_SB(sb)->fs_id, sizeof(buf->f_fsid));
+	buf->f_fsid.val[0] = ORANGEFS_SB(sb)->fs_id;
+	buf->f_fsid.val[1] = ORANGEFS_SB(sb)->id;
 	buf->f_bsize = new_op->downcall.resp.statfs.block_size;
 	buf->f_namelen = ORANGEFS_NAME_MAX;
 
-- 
2.43.0



