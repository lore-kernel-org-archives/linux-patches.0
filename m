Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020341607AA;
	Mon,  6 Jan 2025 15:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177556; cv=none; b=IPK/6O6NiP8Xszqwj3GKpDk8H72UUJLdIUHW5/UXwCDtApM7fWKqQhyLlcqmqjozh0tid4JdIY3Fs4qFbp/F5rXGzfDTwoMx/3eJ9Bv0wInLbRaq1bvSEdSQ1XOv//JZa1vTNxcfeRBgHEnCGUP2uw71UKnzB01A1MeKEhCQ7pM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177556; c=relaxed/simple;
	bh=ROlbMpSVcyif2jip0gJ6TdDDZWLXIpsJ7Y9WUgMhoAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H+s01cnc9dPH7AkJvXY0flBqlazfCkAmLJ9IIUmJW/S9md9GO/3f+kQAswK3Y7lxz65RT8bObrM+j9vmnUSuYes/MXODE1ffK3IW9HrDn8GP9x40UzMpox5g6xRC5HShCahBBVi4nr47IuIlvO15tCX/grYXTtOljWtS7J6E68U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pJNE8Wxs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pJNE8Wxs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09FDCC4CED6;
	Mon,  6 Jan 2025 15:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177554;
	bh=ROlbMpSVcyif2jip0gJ6TdDDZWLXIpsJ7Y9WUgMhoAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pJNE8WxssyOwcUUO7TDSxr3fGl1FxCQBdMYKLLMKDuSMcDRGIx9nfp83NCW6rgPDv
	 4VJn9clQQ5n/JiKVg/HS2G0r10RH3Q6/7QokywFboeuXfGxnAdeg4/KJLOD+s54KX7
	 6skOVk7p3kIVLJDicLiBx3+7oFkdbz2oxKKasvKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dennis Lam <dennis.lamerice@gmail.com>,
	syzbot+d173bf8a5a7faeede34c@syzkaller.appspotmail.com,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 202/222] ocfs2: fix slab-use-after-free due to dangling pointer dqi_priv
Date: Mon,  6 Jan 2025 16:16:46 +0100
Message-ID: <20250106151158.408429128@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dennis Lam <dennis.lamerice@gmail.com>

commit 5f3fd772d152229d94602bca243fbb658068a597 upstream.

When mounting ocfs2 and then remounting it as read-only, a
slab-use-after-free occurs after the user uses a syscall to
quota_getnextquota.  Specifically, sb_dqinfo(sb, type)->dqi_priv is the
dangling pointer.

During the remounting process, the pointer dqi_priv is freed but is never
set as null leaving it to be accessed.  Additionally, the read-only option
for remounting sets the DQUOT_SUSPENDED flag instead of setting the
DQUOT_USAGE_ENABLED flags.  Moreover, later in the process of getting the
next quota, the function ocfs2_get_next_id is called and only checks the
quota usage flags and not the quota suspended flags.

To fix this, I set dqi_priv to null when it is freed after remounting with
read-only and put a check for DQUOT_SUSPENDED in ocfs2_get_next_id.

[akpm@linux-foundation.org: coding-style cleanups]
Link: https://lkml.kernel.org/r/20241218023924.22821-2-dennis.lamerice@gmail.com
Fixes: 8f9e8f5fcc05 ("ocfs2: Fix Q_GETNEXTQUOTA for filesystem without quotas")
Signed-off-by: Dennis Lam <dennis.lamerice@gmail.com>
Reported-by: syzbot+d173bf8a5a7faeede34c@syzkaller.appspotmail.com
Tested-by: syzbot+d173bf8a5a7faeede34c@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6731d26f.050a0220.1fb99c.014b.GAE@google.com/T/
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/quota_global.c |    2 +-
 fs/ocfs2/quota_local.c  |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -881,7 +881,7 @@ static int ocfs2_get_next_id(struct supe
 	int status = 0;
 
 	trace_ocfs2_get_next_id(from_kqid(&init_user_ns, *qid), type);
-	if (!sb_has_quota_loaded(sb, type)) {
+	if (!sb_has_quota_active(sb, type)) {
 		status = -ESRCH;
 		goto out;
 	}
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -864,6 +864,7 @@ out:
 	brelse(oinfo->dqi_libh);
 	brelse(oinfo->dqi_lqi_bh);
 	kfree(oinfo);
+	info->dqi_priv = NULL;
 	return status;
 }
 


