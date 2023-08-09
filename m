Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37461774C
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:10:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 624AAC433C7;
	Wed,  9 Aug 2023 11:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691579447;
	bh=EQ4ZQNWXbrWOvn9E46s0iU/rYrE5RbLdcOQhsusyyiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZkB/askh2YI0HEQcUtq5HP4+0BqSpkCezYqrD5Lg9U7S4deeT1vAbRJjyo0yoHiKj
	 R7TTEw9nZuEgjRgVhItxQY48c8S4LyVGSof9Wv1MRnB2AUOPn98UFqwr9mCjqmW0Ew
	 pfdSncqnzIP4MvSUoge+9pwNhbkSGFD6rLitngIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+aad58150cbc64ba41bdc@syzkaller.appspotmail.com,
	Prince Kumar Maurya <princekumarmaurya06@gmail.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 4.14 199/204] fs/sysv: Null check to prevent null-ptr-deref bug
Date: Wed,  9 Aug 2023 12:42:17 +0200
Message-ID: <20230809103649.158452680@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.552405807@linuxfoundation.org>
References: <20230809103642.552405807@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Prince Kumar Maurya <princekumarmaurya06@gmail.com>

commit ea2b62f305893992156a798f665847e0663c9f41 upstream.

sb_getblk(inode->i_sb, parent) return a null ptr and taking lock on
that leads to the null-ptr-deref bug.

Reported-by: syzbot+aad58150cbc64ba41bdc@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=aad58150cbc64ba41bdc
Signed-off-by: Prince Kumar Maurya <princekumarmaurya06@gmail.com>
Message-Id: <20230531013141.19487-1-princekumarmaurya06@gmail.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/sysv/itree.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/sysv/itree.c
+++ b/fs/sysv/itree.c
@@ -145,6 +145,10 @@ static int alloc_branch(struct inode *in
 		 */
 		parent = block_to_cpu(SYSV_SB(inode->i_sb), branch[n-1].key);
 		bh = sb_getblk(inode->i_sb, parent);
+		if (!bh) {
+			sysv_free_block(inode->i_sb, branch[n].key);
+			break;
+		}
 		lock_buffer(bh);
 		memset(bh->b_data, 0, blocksize);
 		branch[n].bh = bh;


