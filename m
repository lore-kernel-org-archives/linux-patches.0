Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516B8242D68;
	Tue, 29 Apr 2025 17:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948369; cv=none; b=dXyfLKoxqVpoij2bPk3+mn7Us1v1TmBQ/SOPD0GhPhZXqVeT/pTRRtTCwc4PcpXXoBWoCKdOgPs8X5KWYA3jbzgGpq+rLjNZLMcoiMPx9JX9UrpptEGwLFEuM3j4S2ICSan5LDKgTfKWZ/fAQ9w+NFZGRJCr7G8m8NZu6PKZUyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948369; c=relaxed/simple;
	bh=Teq8lZJxH9++6iu4OPpS6O2pFTWlmmpf2rbU92tnMV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=huJzslM/sG+Z0dgdz/q7appj5gvkYI29GawwEi1SyE88W6TS6zksGqdTweipuCMwdvQ7Neddqj8plHX5U5W1KkFWm3JqQ7v+fRXP5yLcIdK7RUE+HkSOTxhlITRiFK3yM+hnmKM13kiS2WR79bA1rwRonoWGS2HNVULG+bpfmwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PmIPAQ91; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PmIPAQ91"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC938C4CEE3;
	Tue, 29 Apr 2025 17:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948368;
	bh=Teq8lZJxH9++6iu4OPpS6O2pFTWlmmpf2rbU92tnMV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PmIPAQ91F81cE6Jg87svkJIEuzge6r5GcadR3BAo/sNzRv0FLfetz9/JdXvrkroDz
	 Kzb7oFq+GpRR7aC22L13u8Btw92GfkeyjXN4LhddXk0TWRoqXEl7+t5bHDmD1aerNj
	 RKJAgAcYsc8ok5AHdIfKjPHKlLDfbq3muKC62NIM=
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
Subject: [PATCH 6.12 237/280] iomap: skip unnecessary ifs_block_is_uptodate check
Date: Tue, 29 Apr 2025 18:42:58 +0200
Message-ID: <20250429161124.819675175@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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
index 1bad460275ebe..d4b990938399c 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -263,7 +263,7 @@ static void iomap_adjust_read_range(struct inode *inode, struct folio *folio,
 		}
 
 		/* truncate len if we find any trailing uptodate block(s) */
-		for ( ; i <= last; i++) {
+		while (++i <= last) {
 			if (ifs_block_is_uptodate(ifs, i)) {
 				plen -= (last - i + 1) * block_size;
 				last = i - 1;
-- 
2.39.5



