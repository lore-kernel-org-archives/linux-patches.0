Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E75E280300;
	Tue, 27 May 2025 17:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365896; cv=none; b=Cqv+csiYViLlwg0E/SkM7kCM7a/uR3ZXM3Z7qg/JZzmo14iMw25mHJ/OmxT1FzAdmVIYEpmSgj5bzfkt1AttVoWs1o1lAWqtoc7qeRWOg3Jlopi6bnP+yMxJTcJ6/jsuAr+qSAYLagW9ZDoaGsSaYSLwf5wILxDuoj1hldqhiO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365896; c=relaxed/simple;
	bh=+sHC57xGqMZ8wPQBp+lB3U+viaTEjRAVzh519JcOe1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bo+UiN7jwgVy9iwQ2Q6MHvkcqkGOH1XJEBQIN5OJPbr/MwtPNIbCTnQd5fu4L61dlkbMC0bTziMdJiRl2rMq/n+K7lt2/EhRqiuFWswLvhRtni0pZ7QSot47L8iy23sQ0d8CPDJgxBx22VYagk1Vvi13cEtthebse3YoQc/oGiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=foeb+INa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="foeb+INa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8A24C4CEE9;
	Tue, 27 May 2025 17:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365896;
	bh=+sHC57xGqMZ8wPQBp+lB3U+viaTEjRAVzh519JcOe1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=foeb+INaCQGvULfQsDdcJeDZJKW+0rqt0EV4HXu2hRk0XCAbUn/MviClgAe5Ahi+a
	 e9jEl0g9mTVpnuWW64PwqpI9QOhJPLPoJRPkPlT8DeV2imP7ONCDhOIkxGWT3ZoRAa
	 WeQjPMpn0lNDFhT6T3r+lenS/dO55APzuhog/GIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 525/626] btrfs: handle empty eb->folios in num_extent_folios()
Date: Tue, 27 May 2025 18:26:58 +0200
Message-ID: <20250527162506.330238002@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8a36117ed4532..fcb60837d7dc6 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -293,6 +293,8 @@ static inline int num_extent_pages(const struct extent_buffer *eb)
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



