Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 151061DED58;
	Wed,  6 Nov 2024 12:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896007; cv=none; b=e0StsFKPzXb3KyrBYsBtej7iH6O/2lBGJ+6tH090sY+/4I4WIoxe117KVBT1/s+lrX4Lyf21J5GvMGOywa6x8cNLrpqzRgeF7tU5KFOpmLeYzwoTH5APCu1Iz5gn1Ve5nAa9hdOj+e2ydD0f0PVP/FcWIQF4DyCodquUMKx7s5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896007; c=relaxed/simple;
	bh=N0YalMcyiL1S+CEWGqqcwHaAwYDdNzzE9BJHS3ZD94E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s8/jRqp6uCUQ28+FqlJmmjHv/EYaqaC4WXyJNivIC+hCQZGDMOlLQmwR95/C0wmZtwbJFHKeK7b8Y2fUk86b/X+UOGqNETPovhP2wVLnef60FPDKafjpcJ5N6XuewL2AXljFLArfBaWmF8ZCg+aWfanwZEsjNzR5jYEhxZkJb2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M3zQySAA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M3zQySAA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E4C9C4CECD;
	Wed,  6 Nov 2024 12:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896006;
	bh=N0YalMcyiL1S+CEWGqqcwHaAwYDdNzzE9BJHS3ZD94E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M3zQySAAxRwvC6AYCKUCDROgwDlPfuEqWmx6eYQIPr0jBvU0wwttvif+LjXJK3gKt
	 NCmLKEii7Shu/YHpoaDL2YAZTxgjjY30loARk1ZW1uMifiHIVIq7twqgT6TEVGo86d
	 d9OKAgEwM1XD+uHV+Mo5JPqI3kAPlwUhh8obezuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Brian Foster <bfoster@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 058/245] iomap: dont bother unsharing delalloc extents
Date: Wed,  6 Nov 2024 13:01:51 +0100
Message-ID: <20241106120320.639309326@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit f7a4874d977bf4202ad575031222e78809a36292 ]

If unshare encounters a delalloc reservation in the srcmap, that means
that the file range isn't shared because delalloc reservations cannot be
reflinked.  Therefore, don't try to unshare them.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Link: https://lore.kernel.org/r/20241002150040.GB21853@frogsfrogsfrogs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 50793801fc7f ("fsdax: dax_unshare_iter needs to copy entire blocks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/buffered-io.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index d38e52a645888..8167714af5cba 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1346,7 +1346,7 @@ static loff_t iomap_unshare_iter(struct iomap_iter *iter)
 		return length;
 
 	/*
-	 * Don't bother with holes or unwritten extents.
+	 * Don't bother with delalloc reservations, holes or unwritten extents.
 	 *
 	 * Note that we use srcmap directly instead of iomap_iter_srcmap as
 	 * unsharing requires providing a separate source map, and the presence
@@ -1355,6 +1355,7 @@ static loff_t iomap_unshare_iter(struct iomap_iter *iter)
 	 * fork for XFS.
 	 */
 	if (iter->srcmap.type == IOMAP_HOLE ||
+	    iter->srcmap.type == IOMAP_DELALLOC ||
 	    iter->srcmap.type == IOMAP_UNWRITTEN)
 		return length;
 
-- 
2.43.0



