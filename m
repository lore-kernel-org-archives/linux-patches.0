Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9784919DF71;
	Tue, 16 Jul 2024 15:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144523; cv=none; b=awmBCYV080M0UGaYgLtMc3jmsE/S0RysB4DjFkvvvV1W/NV/njxcQaF9QwrGgXZz9IJVWC9zSXYjIKNS7Pvx+uMRPvpohVkARmdHH7y/gVryw2Dvbq1vge1xxBYj+CQ8H6gTN6RCU1Z2relMIyHCay5ybpFTtGazpElp9Ygzc1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144523; c=relaxed/simple;
	bh=RhVVIoquaSwzP6jnc+dTDIX5BVqbLUrJERBSExmbLR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iqrrr0tWkR3gjpUlztWTA/B8f0T0rjEJNQOelPvHFH/BNJKe1IRAepK2ZShvjpmro6MQSo7qF/D1oE/JZtzlAn7PnQIkaz5JocTXpj19crMpxTNt1BTJnz0Yj2CCODIs49tSdBt19gBA307PZyoy5v0sHVdFhY2AH9ONvB64Y/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZydshtRB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZydshtRB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C814C4AF0F;
	Tue, 16 Jul 2024 15:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144523;
	bh=RhVVIoquaSwzP6jnc+dTDIX5BVqbLUrJERBSExmbLR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZydshtRBe+HAOggNVlJkhWZMGFFeDBm7spvcw020eaXdSReWSGcF1jrxQ+IH2nIrK
	 X62aSJyrpyamQ2j0Nq2JbtC6ZuGievFNWo+1nZbaV4xN7QrpvTW3RtMI7iGTWoBubI
	 oQAtefFiEhOINOO6N9KAnhLi82YSVfbSUAbuXin0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Marshall <hubcap@omnibond.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 021/108] orangefs: fix out-of-bounds fsid access
Date: Tue, 16 Jul 2024 17:30:36 +0200
Message-ID: <20240716152746.814983545@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152745.988603303@linuxfoundation.org>
References: <20240716152745.988603303@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 2f2e430461b21..b48aef43b51d5 100644
--- a/fs/orangefs/super.c
+++ b/fs/orangefs/super.c
@@ -200,7 +200,8 @@ static int orangefs_statfs(struct dentry *dentry, struct kstatfs *buf)
 		     (long)new_op->downcall.resp.statfs.files_avail);
 
 	buf->f_type = sb->s_magic;
-	memcpy(&buf->f_fsid, &ORANGEFS_SB(sb)->fs_id, sizeof(buf->f_fsid));
+	buf->f_fsid.val[0] = ORANGEFS_SB(sb)->fs_id;
+	buf->f_fsid.val[1] = ORANGEFS_SB(sb)->id;
 	buf->f_bsize = new_op->downcall.resp.statfs.block_size;
 	buf->f_namelen = ORANGEFS_NAME_MAX;
 
-- 
2.43.0



