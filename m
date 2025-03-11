Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 845C325DB0D;
	Tue, 11 Mar 2025 15:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705846; cv=none; b=KG+eS/uV9ozmmLzikZR2sixcdvsULCvn36gg1e54WglaPS5Xoa5TOJ666Y1mynQqGHc6OopfjjuH7VlXxfYBMTlXlFWvIIavEMEVBGJX7VtG39N3+fk8kpbjeyVr3nL2xhlXN9imUcrZdEtiQpxOHz0gA4lLZFmrtyy4qjEGllw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705846; c=relaxed/simple;
	bh=0YjTmbSJnsZoUVrLXsiuJJ0/JAA/W+ytIvbjDXZOjxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EbhJ4MWxJMw3SZUDAgolfop1/Sx4t94pdIKOKopi5jAJDzZ+EduXk7mxypJjeCLdPsKvUJEubTS32VMveAxtwuut7Ie4eeZ5GFpvwWX/E/IzmU8oVyP4FgLME23IFINS4b3aoEU0TkAgGA9CkVkKDl1ukROOoP1Ezk/K5QolAZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BcZCgi2C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BcZCgi2C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D011C4CEE9;
	Tue, 11 Mar 2025 15:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705846;
	bh=0YjTmbSJnsZoUVrLXsiuJJ0/JAA/W+ytIvbjDXZOjxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BcZCgi2CYUS1jPG5DmvnEtBuZ944Vgq4N6c1/HpZ857JjCcDQjfE6PKhKx0qVvjhO
	 TC1FGpMG8a/tkYhEg6Qgqv7JjNAOLl7MBOSb32N+bXXyJykILrCHMH8UjZ0JcodzVL
	 2Z0OenmnnjB+PnL1BXDbQgj++U8IsRX5+zYqL9dM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Marshall <hubcap@omnibond.com>,
	syzbot+fc519d7875f2d9186c1f@syzkaller.appspotmail.com,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 175/328] orangefs: fix a oob in orangefs_debug_write
Date: Tue, 11 Mar 2025 15:59:05 +0100
Message-ID: <20250311145721.862945158@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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



