Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741C51DF273;
	Wed, 19 Feb 2025 09:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957436; cv=none; b=Hk3gBxmWo45EO3yMJe6oVO4EAy+7jqoyQi+kMBNfE28AemvAyMWlfxJ1BcAEmh22FbG0fOxBPv9GZs9Ib9vk+KNNB+aW/abrv+VXqv/rHRUfzpkSc6IAF9pTOiVZH8XoRWJfy51tK6BRiTVUJFpGErDBccUU80KQ+L75yXXze+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957436; c=relaxed/simple;
	bh=DaLET7kZNtoy0BkNO/I7/XJPekCXuzAMPcaWqXwjgPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=udzx+4iPrAHHP07GNiAUTfHQpgN2FByYU334jIDsLVuTAWeHoceUbPrRuv998JME3qy2wMMe+KtEP8ALguAqIUZsFrIijz3hvNZILBrePvAuKNHfDIogKtOXxeFEKaUBHm1vfwBiEHtSQ63VFPoA6GZdT5AawEXxHGgsbnkA/+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y+l4l4cR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y+l4l4cR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF81CC4CEE7;
	Wed, 19 Feb 2025 09:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957436;
	bh=DaLET7kZNtoy0BkNO/I7/XJPekCXuzAMPcaWqXwjgPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y+l4l4cREBRHjZaO8y0y3F+n9cxsQp9SLOKjcnD1Zz4edvOXQQFdark2vO4hwv6Y1
	 vO3rOJ/PdDzt2kfZs7fcZ150sxYXKIPgBUaNhmV4DVb8BsKWKmeMP60WBuqZQyifMT
	 yRWUMYpdvBpbEBGw1u5TTNl8NYewnES4na7n85zE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Marshall <hubcap@omnibond.com>,
	syzbot+fc519d7875f2d9186c1f@syzkaller.appspotmail.com,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 494/578] orangefs: fix a oob in orangefs_debug_write
Date: Wed, 19 Feb 2025 09:28:18 +0100
Message-ID: <20250219082712.426814990@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Mike Marshall <hubcap@omnibond.com>

[ Upstream commit f7c848431632598ff9bce57a659db6af60d75b39 ]

I got a syzbot report: slab-out-of-bounds Read in
orangefs_debug_write... several people suggested fixes,
I tested Al Viro's suggestion and made this patch.

Signed-off-by: Mike Marshall <hubcap@omnibond.com>
Reported-by: syzbot+fc519d7875f2d9186c1f@syzkaller.appspotmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/orangefs/orangefs-debugfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/orangefs/orangefs-debugfs.c b/fs/orangefs/orangefs-debugfs.c
index 1b508f5433846..fa41db0884880 100644
--- a/fs/orangefs/orangefs-debugfs.c
+++ b/fs/orangefs/orangefs-debugfs.c
@@ -393,9 +393,9 @@ static ssize_t orangefs_debug_write(struct file *file,
 	 * Thwart users who try to jamb a ridiculous number
 	 * of bytes into the debug file...
 	 */
-	if (count > ORANGEFS_MAX_DEBUG_STRING_LEN + 1) {
+	if (count > ORANGEFS_MAX_DEBUG_STRING_LEN) {
 		silly = count;
-		count = ORANGEFS_MAX_DEBUG_STRING_LEN + 1;
+		count = ORANGEFS_MAX_DEBUG_STRING_LEN;
 	}
 
 	buf = kzalloc(ORANGEFS_MAX_DEBUG_STRING_LEN, GFP_KERNEL);
-- 
2.39.5



