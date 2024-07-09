Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F71156F45;
	Tue,  9 Jul 2024 11:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523590; cv=none; b=HP9pVHorAMJg51890yLQVMZjSIFcMPmwVaZVVTTZ9N3KbZ99mO3WP8K5Veyv5a2FSC6c9Db5ROVL5bfdCSSi+aELz07PAbe1ehcSflVn+bL0IXqI5fp8EfLUM1rWpmY7e3k9V7Sj1jAnQvHnMRy0G0/83QvVgnLuUHi9twqsMQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523590; c=relaxed/simple;
	bh=b9/mjohbYADogJqcwRWFp9GwSanu+2GJI6o1QO+BzkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JD0RT/495hD0bekU7KRMKvxLL0CnS9I3fQrRzp0grIbPaWl1yFEii+3NHMLfuRKhA+Yo15s1ThmJqtyj/TUxh9nRfFPry2npKTNbYhrZNL6ybQ1wEEPw/uZCjI9MUf1csvPOU+MLUdRF89+WP3nn2oW4UhA4puLTB94B0B8scko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hDRkcWCc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hDRkcWCc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F00FC3277B;
	Tue,  9 Jul 2024 11:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523590;
	bh=b9/mjohbYADogJqcwRWFp9GwSanu+2GJI6o1QO+BzkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hDRkcWCc+Tk3Gc3jbhZnPYbf6/Xw4BS3wYY/2XuVuHDrJ5m6YqPPymp6GTamweGJ4
	 1zDdGeiVGWP98HvNle4t5897F85oLub4M5FI5z3Ui8CAmAS1GMJ58XoMbT94ALqoU1
	 jrButXodvt7OXt32+hqQTps2U/w4Y3OENCmCHF2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Marshall <hubcap@omnibond.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 042/139] orangefs: fix out-of-bounds fsid access
Date: Tue,  9 Jul 2024 13:09:02 +0200
Message-ID: <20240709110659.790240706@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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



