Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 357B023C8D6;
	Tue, 29 Apr 2025 17:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946565; cv=none; b=eWMY+IpLPMYV2j2NLhPO+mTG+FKwZ23zJUdApoXwWiKUm5UxhoNn18t1wyypto81/muF/+rNFKOenr5lT5Ym1KSAnO2+HieBRKKiybn520A8Zw2rTbdAqIBxFyRpXpEeBLUjXiuYDhcvC03Sg5B32NvPJHU7btOTPExW0C9PlMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946565; c=relaxed/simple;
	bh=IXY8bwPL9mXWiEgYADCfFSbGyTQ9FpWhJDmX4cCOlEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NIpEI4eymjcldPXuwjDhl33+gh/kbZZTmdHRCOPeBSmNE/4AOazMDXj86KdmLCbBRFYrP0J4SxZU6n8wK/euuqFl815dRcbRwZs0b9OON1yuFoG6cnhCsdgNn0LYn0vOJ/HPI8bz5BqAZjoR5pszd8zP+S9g9fR7f4uSIpE1cQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jZ2XTwa4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jZ2XTwa4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4B9FC4CEE3;
	Tue, 29 Apr 2025 17:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946565;
	bh=IXY8bwPL9mXWiEgYADCfFSbGyTQ9FpWhJDmX4cCOlEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jZ2XTwa4Agsge7I2Df4zNU33UIHx5Clbw8mH0pLv0nJwCGL2uXlysrtQ1du2Hd+Nu
	 tK1O7z1Ggaf8bdVEU1dAjSwAusAAFrW3YHEa8QMOPJ9Mwg3GkzDYq3ITthHTN+G5tz
	 PHSTCSr4ppq0AaBKju7NOqgjN21AFIkKAEph9Kdo=
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
Subject: [PATCH 6.14 281/311] iomap: skip unnecessary ifs_block_is_uptodate check
Date: Tue, 29 Apr 2025 18:41:58 +0200
Message-ID: <20250429161132.523529783@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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
index d303e6c8900cd..a47e3afd724ca 100644
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



