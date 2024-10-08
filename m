Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A0171DE8BE;
	Tue,  8 Oct 2024 13:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393736; cv=none; b=nD3y4rnwwdAMNkjao2/Kb9Pm+nooiZwlLvGbYQ0dWDHUT0+MjQiJf+GieH5YFfjw4V+L/MpeCdS31/2h94Dl51NoL3poqNBNEOWp+K4dcBqj+mgCDePa9HSkk5r8/CBsd4Fe2apSZM4YoxJf/NHfPSOv8IciT+QPgcBibwgXw7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393736; c=relaxed/simple;
	bh=4w8QtQKmIUcweIKwxAJR8D7bZqctae8O/sWBPQrVvSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UpcTas0GQiC+5SpVAcKFGLzUPe8voE/5zH5eqdKlv7y9nqUvQsEapF3ztNrTZS8aGdzt6NNDVIuNwU/UXS7vvN5jB+hy1lnXtSp4yOtdNcZ2NCxg8IKpX5x3wTwCUzTSiDaUIaegBuZPvka9WQSERtuF7QFT2hCAYt3KpGJe19I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ryeq1zR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ryeq1zR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E1F2C4CEC7;
	Tue,  8 Oct 2024 13:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393736;
	bh=4w8QtQKmIUcweIKwxAJR8D7bZqctae8O/sWBPQrVvSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1ryeq1zRPANR0NEHJcfBScxYv3zGGmbF+z6J1Zg+BQTt/2vT1+4rfv7UhKBk2F5fF
	 s/3WcE1qF5WGxzylJBiJujUDXSFNPlOWvQLSsDEIXFfuiyj2wKMx8xu1cYwbluZAxn
	 OinDptuL9sqSth6BjLHfMHnIlQ0KXIeWLUBltnAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaxi Shen <shenxiaxi26@gmail.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org,
	syzbot+59e0101c430934bc9a36@syzkaller.appspotmail.com
Subject: [PATCH 6.6 241/386] ext4: fix timer use-after-free on failed mount
Date: Tue,  8 Oct 2024 14:08:06 +0200
Message-ID: <20241008115638.880779029@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

From: Xiaxi Shen <shenxiaxi26@gmail.com>

commit 0ce160c5bdb67081a62293028dc85758a8efb22a upstream.

Syzbot has found an ODEBUG bug in ext4_fill_super

The del_timer_sync function cancels the s_err_report timer,
which reminds about filesystem errors daily. We should
guarantee the timer is no longer active before kfree(sbi).

When filesystem mounting fails, the flow goes to failed_mount3,
where an error occurs when ext4_stop_mmpd is called, causing
a read I/O failure. This triggers the ext4_handle_error function
that ultimately re-arms the timer,
leaving the s_err_report timer active before kfree(sbi) is called.

Fix the issue by canceling the s_err_report timer after calling ext4_stop_mmpd.

Signed-off-by: Xiaxi Shen <shenxiaxi26@gmail.com>
Reported-and-tested-by: syzbot+59e0101c430934bc9a36@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=59e0101c430934bc9a36
Link: https://patch.msgid.link/20240715043336.98097-1-shenxiaxi26@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5659,8 +5659,8 @@ failed_mount3a:
 failed_mount3:
 	/* flush s_sb_upd_work before sbi destroy */
 	flush_work(&sbi->s_sb_upd_work);
-	del_timer_sync(&sbi->s_err_report);
 	ext4_stop_mmpd(sbi);
+	del_timer_sync(&sbi->s_err_report);
 	ext4_group_desc_free(sbi);
 failed_mount:
 	if (sbi->s_chksum_driver)


