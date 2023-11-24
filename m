Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4720D364A0;
	Fri, 24 Nov 2023 18:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f1lZumbF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C99BDC433C8;
	Fri, 24 Nov 2023 18:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851546;
	bh=Cj8bRIWmgVn40EYdS+iUnRBT55C3/AihejT1nGIXqYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f1lZumbFJx4dhiO6vuaR7MD3z8+RR2OZIPizoeuyjBkKc+vYTqFU1kKILddhJtrHU
	 PSg/gBO1v8/XSgshhzRIjDOWXa5d+HQ3rJtykiA/fuc7haTUN1+nBGjDZ8cJm8gViZ
	 azAbUD5LhwOf0tzaBx06flD7qqgKnKb49503aU4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.5 466/491] ext4: add missed brelse in update_backups
Date: Fri, 24 Nov 2023 17:51:42 +0000
Message-ID: <20231124172038.633516484@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kemeng Shi <shikemeng@huaweicloud.com>

commit 9adac8b01f4be28acd5838aade42b8daa4f0b642 upstream.

add missed brelse in update_backups

Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Theodore Ts'o <tytso@mit.edu>
Link: https://lore.kernel.org/r/20230826174712.4059355-3-shikemeng@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/resize.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1186,8 +1186,10 @@ static void update_backups(struct super_
 			   ext4_group_first_block_no(sb, group));
 		BUFFER_TRACE(bh, "get_write_access");
 		if ((err = ext4_journal_get_write_access(handle, sb, bh,
-							 EXT4_JTR_NONE)))
+							 EXT4_JTR_NONE))) {
+			brelse(bh);
 			break;
+		}
 		lock_buffer(bh);
 		memcpy(bh->b_data, data, size);
 		if (rest)


