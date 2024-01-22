Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8155464CF2;
	Tue, 23 Jan 2024 00:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971531; cv=none; b=G+8/parhrpK2yLxKtq7v4ZzJGU6b5eovK5jj1CbNLLGSIsLEAdO8rG+/LKMAysjrPApZzUDcQr3zG96rg4N25iq4mdorG+23aDxGUy52k13Z4FxG9p80pf1bwOq9oCh4YUc+yNL2ABQ+lTZc57LfKlv2+xV9j4HankiS0JH9i7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971531; c=relaxed/simple;
	bh=rkVM3kS7wo3koKAtgz/jyoXPpnMMf7nCEhci2SeoV/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OCoJsz1AlvPLc5U6BoS6b+O9oio8gz1yzlK1oOP0y2FYZmpGKMk4xOXaV7tq8/PJ+3HrGKQcz54Xw1xxYGbHHHRhAFbhVLNLA8+iCgXJ6zcTbq+w6gTuOxlAl2JZIbaNjnTJQDkDP76w5bmO5auk8LhcCcAV5TNNlMF3/foUhOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2jcHbffb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2jcHbffb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 427FAC433C7;
	Tue, 23 Jan 2024 00:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971531;
	bh=rkVM3kS7wo3koKAtgz/jyoXPpnMMf7nCEhci2SeoV/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2jcHbffbSjI9zrFvwCgPHs/9Pf768atCdT3EX94IqUWATc+zaOs/DxvnfVlg25Oil
	 /Pax0QKH0cmXztjiQXmSJgCRSXPykwa1ZHXaIvPykb4RGlu/zi24W48n89uUPY17sh
	 GOcNOWvPqSnDAIOfSDq8IdYmCm6dvPwKfx75ZcYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 167/286] f2fs: fix to check compress file in f2fs_move_file_range()
Date: Mon, 22 Jan 2024 15:57:53 -0800
Message-ID: <20240122235738.607069693@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit fb9b65340c818875ea86464faf3c744bdce0055c ]

f2fs_move_file_range() doesn't support migrating compressed cluster
data, let's add the missing check condition and return -EOPNOTSUPP
for the case until we support it.

Fixes: 4c8ff7095bef ("f2fs: support data compression")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 4e6b93f16758..98960c8d72c0 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2816,6 +2816,11 @@ static int f2fs_move_file_range(struct file *file_in, loff_t pos_in,
 			goto out;
 	}
 
+	if (f2fs_compressed_file(src) || f2fs_compressed_file(dst)) {
+		ret = -EOPNOTSUPP;
+		goto out_unlock;
+	}
+
 	ret = -EINVAL;
 	if (pos_in + len > src->i_size || pos_in + len < pos_in)
 		goto out_unlock;
-- 
2.43.0



