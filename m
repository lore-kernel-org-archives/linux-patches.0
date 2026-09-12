Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B8C1A8F7B;
	Sat, 12 Sep 2026 10:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207577; cv=none; b=iqCjAhTrK28xYQns6jgjBEFw++UI3edtsVgwj914iW29XtLsnLkDoLUNQuLff8u8ud0H7TbwOI8XR9A2YOa975ZO4r0LyVQWWJ2egl8NT5FFjFwzPEJJnmgCePzzhUrdeuvH4w/SNfBt/ETh2GCe7i/8H0pVLxnv+MCHM2kWA+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207577; c=relaxed/simple;
	bh=Ai8CXWriGsoWfbmpj2dCqYfy3Cak9q/AOj6FTqrQRoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TtJwIZBWYHmZzWNn5pVeXxTmyqooa666Hktf8zkDvaeSaRkQhqnCEDbfQF/0fGPCNO1URL/qOfE96NwGgqAZSy9rWx8TlXdr6M4Hq/XVQ3FJ+FeCynFRMDpLDC+wnmFvSBZqgg0SP5AlsdU/re81LY4nHnTRCwzrtZwYG/p40CY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LJEk/EIw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LJEk/EIw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA9131F000FF;
	Sat, 12 Sep 2026 10:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207575;
	bh=2iyH16lXcfuWXP+KEFL8usU7340bzW46Na0vp0J3g5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LJEk/EIwOX5tGvjMwz6uaarHq51WjdBj/q8ZeNyOpGsgrtsuOrH8+3PmQMIHD+8RD
	 /OG7eudpilDs1jTLCXojTjUA4o87g+r+GlduwnMhmGdgPqZQTW8VSYwBpNEpsMR2Sq
	 nB0zJvAXzc2XQGwV/K29oZLXwIxwbwjwEy7HR5io=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lee <david.lee@trailofbits.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0440/1518] UDF symlink pathComponent header OOB read
Date: Sat, 12 Sep 2026 08:43:29 +0200
Message-ID: <20260912065633.403470988@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lee <david.lee@trailofbits.com>

[ Upstream commit d23eb7380d1594cda31a5dc8487dd2a5c8def8c7 ]

udf_symlink_filler() can enter udf_pc_to_char() with a partial pathComponent header.

Validate that enough input remains for a complete pathComponent header
before accessing it. Reject malformed symlink data that would otherwise
make udf_pc_to_char() perform an out-of-bounds read.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: David Lee <david.lee@trailofbits.com>
Assisted-by: Codex:gpt-5.5
Link: https://patch.msgid.link/20260717104722.41446-1-david.lee@trailofbits.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/symlink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/udf/symlink.c b/fs/udf/symlink.c
index fe03745d09b18..a05d1888a2bab 100644
--- a/fs/udf/symlink.c
+++ b/fs/udf/symlink.c
@@ -36,6 +36,8 @@ static int udf_pc_to_char(struct super_block *sb, unsigned char *from,
 	/* Reserve one byte for terminating \0 */
 	tolen--;
 	while (elen < fromlen) {
+		if (fromlen - elen < sizeof(struct pathComponent))
+			return -EIO;
 		pc = (struct pathComponent *)(from + elen);
 		elen += sizeof(struct pathComponent);
 		switch (pc->componentType) {
-- 
2.53.0



