Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A8CA24500A;
	Tue, 29 Apr 2025 17:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947100; cv=none; b=KAo9oYVae8gGiq0jF14Q5n2o9Dy5Rwn7IAp3aTBNDNk6n8nkmaOjoBY8Mbc92xv//wQhcYGkVZHCqOey7XagTFlhhF/xAmjqkwd+l/Rj48sir6M/bjXK/8AhUNjLMPOLRJ/9YpktTOSbazZUrWB6QKRHi6djlwqjbrUUPq+fOTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947100; c=relaxed/simple;
	bh=usob6uVd3HMgog6heIpVZfzLz14oUeaSav2gs7wlK38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LRfAlkO9n2VEfnYtJtsr94qVVXD7omq3K3bfy++ftA94WZXp3gTHZWF58IiDhTMV2tBvw6J27sBNDDo9/fm7liraLTGAqkNnm4cRb/PH7XYAO25PEJV8arqadOD2wut5vo8oXt4JFjgJtnrtH9noTFh0snm2Hxj1GE7HXIC09ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LNGHydBj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LNGHydBj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E56EC4CEE3;
	Tue, 29 Apr 2025 17:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947100;
	bh=usob6uVd3HMgog6heIpVZfzLz14oUeaSav2gs7wlK38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LNGHydBjJTlMKq6xcDpYROkTe1nEYLfML4ngMvjo9ZLiHNThvA15PwjPSE8MhbaIX
	 BM5A+EP3Sf5EFrSNHE2owlDWp7kV5zyVAoO21H+O0cxlsmXY28YXwo2fkVOflotjnv
	 gxq3rpbtDv+ltqmVWgJKj8oXo/xiK1TuCosdMSkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaxi Shen <shenxiaxi26@gmail.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org,
	Xiangyu Chen <xiangyu.chen@windriver.com>,
	He Zhe <zhe.he@windriver.com>,
	syzbot+59e0101c430934bc9a36@syzkaller.appspotmail.com
Subject: [PATCH 5.10 172/286] ext4: fix timer use-after-free on failed mount
Date: Tue, 29 Apr 2025 18:41:16 +0200
Message-ID: <20250429161114.964373721@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
User-Agent: quilt/0.68
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
[Minor context change fixed]
Signed-off-by: Xiangyu Chen <xiangyu.chen@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5185,8 +5185,8 @@ failed_mount_wq:
 failed_mount3a:
 	ext4_es_unregister_shrinker(sbi);
 failed_mount3:
-	del_timer_sync(&sbi->s_err_report);
 	ext4_stop_mmpd(sbi);
+	del_timer_sync(&sbi->s_err_report);
 failed_mount2:
 	rcu_read_lock();
 	group_desc = rcu_dereference(sbi->s_group_desc);


