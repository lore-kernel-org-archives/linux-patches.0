Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3976533E9;
	Fri, 24 Nov 2023 19:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P90Fpwhg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD6E2C433C7;
	Fri, 24 Nov 2023 19:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852486;
	bh=Z3BLflQK3cRAO7lJ1CC+Dz6k3Ue0bAPrG+9eMli8w8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P90Fpwhg+djyoCbNH7ykO8iHBilQOLfEeNFeCxqEYIQQTH3Sur6a3IH+ysLbAJ5cx
	 2q+hoCSqnHAoM9SY5FSU1jTeYKVKzaFzawSfz8vMCDxeY46+Wyx77l4jkEXej/utYn
	 233XDjxhdCTzI6ZwMCVa8OyPbv+m4cOJY+4eqMkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.1 355/372] ext4: add missed brelse in update_backups
Date: Fri, 24 Nov 2023 17:52:22 +0000
Message-ID: <20231124172022.163341188@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


