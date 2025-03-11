Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1448925F782;
	Tue, 11 Mar 2025 15:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707012; cv=none; b=LxbMbqurDM5xb6j38gOx86sfSYfyrEQ/Ok8SVkogGejaHgzP086rbFnQyE4Cu8dwiUhIi7CDP1wpdZYQVsS6FEj9ZxVTOPMUn0lp/9q+xx/x/3LttQ5iiGWopaqkX7o58CvYE03FSURzRXBRbzh8x2QUHTzAu2Og2kZbEfczbEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707012; c=relaxed/simple;
	bh=PsvQaLu8mtfMgCHnTyPG1rgBcIn3Y9ajB5oZhvcPsf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TWN56/d5OGeDCO26ATrYMIKU4zkvSpGqYTKsu1rIdvbCMI+/58YNOnOOZqglDGLokyIH3Pu7PbwicuZGK/h2FEYMJzxSXjzg7bGH8M0QcFFCto/8XXwyWiJzhbkv8PbhYreX7o5yd6VGOKCacWWq8qsmJsYY5cxGLndln3zLiUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iw9r5EXu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iw9r5EXu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 101A3C4CEE9;
	Tue, 11 Mar 2025 15:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707011;
	bh=PsvQaLu8mtfMgCHnTyPG1rgBcIn3Y9ajB5oZhvcPsf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Iw9r5EXuDxQy3z4xaJpavxkw2GLOm9Ogrfx3DB17ygMG/L6loHNDb/1TPZEp6Ppjl
	 yBYn9M93dWqwbZBX/IfEDa2QBjC/qVcVjCbPeMgdD2QV+tXIAyYbiXw+ZLIcmhcIIN
	 6Xmc+9gSpnt5Ks2znaZbjzHgQ0twzfzgWJhZIqek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Marshall <hubcap@omnibond.com>,
	syzbot+fc519d7875f2d9186c1f@syzkaller.appspotmail.com,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 242/462] orangefs: fix a oob in orangefs_debug_write
Date: Tue, 11 Mar 2025 15:58:28 +0100
Message-ID: <20250311145807.929652325@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



