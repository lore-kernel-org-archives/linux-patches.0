Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 110CB2737EE;
	Fri,  9 Jan 2026 12:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961159; cv=none; b=LfF+rSmoom0I522juusaRN0Py1DphEnW0jikiPpJtmrEeoTrtBfoVK0W91adTv197j3EuAqSCxQ64bk34yE1Rxw8/5v7IJlxlpR40vzivMSCZJtwWZ85hMHJGPruxBUItdOjJezA7EBLTH6en6gAu/S6TKIp+EQ/GU6YR7Ik1nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961159; c=relaxed/simple;
	bh=342LNpSvL03neXmnM43ZNT+cjiYCO2sDJ2vOGeqjjyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a7gptAkuZHV7Nu/X7btZn9oRuG+6a/KeaThcJD/dVghwln1ZiKLDL4/GvhNmIXO0Ku/KoTJyfC35IjeL0eLYsuqmFA8D6fVwX5/Z8Y4GIJoPLXI7YDfM0xA9VUda2iAqH+OuJZAno04vGZrOQ9sJ5Q17OfQExwxais3ffKXWUVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0xyxl7kK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0xyxl7kK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91BC8C4CEF1;
	Fri,  9 Jan 2026 12:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961159;
	bh=342LNpSvL03neXmnM43ZNT+cjiYCO2sDJ2vOGeqjjyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0xyxl7kKk33Hlu5oIFzdQ42tDLejSDG9rZreZ85sZlHPt8kaIPqLShSQoENT/5TQq
	 tgCrAocg9s9xnqJAUZHpAI4xcIm+0nRPxSRduHpku3B7voDgnXCFYxP1+Jw3Tkyw1J
	 /HJcKrjMu322mSrrNF7c6bFWEHIbi88ZClIjQH/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Daniel Vacek <neelx@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 638/737] btrfs: dont rewrite ret from inode_permission
Date: Fri,  9 Jan 2026 12:42:57 +0100
Message-ID: <20260109112158.009658311@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 0185c2292c600993199bc6b1f342ad47a9e8c678 ]

In our user safe ino resolve ioctl we'll just turn any ret into -EACCES
from inode_permission().  This is redundant, and could potentially be
wrong if we had an ENOMEM in the security layer or some such other
error, so simply return the actual return value.

Note: The patch was taken from v5 of fscrypt patchset
(https://lore.kernel.org/linux-btrfs/cover.1706116485.git.josef@toxicpanda.com/)
which was handled over time by various people: Omar Sandoval, Sweet Tea
Dorminy, Josef Bacik.

Fixes: 23d0b79dfaed ("btrfs: Add unprivileged version of ino_lookup ioctl")
CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Daniel Vacek <neelx@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
[ add note ]
Signed-off-by: David Sterba <dsterba@suse.com>
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ioctl.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2006,10 +2006,8 @@ static int btrfs_search_path_in_tree_use
 			ret = inode_permission(idmap, temp_inode,
 					       MAY_READ | MAY_EXEC);
 			iput(temp_inode);
-			if (ret) {
-				ret = -EACCES;
+			if (ret)
 				goto out_put;
-			}
 
 			if (key.offset == upper_limit.objectid)
 				break;


