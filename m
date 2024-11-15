Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 039C4185924;
	Fri, 15 Nov 2024 06:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653675; cv=none; b=qC+tXkzCBuYIzDekx8jWCANB3Zc1VcXkrViH8T3a9E9j+cAx92KvJKYBbDgChj00MiASxJb+78+3urKABarXWlEyMLGk/pimUEATDQXpi8RRi0hZ8u8l95VC7LaxNgPSHp697EkvYIqGgZ63mDfddQK2YTaKm1MIfhPg5VCLhTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653675; c=relaxed/simple;
	bh=4AmwZWPeyAmPepwUeBC3RvHfmewhmHBogXNySoOPFT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EVPsd9jAEf3Slw1VhdzNp/UqpdFYuOYVh9ZQTtZ/TMKWdee2F+lhogBWbzFhmQfYO8IT9T4qOGAr4ivBJttZKHqpJ27p8HA5fZzFRGUrCLx6BfYyYPBwv2M9fQJlxdXq+UZbd7RPIVhZNIpV81XYXkMSpFEjD4hidwUU+SQ2vJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aiggZYJV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aiggZYJV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6171DC4CECF;
	Fri, 15 Nov 2024 06:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653674;
	bh=4AmwZWPeyAmPepwUeBC3RvHfmewhmHBogXNySoOPFT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aiggZYJVWaFRoUF9euP367YWgeF/iMb7pahvMQvwpgfifDRjpMMP/uWEp/L7WwcFP
	 1sSiQ7iN4rPvGJv9/3YdhJMaBKzGLqYoMQBtLldgKFxWr6TdjkD687Ibxs2CEk/vfT
	 9/mH4ywgn+NLZLiTv3k0qaaVIMvdgmaF8PNOPNR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaxi Shen <shenxiaxi26@gmail.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org,
	Xiangyu Chen <xiangyu.chen@windriver.com>,
	syzbot+59e0101c430934bc9a36@syzkaller.appspotmail.com
Subject: [PATCH 6.1 34/39] ext4: fix timer use-after-free on failed mount
Date: Fri, 15 Nov 2024 07:38:44 +0100
Message-ID: <20241115063723.838050061@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.599985562@linuxfoundation.org>
References: <20241115063722.599985562@linuxfoundation.org>
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
Signed-off-by: Xiangyu Chen <xiangyu.chen@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5617,8 +5617,8 @@ failed_mount3a:
 failed_mount3:
 	/* flush s_error_work before sbi destroy */
 	flush_work(&sbi->s_error_work);
-	del_timer_sync(&sbi->s_err_report);
 	ext4_stop_mmpd(sbi);
+	del_timer_sync(&sbi->s_err_report);
 	ext4_group_desc_free(sbi);
 failed_mount:
 	if (sbi->s_chksum_driver)


