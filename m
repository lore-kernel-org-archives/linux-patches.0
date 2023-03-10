Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A076E847E
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 13:49:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C6A5C4339B;
	Fri, 10 Mar 2023 13:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678456179;
	bh=mLXpiAQQnlkiM6aOis+zswJlh5GVSsdbzis7geFirCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R/f5LhmIrEd+4EV8a9TSvgp2tIrlNbh+13et+hfPf0j3j1VoNUSHhzscg/M0MEZa/
	 GTCwUqf1vJzfqFcHRNG4IzgoYjbwefsijDKQkpE9jh8wlCdGSVopdQFQ+JoNdQyW9m
	 iq+oF1wwTN8dXCosyVWWZYkEwqsLm8uxMZuuV3VE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+60f291a24acecb3c2bd5@syzkaller.appspotmail.com,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 4.14 108/193] udf: Do not bother merging very long extents
Date: Fri, 10 Mar 2023 14:38:10 +0100
Message-Id: <20230310133714.882440546@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133710.926811681@linuxfoundation.org>
References: <20230310133710.926811681@linuxfoundation.org>
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
@@ -1089,23 +1089,8 @@ static void udf_merge_extents(struct ino
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


