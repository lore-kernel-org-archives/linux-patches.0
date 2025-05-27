Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFCA627BF8D;
	Tue, 27 May 2025 17:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368332; cv=none; b=mqXqNpyvekDsPGJu3dLsLJYK59sd7y2Tw1v3leuUq46H5i76dlA8L+zmNef1kg1x6w4y8PBvfF5rCLanXPsdquq7PWsCtnJeUydVBDPzNnSyNu3xb0EsA7tnD0Jx7bZMNfPTnCo0cQPr6xp3cG2ljVMig16lwLO4uqpozhLPEZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368332; c=relaxed/simple;
	bh=NtoKO7yn9/p8aKG7v3WhIBI7gww/KX2HxWrwo27so2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EaQaUgIeHqa6wDv0PlJvbq4xvWuFD4lGwWckwEBPrL5ldAx9vpz2XMvQJjEzDMz3ktz6TzLU7SXcu5be/7uf1uAQ2DczsBJKZWk29UFarVLurXAeuEVPaNlYfThTjz8W8A4YZabuzjcM+MH3A+j/9fkftwXCYNNWU9OieJHH190=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WHLRH+EF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WHLRH+EF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60E3DC4CEE9;
	Tue, 27 May 2025 17:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368331;
	bh=NtoKO7yn9/p8aKG7v3WhIBI7gww/KX2HxWrwo27so2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WHLRH+EFgx7gx2BXybO50832TrOg5Hs+YfuuS5Q2wh8fxHcRhnNZaePSqjQIhuquG
	 +PbmzLSO4VOH6IcAXLcwUruA5/ECZxVXWQJS4M9qRyg7sJSpTREYiJasFgbb9s4PRZ
	 EZY8tVJZIIxXnf7qwkLhv2N33JO2NVo7IGTt4Cpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 672/783] btrfs: handle empty eb->folios in num_extent_folios()
Date: Tue, 27 May 2025 18:27:49 +0200
Message-ID: <20250527162540.488383444@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Burkov <boris@bur.io>

[ Upstream commit d6fe0c69b3aa5c985380b794bdf8e6e9b1811e60 ]

num_extent_folios() unconditionally calls folio_order() on
eb->folios[0]. If that is NULL this will be a segfault. It is reasonable
for it to return 0 as the number of folios in the eb when the first
entry is NULL, so do that instead.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Boris Burkov <boris@bur.io>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent_io.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 6c5328bfabc22..2aefc64cdd295 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -297,6 +297,8 @@ static inline int num_extent_pages(const struct extent_buffer *eb)
  */
 static inline int num_extent_folios(const struct extent_buffer *eb)
 {
+	if (!eb->folios[0])
+		return 0;
 	if (folio_order(eb->folios[0]))
 		return 1;
 	return num_extent_pages(eb);
-- 
2.39.5



