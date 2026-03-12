Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61416396582;
	Thu, 12 Mar 2026 20:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346400; cv=none; b=POndXUcEbXNdoVXpglKC2JgZAbrazOZYEbX+FYjGj7gQmd0I/ccAP/hSRZxyRx1Uy2dOMabvKZW48Zaqut8VADYAXw7JODnB5ON48nvOlYFHiqMac4TruhoQVcFLefcYqoTryl7T3ltB+Rz+BBmqvVHIIq7WJZzi93b6VdNGDLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346400; c=relaxed/simple;
	bh=Otqw/NAz1iis7hXF7Ub30O0S0L5ZlHjJDG/TOnIHifg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wx7ylvfiQMPHgTtuY1+KUCRrWkZSlj9SudZjuqN0Hq6sX12AeMWn7iIRDD0wRe7bRhZOeQUsYRtq30sEnSQlWJDu7zSFKrP4rmI+ZV14gMoOcS9rcFM+2nrabanjTc7+Bw1V8mReg2cHCr1kOYhkh+CJ6QLCuKYXcW9eeFBPVO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ivawfSbE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ivawfSbE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F6C4C4CEF7;
	Thu, 12 Mar 2026 20:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346400;
	bh=Otqw/NAz1iis7hXF7Ub30O0S0L5ZlHjJDG/TOnIHifg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ivawfSbEDo+FmQqBb7Av7bby8Y5ImyF5UmsKgnHoe2lwvxG33LOa1BuzXooRhtO5i
	 KMXEsDyl+5eXPhHgFNiwhpsXridvf53TkVgA85RziRrskJQescGESCH+m32RTaW7wp
	 0z4vXAK//rm8g6bCcczJyor4h/ppzIReg6TJZ7BY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@fb.com>,
	Qu Wenruo <wqu@suse.com>,
	Mark Harmstone <mark@harmstone.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 033/265] btrfs: fix incorrect key offset in error message in check_dev_extent_item()
Date: Thu, 12 Mar 2026 21:07:00 +0100
Message-ID: <20260312201019.385366339@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Harmstone <mark@harmstone.com>

[ Upstream commit 511dc8912ae3e929c1a182f5e6b2326516fd42a0 ]

Fix the error message in check_dev_extent_item(), when an overlapping
stripe is encountered. For dev extents, objectid is the disk number and
offset the physical address, so prev_key->objectid should actually be
prev_key->offset.

(I can't take any credit for this one - this was discovered by Chris and
his friend Claude.)

Reported-by: Chris Mason <clm@fb.com>
Fixes: 008e2512dc56 ("btrfs: tree-checker: add dev extent item checks")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Mark Harmstone <mark@harmstone.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-checker.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 3bb7a376bd3fc..894136eb443ee 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1882,7 +1882,7 @@ static int check_dev_extent_item(const struct extent_buffer *leaf,
 		if (unlikely(prev_key->offset + prev_len > key->offset)) {
 			generic_err(leaf, slot,
 		"dev extent overlap, prev offset %llu len %llu current offset %llu",
-				    prev_key->objectid, prev_len, key->offset);
+				    prev_key->offset, prev_len, key->offset);
 			return -EUCLEAN;
 		}
 	}
-- 
2.51.0



