Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A06CE6FB4
	for <patches@lists.linux.dev>; Mon, 19 Dec 2022 19:25:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23F28C433EF;
	Mon, 19 Dec 2022 19:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1671477937;
	bh=T6ogtEA/k+38oJHMiRWvj7T+7+jE5E9D0h7SCn0qiRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wWnf0qJFwLwn4262QzUXrIwJUZgqRv/udxJMpB99v3RKTMTdBHBUMsH8pltr+qMxJ
	 fsMkbSqduOJMVPv72FjuzncA6Y2gxnR6288Sg1C+HrIp/LQjYy5FL1AmtyUZ+ttHRg
	 zqXQGecpF9wrJFmuBbuEcUZPN3veOvFoZ8z37ZEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 6.0 12/28] udf: Do not bother looking for prealloc extents if i_lenExtents matches i_size
Date: Mon, 19 Dec 2022 20:22:59 +0100
Message-Id: <20221219182944.703887592@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221219182944.179389009@linuxfoundation.org>
References: <20221219182944.179389009@linuxfoundation.org>
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

commit 6ad53f0f71c52871202a7bf096feb2c59db33fc5 upstream.

If rounded block-rounded i_lenExtents matches block rounded i_size,
there are no preallocation extents. Do not bother walking extent linked
list.

CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/truncate.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/udf/truncate.c
+++ b/fs/udf/truncate.c
@@ -127,9 +127,10 @@ void udf_discard_prealloc(struct inode *
 	uint64_t lbcount = 0;
 	int8_t etype = -1, netype;
 	struct udf_inode_info *iinfo = UDF_I(inode);
+	int bsize = 1 << inode->i_blkbits;
 
 	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB ||
-	    inode->i_size == iinfo->i_lenExtents)
+	    ALIGN(inode->i_size, bsize) == ALIGN(iinfo->i_lenExtents, bsize))
 		return;
 
 	epos.block = iinfo->i_location;


