Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7655516148;
	Wed, 30 Sep 2026 17:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788545; cv=none; b=nGGyqPPQUZsWBYGwEyYtdQPmERcSdmsHFEAzlxBzuK1eSwmRZZEr0lSzfytOiQsffqPJs2nUqvbA3yDS/TA31w3Gqm0XItAFfl4HZrhZvleQYFwWCrWBsyJqgwPwEDNUswdj0Eg+R664+7wopOwuMOnxUq+df4DL8OIEbApV5ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788545; c=relaxed/simple;
	bh=NjN68ByptrFRZX/BLXwWrPcaM9la1X1NRnSpY5rXS7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IhObGf3EcV76LBhyD+tVT4rMSq4lLXTbLEDT6h+mfrctYhCvjtzB+Xe2hRTlwwlXDbBDTdrWKNXf4bbSbxwg4KfHPpMPf85snqPkc8mQAaiM3/snz64SObS1f1k0OsWgVM+13bnzTxwZpBRCE+D7I3ElOkCZph97e/dTnYhaYZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XJHl8aGE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XJHl8aGE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CB191F00898;
	Wed, 30 Sep 2026 17:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788543;
	bh=WoppLdaP5q2pNXSRn1n+Nzpspi6wW8ApSe9mPINXl6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XJHl8aGEEnB6TGQzHbW/2kSNm3aezsLJXLW33xjxlVViWBAJGEsLtePOY87MeZhKL
	 +lrGxwz6ZA+L5nT8PnzIME6S9aHhX+7EZQ+zea0I0mW/HZ9w9x98WC4qw1PxyMYOlO
	 kVfe8x8kSJgO0RTpXvzTplJMc7+4o3PgYjf3r4Pc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 117/877] btrfs: tree-checker: print dev extent offset in error message
Date: Wed, 30 Sep 2026 17:17:08 +0200
Message-ID: <20260930152417.261828460@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 92a2df6dd3a4e..6b68d87cbf446 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1914,7 +1914,7 @@ static int check_dev_extent_item(const struct extent_buffer *leaf,
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



