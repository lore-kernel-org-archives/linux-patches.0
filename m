Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A0F2F39B4;
	Thu, 28 May 2026 20:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999940; cv=none; b=lJ78Y56vKXEW9N9uVtG4TKpBOPtMav7TCr4k7JQ8HljzJco5JTyKiUkFz4GrTjoiPq07Wv6QmzyNeKE2tpDBmgFVCmeDqSfvGT1hrn3p48zjywNa8SICfYLaZGDRdaokmEeHKpbi2Tfdtg6cQQaM1QyhAvVLVd8osFY77LiepDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999940; c=relaxed/simple;
	bh=FwNwf9OFGNwRRjgbGkS/s2GUeb95gxrZyBnsDUlKM3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZPld4viVMZ5LFKKE26zNfY4SIG/WMqU3NOJHQMsQSMa3HhJ4NUSKqs48Ef+lsKJYr7TIytyCHMDw/1pNxm0hVWIgw2m3c/cqktYQiV3Zw27PSPI7w/MHm9LjnKs4WmFfGJxtfjL8bAdmrVNNjqIol5xrQ6wmZAgukZObzwm4rkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EkbghmeK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EkbghmeK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24DB41F000E9;
	Thu, 28 May 2026 20:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999939;
	bh=OvJHiFPPYowwlPzzegDXYlE/tcX9q05ZWkr5jpWBlnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EkbghmeK66Xl6m2ETszlQF/QEkhtSYRlVlpnNWMjrrEChkyZurTWQDF3GQjqxcnj7
	 J/JpE56/InyHBN+IM/qi1qjf0wG2pd5S1laZ9p76VGI73NHQbAp9a/Ig1Zh6SjTjk6
	 30Ruk1FVfignpxtifv3oVe91f5+zp96AETZy+PcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Matthew Wilcox <willy@infradead.org>,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 246/377] netfs: Fix partial invalidation of streaming-write folio
Date: Thu, 28 May 2026 21:48:04 +0200
Message-ID: <20260528194645.502567271@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 6d91acc7fb85d33ea58fca9b964a32a453937f4b ]

In netfs_invalidate_folio(), if the region of a partial invalidation
overlaps the front (but not all) of a dirty write cached in a streaming
write page (dirty, but not uptodate, with the dirty region tracked by a
netfs_folio struct), the function modifies the dirty region - but
incorrectly as it moves the region forward by setting the start to the
start, not the end, of the invalidation region.

Fix this by setting finfo->dirty_offset to the end of the invalidation
region (iend).

Fixes: cce6bfa6ca0e ("netfs: Fix trimming of streaming-write folios in netfs_inval_folio()")
Closes: https://sashiko.dev/#/patchset/20260414082004.3756080-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260512123404.719402-21-dhowells@redhat.com
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/misc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/netfs/misc.c b/fs/netfs/misc.c
index eb309bef72608..1109ac3791281 100644
--- a/fs/netfs/misc.c
+++ b/fs/netfs/misc.c
@@ -255,7 +255,7 @@ void netfs_invalidate_folio(struct folio *folio, size_t offset, size_t length)
 				goto erase_completely;
 			/* Move the start of the data. */
 			finfo->dirty_len = fend - iend;
-			finfo->dirty_offset = offset;
+			finfo->dirty_offset = iend;
 			trace_netfs_folio(folio, netfs_folio_trace_invalidate_front);
 			return;
 		}
-- 
2.53.0



