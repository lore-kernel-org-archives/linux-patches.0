Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0FAD1CEE8E;
	Tue,  8 Oct 2024 12:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390687; cv=none; b=rk7F0sg545MtpzIiMdbZdT7peauCBa93b/eezOc6apR7hlnGE9/6+GqcYLUO+YG2QbvCzNfcBFQJgMiHXqMXpgWe/H2qRpSvNXqblCRkvbcBgkj95NIFqfldHHouq0rJeHZMsYqqac5olIZMYm/QTXd+iUtYPkxKN3I3VPSHYnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390687; c=relaxed/simple;
	bh=FGu6DRva7wmifzA8g5CsoUeUoj2lSorOq/O74qvIexk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mLPmsBz5PlCppPelKG05ZR6r8oXoFcYI+/6BvLPX6EgOF5EysTma+rl+9/2XRKwa0sxeG60VJsGOL6NT1dJ3fqcF7XeYFkjX1EIZDS47ISL6chyCsSYRmB26vbUGbtW3Q5j1ZlkEblW31rYSopJZovProMiS2qsEnd0N3uu559E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XOUytV8O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XOUytV8O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36A83C4CEC7;
	Tue,  8 Oct 2024 12:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390687;
	bh=FGu6DRva7wmifzA8g5CsoUeUoj2lSorOq/O74qvIexk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XOUytV8O+q8mMVUdeh2kAMLM5Kj+vF/XLak1w5ShpfNwk6W0bVvJWUPtTnPlVe1sj
	 vABEWXKClrurrcNMvDnOzKRew1mWwkdPTMNeDJ0Dnr/O57bF1pOfqfr1aLwX7BAhud
	 7oZIzlThSWdRqpUMuDC0Y/phuX9OyseuBV9UrcuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaxi Shen <shenxiaxi26@gmail.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org,
	syzbot+59e0101c430934bc9a36@syzkaller.appspotmail.com
Subject: [PATCH 6.10 332/482] ext4: fix timer use-after-free on failed mount
Date: Tue,  8 Oct 2024 14:06:35 +0200
Message-ID: <20241008115701.491594767@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5633,8 +5633,8 @@ failed_mount3a:
 failed_mount3:
 	/* flush s_sb_upd_work before sbi destroy */
 	flush_work(&sbi->s_sb_upd_work);
-	del_timer_sync(&sbi->s_err_report);
 	ext4_stop_mmpd(sbi);
+	del_timer_sync(&sbi->s_err_report);
 	ext4_group_desc_free(sbi);
 failed_mount:
 	if (sbi->s_chksum_driver)


