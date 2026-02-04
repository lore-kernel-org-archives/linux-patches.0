Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92552D94AF;
	Wed,  4 Feb 2026 15:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218261; cv=none; b=tuqnymZTQgwwFIuDE93P5JSHqi+cUrz1PChEfKWuNYqB7PDuphSC5WP7QizlsE+mKwL76mqhnuRSGQiFsjJuSxlhRS+SzKBgWp6XwGqt3QB68CPNepqxOAxBUJVtxgxi7bDhNBx6mumKHu6E74c9x7GXXv6zcm7Ux38cmmmQ+Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218261; c=relaxed/simple;
	bh=j9k8jxEW4LyG1VXLDqus0kY6JNk323vle8geYp7Pbjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D1Mf3DIUYQQC56zbZbNlkINsfwvwcWn/3x5gPrcigWrbjulTM/jIpfLgxNXNVSOmCEDfUCr4dwUz7TBvTUqu5K7fx+rVyVlSXc0qHAvmvZd9t8OvUZmZmYDDwXWaPxe0x+6e/xI4JrcNxdjD+mgWMiYr6UMSq8dZx4BqjM4LKd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xl8a/AKf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xl8a/AKf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 270CCC4CEF7;
	Wed,  4 Feb 2026 15:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218261;
	bh=j9k8jxEW4LyG1VXLDqus0kY6JNk323vle8geYp7Pbjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xl8a/AKfVn6lme8LgFjyOLNekUa9Me/xaVIgFLUs+8w1F6rV2mZ+bloFyeHYgoPB4
	 H1pQ/AOY+dJF0cWfaO0I3znpoFgcD/g+XEBB+YvRBOy2F6ZnSr51OI3IUPCTx2DYsw
	 LhQRxxFf3cMhmKzMWf2VZyblb/Oxk/YbJqE87EMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Wilcox <willy@infradead.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Rajani Kantha <681739313@139.com>
Subject: [PATCH 6.1 259/280] iomap: Fix possible overflow condition in iomap_write_delalloc_scan
Date: Wed,  4 Feb 2026 15:40:33 +0100
Message-ID: <20260204143919.017966270@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>

[ Upstream commit eee2d2e6ea5550118170dbd5bb1316ceb38455fb ]

folio_next_index() returns an unsigned long value which left shifted
by PAGE_SHIFT could possibly cause an overflow on 32-bit system. Instead
use folio_pos(folio) + folio_size(folio), which does this correctly.

Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Rajani Kantha <681739313@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/iomap/buffered-io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -903,7 +903,7 @@ static int iomap_write_delalloc_scan(str
 			 * the end of this data range, not the end of the folio.
 			 */
 			*punch_start_byte = min_t(loff_t, end_byte,
-					folio_next_index(folio) << PAGE_SHIFT);
+					folio_pos(folio) + folio_size(folio));
 		}
 
 		/* move offset to start of next folio in range */


