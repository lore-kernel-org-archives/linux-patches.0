Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B01E8821
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 15:02:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5288C433EF;
	Fri, 10 Mar 2023 15:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678460572;
	bh=Ljwq8bY827BH8isU9XavIxjsZnWl+5a0r7JlOvRTxMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oqfAHN+b8AEr+OuuuzLIza2zsnE9GurmbBwO/FPw2dsAoOX2USpZM1nNXL8guL4va
	 Iyo+p2kmfrLc1VzgntuwOg/oJ3CxSZMLlVAazCX1ob/nlLyqJdUjZ7VJka6fbSEgyK
	 trPkfepf6gEVK4tFd4rGKvz47vXEVG9rBOkNXzAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+60f291a24acecb3c2bd5@syzkaller.appspotmail.com,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 5.10 349/529] udf: Do not bother merging very long extents
Date: Fri, 10 Mar 2023 14:38:12 +0100
Message-Id: <20230310133821.187514434@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jan Kara <jack@suse.cz>

commit 53cafe1d6d8ef9f93318e5bfccc0d24f27d41ced upstream.

When merging very long extents we try to push as much length as possible
to the first extent. However this is unnecessarily complicated and not
really worth the trouble. Furthermore there was a bug in the logic
resulting in corrupting extents in the file as syzbot reproducer shows.
So just don't bother with the merging of extents that are too long
together.

CC: stable@vger.kernel.org
Reported-by: syzbot+60f291a24acecb3c2bd5@syzkaller.appspotmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/inode.c |   19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1093,23 +1093,8 @@ static void udf_merge_extents(struct ino
 			blocksize - 1) >> blocksize_bits)))) {
 
 			if (((li->extLength & UDF_EXTENT_LENGTH_MASK) +
-				(lip1->extLength & UDF_EXTENT_LENGTH_MASK) +
-				blocksize - 1) & ~UDF_EXTENT_LENGTH_MASK) {
-				lip1->extLength = (lip1->extLength -
-						  (li->extLength &
-						   UDF_EXTENT_LENGTH_MASK) +
-						   UDF_EXTENT_LENGTH_MASK) &
-							~(blocksize - 1);
-				li->extLength = (li->extLength &
-						 UDF_EXTENT_FLAG_MASK) +
-						(UDF_EXTENT_LENGTH_MASK + 1) -
-						blocksize;
-				lip1->extLocation.logicalBlockNum =
-					li->extLocation.logicalBlockNum +
-					((li->extLength &
-						UDF_EXTENT_LENGTH_MASK) >>
-						blocksize_bits);
-			} else {
+			     (lip1->extLength & UDF_EXTENT_LENGTH_MASK) +
+			     blocksize - 1) <= UDF_EXTENT_LENGTH_MASK) {
 				li->extLength = lip1->extLength +
 					(((li->extLength &
 						UDF_EXTENT_LENGTH_MASK) +


