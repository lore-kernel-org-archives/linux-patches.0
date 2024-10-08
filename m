Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E82189910;
	Tue,  8 Oct 2024 12:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392350; cv=none; b=RQmcMFDL37OtzIUQZg4kLtpkDdqBOT43xgUvKOZLqG4fLP8J47SzRlROAV2M3qtPAHM0802IvYwgj3Cl+KDvPvtAesI4apKQEvpZ8SIKOSv1tYGNK9qX/ut1LLJHtOB+eNM/Ndfw5q99+fHPTEG4P7/mLCNunQM9haP0OiW/11M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392350; c=relaxed/simple;
	bh=fgD4nwGKsICrMuU3TlipGk6dKlcCXqQzQWr+f+1uhMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rDu27DAuQeGvfLv4/F9xMveK8Xf+uLb/SLcbQ+/TCxFNSXNLfFrfkoBi+PJifunQ66wHzhYAGAwbPbX0vTVpT8lbuHC5VgMijXXSOQK5MSvyBTc1VnRvH2W7+TXgs0QD1Qh3CMVBy5qkZnbT/EVK1kz6kRMeQ1nVdc25yawOVFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VVPHQyK7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VVPHQyK7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD60AC4CEC7;
	Tue,  8 Oct 2024 12:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392350;
	bh=fgD4nwGKsICrMuU3TlipGk6dKlcCXqQzQWr+f+1uhMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VVPHQyK77lT7TzMZK91TwxCWRN7Sn0pf60Fx73zPI0cLTswuyQzj9rvl6pFyqjoGZ
	 6q/WlYhVCqAqGzE1P0/3nhsXZOhen8lKsj/g4fky5/P+4YU0SqcOLmmv5S31ksN9GX
	 Aakbl+O8j2oQSAjgDh+ViLHi/t3QNHGVcdqjA4iw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaxi Shen <shenxiaxi26@gmail.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org,
	syzbot+59e0101c430934bc9a36@syzkaller.appspotmail.com
Subject: [PATCH 6.11 390/558] ext4: fix timer use-after-free on failed mount
Date: Tue,  8 Oct 2024 14:07:00 +0200
Message-ID: <20241008115717.632075576@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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
@@ -5635,8 +5635,8 @@ failed_mount3a:
 failed_mount3:
 	/* flush s_sb_upd_work before sbi destroy */
 	flush_work(&sbi->s_sb_upd_work);
-	del_timer_sync(&sbi->s_err_report);
 	ext4_stop_mmpd(sbi);
+	del_timer_sync(&sbi->s_err_report);
 	ext4_group_desc_free(sbi);
 failed_mount:
 	if (sbi->s_chksum_driver)


