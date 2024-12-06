Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7D23B2BB;
	Fri,  6 Dec 2024 15:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498121; cv=none; b=IGQFsTs9441oS+L+cNg6fz4yTjyJJo4mULYhriZuawAS9CUnD5L4zOvvLsMrZClnxIDLos01p10qJpRXlLXQlmaB3mD16aZB1lLZn6Hu28Lab9Q9mcrq32WYbsmAqnhtvuCwZVEx0aYE0U7wAIm+/P/JnPm+ctKUoP98XwpIduY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498121; c=relaxed/simple;
	bh=Op9j1zFujLCrw7EajF+w1cgqf36Y7ONfN2gZDx0P+X4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lA5Ptwu/9c/rTxfZz6whYDKQ5QU6GhP8gp6ZszObcKduMsZcgtlqBweRawjcJ4smxoX/PKBzhChSBVF1LLSeK4S4Z+lo2E8ciTKnHN9Vo1Tl15BL1fR2X9EQKTbV9FR/uK97XW15zD176M5dlqi/3mojYcLY8rgMVCO/Z27zxdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KA+TAs4/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KA+TAs4/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0BABC4CED1;
	Fri,  6 Dec 2024 15:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498121;
	bh=Op9j1zFujLCrw7EajF+w1cgqf36Y7ONfN2gZDx0P+X4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KA+TAs4/ndYLObLIN5hM2nX3p+4p7njeqqcClYsTMcEXKHOvb2CI9ZP1+c9LA0K0v
	 Ja11NImYhEl2qN8BdE3EFtBzxxHhNXA+yFP8OZngtAAUI4sjdIecd8TUOBHNttQ+gJ
	 NRWw0R9FDEFNLzZL1Afy+YTMlQOKO7Mfj95xnLHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+01218003be74b5e1213a@syzkaller.appspotmail.com,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.6 493/676] exfat: fix uninit-value in __exfat_get_dentry_set
Date: Fri,  6 Dec 2024 15:35:12 +0100
Message-ID: <20241206143712.616595370@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

commit 02dffe9ab092fc4c8800aee68cb7eafd37a980c4 upstream.

There is no check if stream size and start_clu are invalid.
If start_clu is EOF cluster and stream size is 4096, It will
cause uninit value access. because ei->hint_femp.eidx could
be 128(if cluster size is 4K) and wrong hint will allocate
next cluster. and this cluster will be same with the cluster
that is allocated by exfat_extend_valid_size(). The previous
patch will check invalid start_clu, but for clarity, initialize
hint_femp.eidx to zero.

Cc: stable@vger.kernel.org
Reported-by: syzbot+01218003be74b5e1213a@syzkaller.appspotmail.com
Tested-by: syzbot+01218003be74b5e1213a@syzkaller.appspotmail.com
Reviewed-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exfat/namei.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/exfat/namei.c
+++ b/fs/exfat/namei.c
@@ -377,6 +377,7 @@ static int exfat_find_empty_entry(struct
 		if (ei->start_clu == EXFAT_EOF_CLUSTER) {
 			ei->start_clu = clu.dir;
 			p_dir->dir = clu.dir;
+			hint_femp.eidx = 0;
 		}
 
 		/* append to the FAT chain */


