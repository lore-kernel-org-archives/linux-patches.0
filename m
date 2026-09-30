Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A3B3DC4D8;
	Wed, 30 Sep 2026 19:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796101; cv=none; b=VfMRPdGG2oeVlq6+SoaomBC8XWzhqDhnbCOjiQAMIBj/3nfKWG66Ri7FxDmcXqdFsOFIs+KCmqYZ55W7kbVjmYjXPDR9zH3UzTOFuSCPhv59ND0ph9jAv20R/U9DKypyF23/FpC4/hJUxIEBSlq4coIMUlHAmEleemY7tOSoJH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796101; c=relaxed/simple;
	bh=76NEkG9H8A+fz+Lb6WeXdlMSic4V0B4LlfxztwUOkg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=glHs67OXPJSmdyqfkdx2FkB0oy1zAhytprfN3FDPBsPbVXkOZfQQnp7ehz8agy5NXkZYMVXsGIrcgQn1ZrZL0LuKFVnTei5tw4N7LvxBy8QgfH/KBpZP/Jm2J9n8K0sDFo7lQyGy93S2eWzAgarsQ6JJaXeelezJgh1i/yYADYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g5ALfk+N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g5ALfk+N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9997B1F000FF;
	Wed, 30 Sep 2026 19:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796100;
	bh=f52ANVSAh5SlZyqA9yU9k72o2BL+DSdwwz2Fkea1iyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g5ALfk+N42+pKpqLyCdnAXlWCfT63KleJCP8LHr/qDebnOlmtcAClZCnnmO8cbcpa
	 6Ytj57g66IDv4j2ieOcR/1UKGxNvCNmxIOYcz54nefOgpxziXid3N+uZ9oN4xTo3xk
	 HL7700qNaTO1qn88gLsDng4k2BthMMp7V4CkQW6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0793/1193] btrfs: tree-checker: print dev extent offset in error message
Date: Wed, 30 Sep 2026 17:24:37 +0200
Message-ID: <20260930152451.863907846@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index f9b9fb0b21d5a..d3c14dc3b0a66 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1834,7 +1834,7 @@ static int check_dev_extent_item(const struct extent_buffer *leaf,
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



