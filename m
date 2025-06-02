Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37114222576;
	Mon,  2 Jun 2025 14:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875444; cv=none; b=cJGa9h35XzHrqiVIXRhRA1Ty4A2jYYKuhwFXL7fDlHlFGI2zfV3RNLHnCk/kWxVYo6kbcQuL6siaio2SXMKaSCewAVFP8TC4mf/MBAWRuIk685wB/DlVOrLDxJtfqRll8Zitt5oNtMvj+SeKTkBvq816SUKiTLFfi5yrD5uj68Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875444; c=relaxed/simple;
	bh=/VYvPp023OM+gBEnp22bAvP4HyfA42dXiMLLT0IAKxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CG91+hA3FcQAmsMd8bDH4KKmZRirYsng7jYMobigiZo7jWZFhsjaHWDmR2qhHmdF0QUmZDigiqh1cKiqX/obIVfGPoMtrdqB8Q4/jd9/RulCBaTLzRcDCP+rKycOf1YdcUAX4TTYB2rPr3DDVOS0dnrFlegqIYbLqzVmE5v5cu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vt0ACwTm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vt0ACwTm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 993B3C4CEEB;
	Mon,  2 Jun 2025 14:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875444;
	bh=/VYvPp023OM+gBEnp22bAvP4HyfA42dXiMLLT0IAKxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vt0ACwTm81JJ5P5AsTDWO6TMrYldPMqLtpEHdfseG5WSePC8kjYXioEzhyLfTliwK
	 AWhg6xqawwuHpIasZ3oWfXLlv4u8ihcd/54pM5DTHBV6Dn2XqoISCyN+8oeENFo7xc
	 4X12VN213+JnChL3FTfpIs9zW2J+23Yb9i0LCqSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 137/270] btrfs: send: return -ENAMETOOLONG when attempting a path that is too long
Date: Mon,  2 Jun 2025 15:47:02 +0200
Message-ID: <20250602134312.829510497@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit a77749b3e21813566cea050bbb3414ae74562eba ]

When attempting to build a too long path we are currently returning
-ENOMEM, which is very odd and misleading. So update fs_path_ensure_buf()
to return -ENAMETOOLONG instead. Also, while at it, move the WARN_ON()
into the if statement's expression, as it makes it clear what is being
tested and also has the effect of adding 'unlikely' to the statement,
which allows the compiler to generate better code as this condition is
never expected to happen.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/send.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index a9e72f42e91e0..3e7bb24eb2276 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -390,10 +390,8 @@ static int fs_path_ensure_buf(struct fs_path *p, int len)
 	if (p->buf_len >= len)
 		return 0;
 
-	if (len > PATH_MAX) {
-		WARN_ON(1);
-		return -ENOMEM;
-	}
+	if (WARN_ON(len > PATH_MAX))
+		return -ENAMETOOLONG;
 
 	path_len = p->end - p->start;
 	old_buf_len = p->buf_len;
-- 
2.39.5



