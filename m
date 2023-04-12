Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C7129AB
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:51:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD828C4339B;
	Wed, 12 Apr 2023 08:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289470;
	bh=laj6jwC4AiSpDhUVdtfTNlfua5Z1cJRjWek8a/kh/TU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WoT3wB8fnJMHtGlWvFho56ZAiuSv5WepGZ12fwFivhrxDYKC50oTgjyejUykn4xmi
	 cvJ1nh5HftjRifKJ7lZLIy39N0vdwC7TjqAHyoFm44i/xZKkLJw1GIo4c9E+5VCK0a
	 x/WvUvUpvk/sez2y2YLIh8LCvrBc3Axu4jnut5SU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8ac3859139c685c4f597@syzkaller.appspotmail.com,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.2 111/173] fs: drop peer group ids under namespace lock
Date: Wed, 12 Apr 2023 10:33:57 +0200
Message-Id: <20230412082842.569052139@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christian Brauner <brauner@kernel.org>

commit cb2239c198ad9fbd5aced22cf93e45562da781eb upstream.

When cleaning up peer group ids in the failure path we need to make sure
to hold on to the namespace lock. Otherwise another thread might just
turn the mount from a shared into a non-shared mount concurrently.

Link: https://lore.kernel.org/lkml/00000000000088694505f8132d77@google.com
Fixes: 2a1867219c7b ("fs: add mount_setattr()")
Reported-by: syzbot+8ac3859139c685c4f597@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org # 5.12+
Message-Id: <20230330-vfs-mount_setattr-propagation-fix-v1-1-37548d91533b@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/namespace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -4286,9 +4286,9 @@ out:
 	unlock_mount_hash();
 
 	if (kattr->propagation) {
-		namespace_unlock();
 		if (err)
 			cleanup_group_ids(mnt, NULL);
+		namespace_unlock();
 	}
 
 	return err;


