Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA5230FA0
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:17:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6924C433AB;
	Wed, 20 Sep 2023 12:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212226;
	bh=i63ylnEfUPVft4CSBAHBXceXdY7IEcYiqOypg3Ajf9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GgZ6n/L9a6Kb3hcdKAyf0YFzqan3n/KpuFtNapTkTeBdwsLN5uIZR7YqkLXcRzr7e
	 bEv8hiTYDALldXlaGOuudLR+eFY905HHDvajFCP9WqXFP6var50cv/lwknjkOh52UW
	 sjn3xHEB4a/8YX6b7aLD9V8e8RXPFTZZP1a0qh7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Tom Rix <trix@redhat.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 4.19 196/273] udf: initialize newblock to 0
Date: Wed, 20 Sep 2023 13:30:36 +0200
Message-ID: <20230920112852.559679370@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112846.440597133@linuxfoundation.org>
References: <20230920112846.440597133@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Rix <trix@redhat.com>

commit 23970a1c9475b305770fd37bebfec7a10f263787 upstream.

The clang build reports this error
fs/udf/inode.c:805:6: error: variable 'newblock' is used uninitialized whenever 'if' condition is true [-Werror,-Wsometimes-uninitialized]
        if (*err < 0)
            ^~~~~~~~
newblock is never set before error handling jump.
Initialize newblock to 0 and remove redundant settings.

Fixes: d8b39db5fab8 ("udf: Handle error when adding extent to a file")
Reported-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Tom Rix <trix@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Message-Id: <20221230175341.1629734-1-trix@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/inode.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -689,7 +689,7 @@ static sector_t inode_getblk(struct inod
 	struct kernel_lb_addr eloc, tmpeloc;
 	int c = 1;
 	loff_t lbcount = 0, b_off = 0;
-	udf_pblk_t newblocknum, newblock;
+	udf_pblk_t newblocknum, newblock = 0;
 	sector_t offset = 0;
 	int8_t etype;
 	struct udf_inode_info *iinfo = UDF_I(inode);
@@ -792,7 +792,6 @@ static sector_t inode_getblk(struct inod
 		ret = udf_do_extend_file(inode, &prev_epos, laarr, hole_len);
 		if (ret < 0) {
 			*err = ret;
-			newblock = 0;
 			goto out_free;
 		}
 		c = 0;
@@ -855,7 +854,6 @@ static sector_t inode_getblk(struct inod
 				goal, err);
 		if (!newblocknum) {
 			*err = -ENOSPC;
-			newblock = 0;
 			goto out_free;
 		}
 		if (isBeyondEOF)


