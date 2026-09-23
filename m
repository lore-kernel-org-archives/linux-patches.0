Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E19494824;
	Wed, 23 Sep 2026 14:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173245; cv=none; b=tFjiOckVBsairMBoE4qQTHo5Rhnjjg6/y7CcOILVNDNNIdMw/rmRLzTUj9hq2Qw4MicW5Wc09t5LfzDGb0SxeKO5NU5TboDo/nVtoTHhJkaQULd0TzEQZ8Iol5ira744Hyd+tpf1RrR1VlQLr0XVAuQ5HmJGOBgZG2O5rc1bd1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173245; c=relaxed/simple;
	bh=57/cDqriMha4Ma8FM5GeH3cTjRdOl/GFqFHQ14pi61k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fXypVq8pIBqgTsCY5/mEOw8/36RBIkqq+f4rM/p3NCQZPjINlx8TRy3i1C5KU8lf82c0wwTfb4h9ntjyvswmLvs2kOkJD6CKcFhLJd5Xeao7NqLTrq4dINe2xkt5QWBcIsvoSgN0KBHyP1+xQ/033VOSmXocId8n00BZ4fBwAlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qxh1sQDO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qxh1sQDO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 245F21F000FF;
	Wed, 23 Sep 2026 14:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173244;
	bh=IWhrBZyNDC1Ql5RISjXPzjaMi0ei0L9CuZshDX09d5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qxh1sQDODa9IpPsQoTU2XQuS1W8jKUChD/J0jvZXOdSC4o9YoAjaXPmaw9HF9cTjt
	 y229gmq5pHmfnFviEZn5GUv68svcHiaZX0+I5+Kc4FVqRWo81n5FgKXy7CqDPd4SCM
	 eMFEBfLck0crVXVeaktN3/8uylYvgqgKhHZ8dirw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 152/438] btrfs: tree-checker: print dev extent offset in error message
Date: Wed, 23 Sep 2026 16:02:53 +0200
Message-ID: <20260923140648.710784912@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit a1167d9420474ab9ed9efca99d86aeb6217c0265 ]

If a dev extent's offset is not sector size aligned, the error message is
printing the dev extent's objectid instead of the offset. This is a copy
paste error, as before this check we check the objectid field.

Fixes: 008e2512dc56 ("btrfs: tree-checker: add dev extent item checks")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-checker.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 0ce91396b517f..1326bbc1322dc 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -2100,7 +2100,7 @@ static int check_dev_extent_item(const struct extent_buffer *leaf,
 				 sectorsize))) {
 		generic_err(leaf, slot,
 			    "invalid dev extent chunk offset, has %llu not aligned to %u",
-			    btrfs_dev_extent_chunk_objectid(leaf, de),
+			    btrfs_dev_extent_chunk_offset(leaf, de),
 			    sectorsize);
 		return -EUCLEAN;
 	}
-- 
2.53.0



