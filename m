Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6472B28C874;
	Mon, 13 Apr 2026 16:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098655; cv=none; b=MahRrszEV8L13SLXPTnlROoqbNV7pMdtd5tk5VH/3HsXv4OPL3rGjF5vtP/E+LgJ1w49h2w2uX6pte+EifJOkoEsld2vVNjRyN4X/3V57Fd2Y7tuFuQOU/F/7J+0v0wNgSa2Ef0QLJfZAQ8VvhuuoSGjPRaUR0vcCVSpG65blVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098655; c=relaxed/simple;
	bh=FQzyB7Q0/BldzrjSrBUD1hfBdXJ6145lC4J/GAbxwmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q+4JuYrhUcJ44cB2pNedmuk3aMPndK48mz8RKvfADzHZjilmmon9QdYCvFyS68onaGsBi8ho2DtKErwQmEV5ctdMW6GNpEez5ksQ9sB1doyQr5Je/0yLZelpjvofOi62YRknga0yfCmIb4acaYxA7FX1bQ1Fn6lxaGAsRsgRORY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ekCLsO8H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ekCLsO8H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6291C2BCAF;
	Mon, 13 Apr 2026 16:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098655;
	bh=FQzyB7Q0/BldzrjSrBUD1hfBdXJ6145lC4J/GAbxwmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ekCLsO8H2Vvzuz7bF4NYSCJZYv7W3by4Didf83OxW2WMnFG7y+GjLBQ/fmcd5D2TK
	 XhxgJoPpH9FRMsgrDyExsMhhR2qkJemAtSWjAlWgkvXtOo513tI9kqT3UrRV6+bEsF
	 dSIuIOZbnnQOAvsH0VBGwv/xteso1IFyQ1JBQNS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@fb.com>,
	Qu Wenruo <wqu@suse.com>,
	Mark Harmstone <mark@harmstone.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 006/491] btrfs: fix incorrect key offset in error message in check_dev_extent_item()
Date: Mon, 13 Apr 2026 17:54:11 +0200
Message-ID: <20260413155819.289320487@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index fd4768c5e439a..dd27fdb9521a8 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1630,7 +1630,7 @@ static int check_dev_extent_item(const struct extent_buffer *leaf,
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



