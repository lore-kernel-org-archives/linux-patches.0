Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC2D3FADEE;
	Tue, 31 Mar 2026 16:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974565; cv=none; b=RlUDIRg6neohUiX4WYEfUm8FbB5piVrf1isXa1ehnjOtepUGdUTMBnMX+I0P6ICZNlZBAGjQ4B5TxWo9I3oA/kiIOr6PDeDTtLAh5clxAJIwI1cSR//4JfEkU61vu4WiHemQ18C2jfb5rIhlz46g9tRQzBPQL5115Jardzh5sA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974565; c=relaxed/simple;
	bh=t3j/r40AaOfJyCRgTgaWRfbrMyP9HEUZNqxdcmLgFqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nlxbmx2RKWMJZ0K0YQJbfA6E8h8kdkD0YH1okh49Yp53C5ZM8okE0l0A1zy0XGwp0+wztc9KzyR361KMYabzb0XQQT+0EV3W7NL066JClSjm0UiP3LJDxyeNdIWfTIr0kXrxBZQVaMwLYGY8y9MzPWse+R9ajJnXWi2/82SSdIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lPUacl6r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lPUacl6r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 751D2C19423;
	Tue, 31 Mar 2026 16:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974565;
	bh=t3j/r40AaOfJyCRgTgaWRfbrMyP9HEUZNqxdcmLgFqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lPUacl6rdPKBBvxNf+/0HYpWWie/6XcLxneJUVBCRza07kBaJ4ju2s1+jROGZauMK
	 s6NmMOxL6hEPI8L6RJATaK/fMmL1vJtTIwBxUSNMNWZ/mp3Te2874LV3T/tBKCrXln
	 awVa9hs/4jDe0wX8n9mdjy9srp5U1jFGjvnjiFGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuto Ohnuki <ytohnuki@amazon.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.6 134/175] ext4: replace BUG_ON with proper error handling in ext4_read_inline_folio
Date: Tue, 31 Mar 2026 18:21:58 +0200
Message-ID: <20260331161734.708835405@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuto Ohnuki <ytohnuki@amazon.com>

commit 356227096eb66e41b23caf7045e6304877322edf upstream.

Replace BUG_ON() with proper error handling when inline data size
exceeds PAGE_SIZE. This prevents kernel panic and allows the system to
continue running while properly reporting the filesystem corruption.

The error is logged via ext4_error_inode(), the buffer head is released
to prevent memory leak, and -EFSCORRUPTED is returned to indicate
filesystem corruption.

Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>
Link: https://patch.msgid.link/20260223123345.14838-2-ytohnuki@amazon.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inline.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -517,7 +517,15 @@ static int ext4_read_inline_folio(struct
 		goto out;
 
 	len = min_t(size_t, ext4_get_inline_size(inode), i_size_read(inode));
-	BUG_ON(len > PAGE_SIZE);
+
+	if (len > PAGE_SIZE) {
+		ext4_error_inode(inode, __func__, __LINE__, 0,
+				 "inline size %zu exceeds PAGE_SIZE", len);
+		ret = -EFSCORRUPTED;
+		brelse(iloc.bh);
+		goto out;
+	}
+
 	kaddr = kmap_local_folio(folio, 0);
 	ret = ext4_read_inline_data(inode, kaddr, len, &iloc);
 	flush_dcache_folio(folio);


