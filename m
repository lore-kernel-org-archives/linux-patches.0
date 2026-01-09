Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C9E35BDC9;
	Fri,  9 Jan 2026 12:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962448; cv=none; b=ej6btty103pURHQwr7gEFIkwgvO/PQVYOwDl3uFTeZudeDsVCiTW0PxaRp9txjEy0St5etw9h3Yen/cJVYBc6Et2buDs7Q+mMirEmYimM6oWzD7Fy/I7YfRn44+kYPpHkyyCN7mg+F95KWNWSXHWRhQzcj/QN22NI8TDLgCjth4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962448; c=relaxed/simple;
	bh=u9JH3aw8k9FfIT0jWqqz3pVcluseXNLHGjQU6caxWRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tf5AdUgsCKcG8igpvBlma6T+/0N7S4uBDY+3lHsTWrOc1B2f8QbeBVqOfUpvXOym6HPdwRl7D0548e9rnIm1GVNE+88grgCj572cSx3j+t4E8OBOWHUWXV3YuPPiFiqsF+WyhG0e3VIrhjCKCYxwUPTrJTwCywp5cCrMzaAtYFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g9FxnI8z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g9FxnI8z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A79D4C4CEF1;
	Fri,  9 Jan 2026 12:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962448;
	bh=u9JH3aw8k9FfIT0jWqqz3pVcluseXNLHGjQU6caxWRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g9FxnI8zjWqkprZRFuHGYe4bj00Q6amaNN9U2+bUd4c8iPx1C8OQ7AftdGIs4Rk5Z
	 qN8IAqLVro8WTJsQFUqGdW/9/mCOBMjyyJ/kFOwqD3K9NRdkQaBpXAp4PZH9qBpp14
	 yVInLk+yUcsPls137bYf1+lH6Y7ReQwf3zeSZpTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.1 368/634] xfs: fix a memory leak in xfs_buf_item_init()
Date: Fri,  9 Jan 2026 12:40:46 +0100
Message-ID: <20260109112131.378124302@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

commit fc40459de82543b565ebc839dca8f7987f16f62e upstream.

xfs_buf_item_get_format() may allocate memory for bip->bli_formats,
free the memory in the error path.

Fixes: c3d5f0c2fb85 ("xfs: complain if anyone tries to create a too-large buffer log item")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_buf_item.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -900,6 +900,7 @@ xfs_buf_item_init(
 		map_size = DIV_ROUND_UP(chunks, NBWORD);
 
 		if (map_size > XFS_BLF_DATAMAP_SIZE) {
+			xfs_buf_item_free_format(bip);
 			kmem_cache_free(xfs_buf_item_cache, bip);
 			xfs_err(mp,
 	"buffer item dirty bitmap (%u uints) too small to reflect %u bytes!",


