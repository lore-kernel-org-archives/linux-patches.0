Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58FB1349AF3;
	Tue,  6 Jan 2026 17:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720420; cv=none; b=ZSnkUfK/wSksINoGfT568/AbQaWa7WRn13yyqkPg7kaadGbgdbYtiwILitBlpKV7Bsv2i5YivLZDt/KfZX9Qdd/fSSFfIA9Zise2NL1SWHsv3dAdxFRwbXAT8lrPla2pGr4KNFtk/RM6mIrEveE0JC5p4f+UzMitl2tKGP6NYE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720420; c=relaxed/simple;
	bh=tqsKkianiRvbwxjzCXLGZZHsNWBMN3x52CQXBBaOw/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KlN/DYIFZvOd+lKOdNigofNGSYc5g3fxLqqmJsmyLjBk/JcFIPpQzRq6Dfs5y1gm1zcaPNy9I46UJsLUvaTgqk9HTvZVpovQJOqhpXPsqKvnu9W4cKeIbMu3Ie6CsSF8wPgu6Ov3e80gW76zxzxiVA9OIExeEtyB+LMHsFbB9bE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D7oTi6pi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D7oTi6pi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9932EC116C6;
	Tue,  6 Jan 2026 17:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720420;
	bh=tqsKkianiRvbwxjzCXLGZZHsNWBMN3x52CQXBBaOw/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D7oTi6pi2TMB+YEZdR5D3q83SSw+9ai6IQkoa/Z/KKScpprGMya1lvX88Ts/vBrKv
	 +wFovio2/bc6kuIFV1gXF6xobQyYvyEX2HCsGWbES+DgTC5roFinuV6W0jcSyYBi7K
	 cYPE7LnwxKhgZVxjxhDWKKqkfDer39qNZtOYpfXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 231/567] xfs: fix stupid compiler warning
Date: Tue,  6 Jan 2026 18:00:13 +0100
Message-ID: <20260106170459.858064007@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit f06725052098d7b1133ac3846d693c383dc427a2 upstream.

gcc 14.2 warns about:

xfs_attr_item.c: In function ‘xfs_attr_recover_work’:
xfs_attr_item.c:785:9: warning: ‘ip’ may be used uninitialized [-Wmaybe-uninitialized]
  785 |         xfs_trans_ijoin(tp, ip, 0);
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~
xfs_attr_item.c:740:42: note: ‘ip’ was declared here
  740 |         struct xfs_inode                *ip;
      |                                          ^~

I think this is bogus since xfs_attri_recover_work either returns a real
pointer having initialized ip or an ERR_PTR having not touched it, but
the tools are smarter than me so let's just null-init the variable
anyway.

Cc: stable@vger.kernel.org # v6.8
Fixes: e70fb328d52772 ("xfs: recreate work items when recovering intent items")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_attr_item.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -739,7 +739,7 @@ xfs_attr_recover_work(
 	struct xfs_attri_log_item	*attrip = ATTRI_ITEM(lip);
 	struct xfs_attr_intent		*attr;
 	struct xfs_mount		*mp = lip->li_log->l_mp;
-	struct xfs_inode		*ip;
+	struct xfs_inode		*ip = NULL;
 	struct xfs_da_args		*args;
 	struct xfs_trans		*tp;
 	struct xfs_trans_res		resv;


