Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78602223327;
	Mon,  2 Jun 2025 14:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875976; cv=none; b=RHK5PU5z5G6uIqbDEOiX+CcPuyHZwOnKz1DLIsMc1lKhhAa1CvGr+XV6rJDMYIuknKhHOwTV6cNFpNgcc80hXoiFy44OkEfC7YZyebc4dfy0vpsmY9kzS6DhB2Q15/rKmkEF/0k2CgDuDLDNgue7Wjs2wZJwTKI2wBkAVGEbqCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875976; c=relaxed/simple;
	bh=FaipgzdkKT83M3sNy6571bZ8n8dJca8RgYbPkO/CeVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=neBH2yqL0dkiyKWh0Arhlv4KivKMUhz0SGT9O7MninZgtYIZCUuO8g7Ha1zJw4bWsvzcWBTp1OxkCI0e+nmpqWfuHm4jci03Ifa8l9gKUHVIeZEe44kBJSoeLrJKBsRmnEZxMskYe+VTd32D+VckJS6MzDHQxCWAiDk+MtYgVtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PACMtXIC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PACMtXIC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD986C4CEEB;
	Mon,  2 Jun 2025 14:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875976;
	bh=FaipgzdkKT83M3sNy6571bZ8n8dJca8RgYbPkO/CeVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PACMtXIC60SESowgKUHD6ufji+WPvQgrtGqjxtQv3FoXxnG5lZceKabjW059n92wZ
	 QzOlpae3o6r5sp5C8oY9ybUI5Qbs6IN663GTtreP4wK0r+YVmDh7t6jguFdOvK5dcB
	 8r6VC/cdaldEgmk4udvPQpIYx1htPgV1MasKgqNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 033/207] btrfs: send: return -ENAMETOOLONG when attempting a path that is too long
Date: Mon,  2 Jun 2025 15:46:45 +0200
Message-ID: <20250602134300.061217142@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 577980b33aeb7..a46076788bd7e 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -400,10 +400,8 @@ static int fs_path_ensure_buf(struct fs_path *p, int len)
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



