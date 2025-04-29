Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 685F824889B;
	Tue, 29 Apr 2025 18:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950712; cv=none; b=FPD8PcgIcLViSTb1zMUGn08myEynaF87QfxHjgcnu6qHKKtZe4tuxM4lwXS6km2AklRnA0zEOvwiGlsKkKgy+x5ihexsXGS1sA0S+p6W66k9GcxpeUEHDbrP3e68cWE01lqQA9TbC9feBqGDP/yRMz5WC0Orc+5v9//HHFpJQUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950712; c=relaxed/simple;
	bh=cRL7TCffumZHGrQO9qTKfg74LcwoGBnavBHb/86S4H4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dNQ4XTxOHa7+qyudre5wyMe8GafD4baKOxHJplIHoBFz+V1Co5dbUjJ/+IBylNWuC+RbSxKH8JAq4FgKY0XhcjElOfq3cX+qJsNIQJ3Ehrii1YmLnuhPBWY6/kv+jrurslX/FCNBhQiGdYEuWoK7YRzLrv30K6WXqRF8rgXlBZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ri1B+G9C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ri1B+G9C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6708EC4CEE3;
	Tue, 29 Apr 2025 18:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950711;
	bh=cRL7TCffumZHGrQO9qTKfg74LcwoGBnavBHb/86S4H4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ri1B+G9CCHJXwyTPdfnOL16VNXOf/bNM0sjlqxEBnvXlRKqN/ON2k6JapvNfydVKA
	 H6TQ6S841DAM1q2biPJJeo33uFXaY4yr0ZjFWwq5iae7r7CxyceArS2i8uGC0I44Qe
	 a1hxiVFVj2aBegvUdEkFQCGHbLeTHnqf86cPDiCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gou Hao <gouhao@uniontech.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Christoph Hellwig <hch@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 180/204] iomap: skip unnecessary ifs_block_is_uptodate check
Date: Tue, 29 Apr 2025 18:44:28 +0200
Message-ID: <20250429161106.759721278@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gou Hao <gouhao@uniontech.com>

[ Upstream commit 8e3c15ee0d292c413c66fe10201d1b035a0bea72 ]

In iomap_adjust_read_range, i is either the first !uptodate block, or it
is past last for the second loop looking for trailing uptodate blocks.
Assuming there's no overflow (there's no combination of huge folios and
tiny blksize) then yeah, there is no point in retesting that the same
block pointed to by i is uptodate since we hold the folio lock so nobody
else could have set it uptodate.

Signed-off-by: Gou Hao <gouhao@uniontech.com>
Link: https://lore.kernel.org/20250410071236.16017-1-gouhao@uniontech.com
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/buffered-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index e7e6701806ad2..7ffdf0d037fae 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -224,7 +224,7 @@ static void iomap_adjust_read_range(struct inode *inode, struct folio *folio,
 		}
 
 		/* truncate len if we find any trailing uptodate block(s) */
-		for ( ; i <= last; i++) {
+		while (++i <= last) {
 			if (ifs_block_is_uptodate(ifs, i)) {
 				plen -= (last - i + 1) * block_size;
 				last = i - 1;
-- 
2.39.5



