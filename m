Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8A62C15A8;
	Tue, 26 Aug 2025 11:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207569; cv=none; b=tsnsvYkpZYi5UzL3uhO3/PvZ/ZBCmI4fr/NpHIfKhzmjq8+4QWYJJ6usXWbBQLUgla3MOtVJpXOFajjnzqb1gkpG1ETaFfmbdD4gwc2ABxZmOAltCljFBTG5Rz8ccFE2+10qIibyEEF/nd19o0pHybMwwt1qFA++OzafL0//fy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207569; c=relaxed/simple;
	bh=pI3ksxWmEVmlzSzZkWnNqZU9mEsMTl+aKXQdwg3EmZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bB0Iqcvd7P5VhJBukvc0TJGfqKvvalGvJApG4liTRy/GYXbeRg0Adq81dbsI+8+PrUmohas9jC9xcjtJL5CihBlQim/tRE5ApTJeMcJUJtrQDrKFhF1JIafb32P+vYAiLkr5e4GVEt8inMIXY7HTaQ/w2hI+yt7TdBajiZ1haCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IWwSZcS4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IWwSZcS4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E25AC4CEF1;
	Tue, 26 Aug 2025 11:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207568;
	bh=pI3ksxWmEVmlzSzZkWnNqZU9mEsMTl+aKXQdwg3EmZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IWwSZcS4iZ+/OH0TQaqsNTEIKfBFBT8vSQw7D+hHycukyz/m42XsIhfnbAfxftg/u
	 oeuSrL+hGX2hRL1ceeBXGbFLiZ7cwMup9gdGWzT8Mi+EjhyNzlj3KR7sGrMXdJV9hH
	 QNTjQq7V5xe9i/iMjyS7tieFHDW0yx9BOQvSgfDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 215/457] btrfs: reorganize logic at free_extent_buffer() for better readability
Date: Tue, 26 Aug 2025 13:08:19 +0200
Message-ID: <20250826110942.678676088@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 71c086b30d4373a01bd5627f54516a72891a026a ]

It's hard to read the logic to break out of the while loop since it's a
very long expression consisting of a logical or of two composite
expressions, each one composed by a logical and. Further each one is also
testing for the EXTENT_BUFFER_UNMAPPED bit, making it more verbose than
necessary.

So change from this:

    if ((!test_bit(EXTENT_BUFFER_UNMAPPED, &eb->bflags) && refs <= 3)
        || (test_bit(EXTENT_BUFFER_UNMAPPED, &eb->bflags) &&
            refs == 1))
       break;

To this:

    if (test_bit(EXTENT_BUFFER_UNMAPPED, &eb->bflags)) {
        if (refs == 1)
            break;
    } else if (refs <= 3) {
            break;
    }

At least on x86_64 using gcc 9.3.0, this doesn't change the object size.

Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: ad580dfa388f ("btrfs: fix subpage deadlock in try_release_subpage_extent_buffer()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent_io.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3486,10 +3486,13 @@ void free_extent_buffer(struct extent_bu
 
 	refs = atomic_read(&eb->refs);
 	while (1) {
-		if ((!test_bit(EXTENT_BUFFER_UNMAPPED, &eb->bflags) && refs <= 3)
-		    || (test_bit(EXTENT_BUFFER_UNMAPPED, &eb->bflags) &&
-			refs == 1))
+		if (test_bit(EXTENT_BUFFER_UNMAPPED, &eb->bflags)) {
+			if (refs == 1)
+				break;
+		} else if (refs <= 3) {
 			break;
+		}
+
 		if (atomic_try_cmpxchg(&eb->refs, &refs, refs - 1))
 			return;
 	}


