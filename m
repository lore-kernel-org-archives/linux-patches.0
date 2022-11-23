Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23DE17B
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 08:57:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B8EAC433D7;
	Wed, 23 Nov 2022 08:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669193843;
	bh=qN2kHtrKdNxXqy5f+2fE+D32x9gwI09D/dhNa7yXKrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CMmOX5eyz0Q1J5v7WABVA3QTdXviAEzyR3yhcRiEBn3uBmks5bflalTZZ5Hh7B6KY
	 ZTQ7jYoov2VrEqVeW50FjPHOcSZAXyRgjVCXLPrxXlBFMJsbVlB0rACQXPhvsIT+OT
	 rsR+G5o15jZ2OlceZAQWKtKxv0kUAKLbaEROK+y8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hawkins Jiawei <yin31149@gmail.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Anton Altaparmakov <anton@tuxera.com>,
	"chenxiaosong (A)" <chenxiaosong2@huawei.com>,
	syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4.9 76/76] ntfs: check overflow when iterating ATTR_RECORDs
Date: Wed, 23 Nov 2022 09:51:15 +0100
Message-Id: <20221123084549.236780815@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084546.742331901@linuxfoundation.org>
References: <20221123084546.742331901@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hawkins Jiawei <yin31149@gmail.com>

commit 63095f4f3af59322bea984a6ae44337439348fe0 upstream.

Kernel iterates over ATTR_RECORDs in mft record in ntfs_attr_find().
Because the ATTR_RECORDs are next to each other, kernel can get the next
ATTR_RECORD from end address of current ATTR_RECORD, through current
ATTR_RECORD length field.

The problem is that during iteration, when kernel calculates the end
address of current ATTR_RECORD, kernel may trigger an integer overflow bug
in executing `a = (ATTR_RECORD*)((u8*)a + le32_to_cpu(a->length))`.  This
may wrap, leading to a forever iteration on 32bit systems.

This patch solves it by adding some checks on calculating end address
of current ATTR_RECORD during iteration.

Link: https://lkml.kernel.org/r/20220831160935.3409-4-yin31149@gmail.com
Link: https://lore.kernel.org/all/20220827105842.GM2030@kadam/
Signed-off-by: Hawkins Jiawei <yin31149@gmail.com>
Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Anton Altaparmakov <anton@tuxera.com>
Cc: chenxiaosong (A) <chenxiaosong2@huawei.com>
Cc: syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs/attrib.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/ntfs/attrib.c
+++ b/fs/ntfs/attrib.c
@@ -631,6 +631,14 @@ static int ntfs_attr_find(const ATTR_TYP
 			return -ENOENT;
 		if (unlikely(!a->length))
 			break;
+
+		/* check whether ATTR_RECORD's length wrap */
+		if ((u8 *)a + le32_to_cpu(a->length) < (u8 *)a)
+			break;
+		/* check whether ATTR_RECORD's length is within bounds */
+		if ((u8 *)a + le32_to_cpu(a->length) > mrec_end)
+			break;
+
 		if (a->type != type)
 			continue;
 		/*


