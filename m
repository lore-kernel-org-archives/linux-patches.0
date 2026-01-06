Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80133491C7;
	Tue,  6 Jan 2026 17:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720416; cv=none; b=eoSw2rCiuCyzBLgraMTSoEHDlBWihXdER1O/1L4vTozCVDgqLr35objwbFVgz3x0CSU1IaZq0k61jYg/HXBv3Nyo2kCIHE9hxAe4hF2rnJGPkPJbRkg5ngOZ+o9Wtn5PzKYnWz+KtYv8Kbj0nap6GNxM01l4aOsNYmTBkqppWOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720416; c=relaxed/simple;
	bh=c75WQ9a30GuiMEYj9Wz7FWuK1Hg4WSBmTgxriwXFJ7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l3YGpVt7To/wtfMezYGitaCd8S+HF226PJUA6nWS7P84UEBY4L0kUY6FueUUiGSKuWy8/VQXGQ87HxwITVrLSUQbLvXTtSejUeG/Umy8pN3V5NsBP1h1qRMyxhD31qwmBV2k/0+RYqlSlKY5YZhSCxJytL5+E2kzZ6HAOcXkQB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dd5grY9j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dd5grY9j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 384E0C116C6;
	Tue,  6 Jan 2026 17:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720416;
	bh=c75WQ9a30GuiMEYj9Wz7FWuK1Hg4WSBmTgxriwXFJ7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dd5grY9jhJ08GPosM+u8bbKB8emLLSxBkWWwGJb30L3judySGcHOTWLCbHtfUcFcT
	 qmfX7P0+Vrnqgo+YBX5N+kJPvEjjAWedSZQTy8XuUrbr2axrx4/sEKvgiI9tG7P6io
	 vtJY850hppDOGo6zF/qpj5kJs23yzninOdLfsC94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 230/567] xfs: fix a memory leak in xfs_buf_item_init()
Date: Tue,  6 Jan 2026 18:00:12 +0100
Message-ID: <20260106170459.821373307@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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


