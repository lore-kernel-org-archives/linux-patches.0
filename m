Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0624C8F70
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 19:55:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DFEDC433C8;
	Sun, 16 Jul 2023 19:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537336;
	bh=0kUJoWCMRh/RGq76dsiLIp2oNW5tows7X5i+WJu5LTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h79s3v51Y0ocZuMnu0LSlgscN48TuegQUA0ux4rmC7ZMXkxURuDxupbpofK7wfOne
	 Ye4MxlG4JeSz5VUCQ8Jqru6cVTKyLaZZpyvkTevQlFHoxLizfHvOM+n/5rCbCWsyn1
	 DVD3ETepX6w8cGBFs8vPcACrIEFXdlYO4edqjeZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Eric Biggers <ebiggers@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 022/800] fsverity: dont use bio_first_page_all() in fsverity_verify_bio()
Date: Sun, 16 Jul 2023 21:37:55 +0200
Message-ID: <20230716194949.618101607@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit d1f0c5ea04cd0a93309de0246278f0b22394692d ]

bio_first_page_all(bio)->mapping->host is not compatible with large
folios, since the first page of the bio is not necessarily the head page
of the folio, and therefore it might not have the mapping pointer set.

Therefore, move the dereference of ->mapping->host into
verify_data_blocks(), which works with a folio.

(Like the commit that this Fixes, this hasn't actually been tested with
large folios yet, since the filesystems that use fs/verity/ don't
support that yet.  But based on code review, I think this is needed.)

Fixes: 5d0f0e57ed90 ("fsverity: support verifying data from large folios")
Link: https://lore.kernel.org/r/20230604022101.48342-1-ebiggers@kernel.org
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/verity/verify.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/verity/verify.c b/fs/verity/verify.c
index e9ae1eef5f191..cf40e2fe6ace7 100644
--- a/fs/verity/verify.c
+++ b/fs/verity/verify.c
@@ -256,9 +256,10 @@ verify_data_block(struct inode *inode, struct fsverity_info *vi,
 }
 
 static bool
-verify_data_blocks(struct inode *inode, struct folio *data_folio,
-		   size_t len, size_t offset, unsigned long max_ra_pages)
+verify_data_blocks(struct folio *data_folio, size_t len, size_t offset,
+		   unsigned long max_ra_pages)
 {
+	struct inode *inode = data_folio->mapping->host;
 	struct fsverity_info *vi = inode->i_verity_info;
 	const unsigned int block_size = vi->tree_params.block_size;
 	u64 pos = (u64)data_folio->index << PAGE_SHIFT;
@@ -298,7 +299,7 @@ verify_data_blocks(struct inode *inode, struct folio *data_folio,
  */
 bool fsverity_verify_blocks(struct folio *folio, size_t len, size_t offset)
 {
-	return verify_data_blocks(folio->mapping->host, folio, len, offset, 0);
+	return verify_data_blocks(folio, len, offset, 0);
 }
 EXPORT_SYMBOL_GPL(fsverity_verify_blocks);
 
@@ -319,7 +320,6 @@ EXPORT_SYMBOL_GPL(fsverity_verify_blocks);
  */
 void fsverity_verify_bio(struct bio *bio)
 {
-	struct inode *inode = bio_first_page_all(bio)->mapping->host;
 	struct folio_iter fi;
 	unsigned long max_ra_pages = 0;
 
@@ -337,7 +337,7 @@ void fsverity_verify_bio(struct bio *bio)
 	}
 
 	bio_for_each_folio_all(fi, bio) {
-		if (!verify_data_blocks(inode, fi.folio, fi.length, fi.offset,
+		if (!verify_data_blocks(fi.folio, fi.length, fi.offset,
 					max_ra_pages)) {
 			bio->bi_status = BLK_STS_IOERR;
 			break;
-- 
2.39.2



