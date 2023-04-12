Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581572F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:38:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D187CC433D2;
	Wed, 12 Apr 2023 08:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681288716;
	bh=8Hkgo7FUnyNf9m1qyjiOamo3ynyc/ExZ8y4m7GWoRWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qFCEOL4MVvlW7/LMTxHQ1nRV+UJ5uTRDYaatLa/Xv1icdimVju+5MO15+6R7L2gJR
	 s/uD58X3aiJ/0C05X/KU9l7YiUmCSEAh9tHPkOEgljKp+/d4OA1UuwraLSLLv+nzRY
	 sUIhLC9pvgKjiCm6L8HLnmOWXB6Rq0MVAJxmVDQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8ac3859139c685c4f597@syzkaller.appspotmail.com,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 5.15 82/93] fs: drop peer group ids under namespace lock
Date: Wed, 12 Apr 2023 10:34:23 +0200
Message-Id: <20230412082826.606461173@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
References: <20230412082823.045155996@linuxfoundation.org>
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
@@ -4121,9 +4121,9 @@ static int do_mount_setattr(struct path
 	unlock_mount_hash();
 
 	if (kattr->propagation) {
-		namespace_unlock();
 		if (err)
 			cleanup_group_ids(mnt, NULL);
+		namespace_unlock();
 	}
 
 	return err;


