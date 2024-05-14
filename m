Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A46A54903;
	Tue, 14 May 2024 11:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684557; cv=none; b=MTMgdX3M2e6FuR1TqHJpyi9w5xY77+8+MpJMNB/8SC4A+g1n2TwSxotp4ZCo72cSzRQiiYZiAHZVwAxUIUKkvGcbqquD7/5kIzFGWqGCEomEgSfB/DMvbSRsf+4D7wrsw8oh1J4pXbS4zyJlT5iwaHSV8I2KFhXG8ojZH5POjBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684557; c=relaxed/simple;
	bh=vDkJu9jMR85PH1Zfanl/8EgVbAcSbXHWIeFMu5Y/j6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bRn1DoJroBhY1YQBWpAqXmk0M1bWHrZFay0LjZCTK+frsB970ECyl3wSOddCD3ykzBFL3f/bkFZ7oRPW+QkK5jLhM8FYyNRRYWpRvpmVUhroaANaulnzX6O5EHeBgQgN4Pl4kY5fSClTV4kJ4a/CplufYsfS0IF+eJLpjmjLEnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RpSM4r1n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RpSM4r1n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A9A4C2BD10;
	Tue, 14 May 2024 11:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684557;
	bh=vDkJu9jMR85PH1Zfanl/8EgVbAcSbXHWIeFMu5Y/j6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RpSM4r1n5kkUQ5jomXD5Afo7oZbrPytTRiEO6pv7LY+pGS2UiqbKfhSydNyCFQfxy
	 GasBhqHFNStd4PctkDdUG9ITseg7kMReycI/C31wSdv2IepeaCpoehpI5WOQaqiG3M
	 fdiraeydq64dsRLfKna67hNrklveGGFAsQllfTHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Steve French <sfrench@samba.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	netfs@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 054/301] Fix a potential infinite loop in extract_user_to_sg()
Date: Tue, 14 May 2024 12:15:25 +0200
Message-ID: <20240514101034.283493510@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 6a30653b604aaad1bf0f2e74b068ceb8b6fc7aea ]

Fix extract_user_to_sg() so that it will break out of the loop if
iov_iter_extract_pages() returns 0 rather than looping around forever.

[Note that I've included two fixes lines as the function got moved to a
different file and renamed]

Fixes: 85dd2c8ff368 ("netfs: Add a function to extract a UBUF or IOVEC into a BVEC iterator")
Fixes: f5f82cd18732 ("Move netfs_extract_iter_to_sg() to lib/scatterlist.c")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Jeff Layton <jlayton@kernel.org>
cc: Steve French <sfrench@samba.org>
cc: Herbert Xu <herbert@gondor.apana.org.au>
cc: netfs@lists.linux.dev
Link: https://lore.kernel.org/r/1967121.1714034372@warthog.procyon.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/scatterlist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index 68b45c82c37a6..7bc2220fea805 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -1124,7 +1124,7 @@ static ssize_t extract_user_to_sg(struct iov_iter *iter,
 	do {
 		res = iov_iter_extract_pages(iter, &pages, maxsize, sg_max,
 					     extraction_flags, &off);
-		if (res < 0)
+		if (res <= 0)
 			goto failed;
 
 		len = res;
-- 
2.43.0



