Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212447;
	b=2Mlcn4OcIqM89gEU674p/KEb7xAd2HltzFAvvKn2sf7fmycCZk8o+Pk3WcLLVAO5jQvH
	 5ZChrcG+l8mC/BmKjO6HZ3LhjNnKOrFyHS+rRTwDevbexev5f0sbqOYRZ6OeVlU5hrsw9
	 llfVPMYMH3N8XbOvfPmrok+JPtI1q0YEUospJBzan+fzapEmLu+wP2VeUuFBIUgoRx0lR
	 YMFX6JKayIgI7DVSyrEuUIwEIPVaGkiEhKPUDi6/UnTugHLCNnv0+7mzGgDGUiMgadAQD
	 45sUIpI3JHyEO3/7/AWqH+Mvc1X2V4P+PUZfpRc03nmVJLGwggTE2LYuORN9R9JPp9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212447;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oEmWWkSjLmgOsJNyuIHAxvej/lffQRtZRvTPZFgIUvQ=;
	b=WN/ZdLBiaNzel9cFooucV/MKspQhnZ40byxiIB7ygBCBslu+d2ahXMbRnayCKdf9wW1G
	 tcxN7m+GSS62LmLen4+v16FHR2S54GjFeLh/q1RrPqZNS9IkQgxB70GO3xCX0S3gJQehD
	 WPAPL0rOoNGDRx4QiKCxY9Imn91qvHi3KT/kV0aozltuxhziRvK4Y61+ZqIG0+QKqKacY
	 8WHLtpPlvE6fZ4PDG6PN1xFfBqeAKz04u0IQcVI9QTDc0hK+fjm801rvzzUbg10QkZ81+
	 aw5Sxqi7+seh28atmibULKlJ5imaPggS5T40BD7kUaVwHwG+45OH3yOaRSrGomlHpYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GwHukMGd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54132606A338;
	Wed, 28 Oct 2026 18:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GwHukMGd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2EC71F01829;
	Wed, 28 Oct 2026 18:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212447;
	bh=oEmWWkSjLmgOsJNyuIHAxvej/lffQRtZRvTPZFgIUvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GwHukMGdWDsH/Wtf76M4uSvlSFGbk+lC3C2bAY6KPOgYA82lvXPLBPXy4V6ALmMrv
	 jydL9H7wJryKmIe2B3UQXa4yDrBzEWw1Wh//gizuC93wbMmtUkHeWrK9Tq1BkD9jgk
	 uKAUt/vtqf9HVL2fh0eVoux7WYAUaTzl5QGrImQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Guanghui Yang <3497809730@qq.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0114/1887] f2fs: fix dentry folio leak in find_in_level
Date: Wed, 28 Oct 2026 17:36:50 +0100
Message-ID: <20261028170501.829390467@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guanghui Yang <3497809730@qq.com>

[ Upstream commit cca7d3e30bf30333314e31bc70b9a739f1342167 ]

find_in_level() gets a dentry folio with f2fs_find_data_folio() before
calling find_in_block().  If find_in_block() returns an error, the
function stores the error in res_folio and breaks out of the loop without
dropping the dentry folio.

This leaks the folio reference on the find_in_block() error path.  Drop
the dentry folio before returning the error to the caller.

Fixes: 7ad08a58bf67 ("f2fs: Handle casefolding with Encryption")
Cc: stable@vger.kernel.org
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Guanghui Yang <3497809730@qq.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
[ Replaced f2fs_folio_put(dentry_folio, false) with f2fs_put_page(dentry_page, 0) for the page-based API. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/dir.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 29ac1e77b5d7a..cadc32959a23f 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -374,6 +374,7 @@ static struct f2fs_dir_entry *find_in_level(struct inode *dir,
 
 		de = find_in_block(dir, dentry_page, fname, &max_slots, use_hash);
 		if (IS_ERR(de)) {
+			f2fs_put_page(dentry_page, 0);
 			*res_page = ERR_CAST(de);
 			de = NULL;
 			break;
-- 
2.53.0



