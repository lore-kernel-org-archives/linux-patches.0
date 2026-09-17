Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F253B4ABBB5;
	Thu, 17 Sep 2026 15:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660714; cv=none; b=PiiBqwkfqVYHNgEUh6PVJbF4rRzoCOOOpwrlbnkthRfEPRkhnsjc/s1vTfc2STJf/Q4E4MY2s/JxZeRbywWQ1OOmwNFfV5LGnv3box92ebt/JulpWpBrV7hyCZjrjFi+KOkdlZB4OLl6ExIZZCdDmrLKXc2y8gV2LilAIq8VTME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660714; c=relaxed/simple;
	bh=3ztpZQWj635zPXkBTqN+Fv28o+QRtDApareCVPCbaBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aAt8GaKzXQqHo1EFDdatN9sFocX4dQWYFeCC4R3bL0FnbwO0cbDyC2Xsrwkvf4tRgNbc5AxGuSQft/vaBtPxDWDPMLzsIlZnAbyxeQbHi45/f6tUeFc0SZTrNQ2+1sA+HV548ZDHHOsbwrEDsuuWUkHdG7jxmQtPfArcMNpzX9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LRMswMRe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LRMswMRe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 093A91F000FF;
	Thu, 17 Sep 2026 15:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660712;
	bh=oE9Tu9XAH+le4UQZzxwzfhs0Hj4Sg9Su7MqLx3OlELI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LRMswMRefy1TgxaghxuPr2Apet1TOKEp5BSv1MCn3N01nxwhCqatalTz8b4iSUTYx
	 k6s1iWm7uJaiouJVZ84WPnFChvhq0EPJbM+mv0VzxIg1MMrzu/EG5hScDbGDf41iLn
	 6jK6o4BjAvyscjh6lvXBF1ZfsSLNY7wfRaOGsIjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.2 684/733] xfs: bail out on bitmap errors in xrep_agfl_fill
Date: Thu, 17 Sep 2026 16:16:32 +0100
Message-ID: <20260917151409.826727719@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit eaf580538eb1be3d162400d04c4b7dc4c627296b upstream.

LOLLM also points out that the xagb_bitmap_set call in xrep_agfl_fill
can fail, but we don't check the result of xagb_bitmap_walk, so we
silently drop the error and proceed with inconsistent incore data.
That shouldn't be allowed.

Cc: stable@vger.kernel.org # v6.6
Fixes: 014ad53732d2ba ("xfs: use per-AG bitmaps to reap unused AG metadata blocks during repair")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/agheader_repair.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -699,7 +699,9 @@ xrep_agfl_init_header(
 	 */
 	xagb_bitmap_init(&af.used_extents);
 	af.agfl_bno = xfs_buf_to_agfl_bno(agfl_bp);
-	xagb_bitmap_walk(agfl_extents, xrep_agfl_fill, &af);
+	error = xagb_bitmap_walk(agfl_extents, xrep_agfl_fill, &af);
+	if (error && error != -ECANCELED)
+		goto err_undo;
 	error = xagb_bitmap_disunion(agfl_extents, &af.used_extents);
 	if (error)
 		goto err_undo;


