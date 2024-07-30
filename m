Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F0671A76D3;
	Tue, 30 Jul 2024 17:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360080; cv=none; b=Ig011wQBVnI0tghOEgjf4cb8jR5Enmfhv90FpfGSoDbVQcOS+pjFrXOqtbfVtxMgmwvaFC21lF0be46ZxTgvfqtw2nPJlxQzwtnnVCnra75tNmbtMRSw0v2MSKfLIWvey/Dw93DVOPLstE78xIIfIJ6mc65h5AZcPRFaWSHebjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360080; c=relaxed/simple;
	bh=0G3flut2/Gf9IIN+KtaM7C0X3QviYWMNkRy9piriT48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UY8A3LlyegCjuBmH5a5o2abBoedt281OfrfTfiPXzKvD6IyEkDWiACU6QadDAWGi4icodiYn5r1GJvBbgoLUCKEIfbaJFjSq8TlPfDORPqthjx7CWKay2YT6InBlk0hAx0rB9UHotAboUZ0J/6K+O0017WvHI4qDy2+7aRPh3d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FWZTmonf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FWZTmonf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A837AC32782;
	Tue, 30 Jul 2024 17:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360080;
	bh=0G3flut2/Gf9IIN+KtaM7C0X3QviYWMNkRy9piriT48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FWZTmonfRgr6LfJOyY8ZORbAeM0lHYAg64DSDLAvzUR7O8Joqxp1L/A05Pb3YR1EZ
	 k62ImzYKC5KT+KBWvgh1INq++iK8r/ptsET/f08GH6Y76SfJtgWsHRiMjNNO/51uXL
	 zSEg0K+cfciK9ga8j7Qtm8WQsGAXmWbpPyrbKn4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5f682cd029581f9edfd1@syzkaller.appspotmail.com,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 6.10 589/809] udf: Avoid using corrupted block bitmap buffer
Date: Tue, 30 Jul 2024 17:47:45 +0200
Message-ID: <20240730151748.095331625@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit a90d4471146de21745980cba51ce88e7926bcc4f upstream.

When the filesystem block bitmap is corrupted, we detect the corruption
while loading the bitmap and fail the allocation with error. However the
next allocation from the same bitmap will notice the bitmap buffer is
already loaded and tries to allocate from the bitmap with mixed results
(depending on the exact nature of the bitmap corruption). Fix the
problem by using BH_verified bit to indicate whether the bitmap is valid
or not.

Reported-by: syzbot+5f682cd029581f9edfd1@syzkaller.appspotmail.com
CC: stable@vger.kernel.org
Link: https://patch.msgid.link/20240617154201.29512-2-jack@suse.cz
Fixes: 1e0d4adf17e7 ("udf: Check consistency of Space Bitmap Descriptor")
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/balloc.c |   15 +++++++++++++--
 fs/udf/super.c  |    3 ++-
 2 files changed, 15 insertions(+), 3 deletions(-)

--- a/fs/udf/balloc.c
+++ b/fs/udf/balloc.c
@@ -64,8 +64,12 @@ static int read_block_bitmap(struct supe
 	}
 
 	for (i = 0; i < count; i++)
-		if (udf_test_bit(i + off, bh->b_data))
+		if (udf_test_bit(i + off, bh->b_data)) {
+			bitmap->s_block_bitmap[bitmap_nr] =
+							ERR_PTR(-EFSCORRUPTED);
+			brelse(bh);
 			return -EFSCORRUPTED;
+		}
 	return 0;
 }
 
@@ -81,8 +85,15 @@ static int __load_block_bitmap(struct su
 			  block_group, nr_groups);
 	}
 
-	if (bitmap->s_block_bitmap[block_group])
+	if (bitmap->s_block_bitmap[block_group]) {
+		/*
+		 * The bitmap failed verification in the past. No point in
+		 * trying again.
+		 */
+		if (IS_ERR(bitmap->s_block_bitmap[block_group]))
+			return PTR_ERR(bitmap->s_block_bitmap[block_group]);
 		return block_group;
+	}
 
 	retval = read_block_bitmap(sb, bitmap, block_group, block_group);
 	if (retval < 0)
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -336,7 +336,8 @@ static void udf_sb_free_bitmap(struct ud
 	int nr_groups = bitmap->s_nr_groups;
 
 	for (i = 0; i < nr_groups; i++)
-		brelse(bitmap->s_block_bitmap[i]);
+		if (!IS_ERR_OR_NULL(bitmap->s_block_bitmap[i]))
+			brelse(bitmap->s_block_bitmap[i]);
 
 	kvfree(bitmap);
 }


