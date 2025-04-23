Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8AF82820B3;
	Wed, 23 Apr 2025 15:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422341; cv=none; b=q9ZHo1Sn2Ifse0IbNC6iQZ4cIOkrQk3YZ2RJy+vLLJw8HUJyw/nrid9FF1yE2BXsAsnilrtZw8Jh3JBjjVD7oo3Mexpql3aHP61Tq4BaLIvOvLhMwERZGNFRKDzR+o9AtAsgKb9Gpmji8fgdOxhFX4fntCbc2rfrRxkdPN267DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422341; c=relaxed/simple;
	bh=uIo5GPs5NS9U3GpQx6/J40mk1edEC1MPGnCFpWPQ65o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nxBvRfbr1cBN795FIXVReHNB7otJm8eqezbwdKgQl4S7dmO6eRulIDb8GL8C1n10dI7x8qomiLsBtsqQIRIk4aMZXbsa4i5UOu5dZO+GnYud3XyxK4iPiRZo1wUYTt4Qi0NRN7tucamdM6dO5dBc7NjJqL56J8OwyTYOtv5H/B0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0PSRbe2e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0PSRbe2e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBDE3C4CEE3;
	Wed, 23 Apr 2025 15:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422341;
	bh=uIo5GPs5NS9U3GpQx6/J40mk1edEC1MPGnCFpWPQ65o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0PSRbe2eCYBnbVTctGKUhZMwx5NSrgWsKkr33f2O48NBId4rL8rsMgod3oV1yq4sB
	 aatk68Z2eopvwi0Ct3+6l5j1fTqe15bmjoAsNbpf5zZE/GjPvuZLgNDjGCzCRxNa3n
	 lc5BkOR3VFThS3S5k+sfqsN7h9uQr8UMEWt9BnDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giuseppe Scrivano <gscrivan@redhat.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Alexander Larsson <alexl@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.6 323/393] ovl: dont allow datadir only
Date: Wed, 23 Apr 2025 16:43:39 +0200
Message-ID: <20250423142656.675515249@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

From: Miklos Szeredi <mszeredi@redhat.com>

commit eb3a04a8516ee9b5174379306f94279fc90424c4 upstream.

In theory overlayfs could support upper layer directly referring to a data
layer, but there's no current use case for this.

Originally, when data-only layers were introduced, this wasn't allowed,
only introduced by the "datadir+" feature, but without actually handling
this case, resulting in an Oops.

Fix by disallowing datadir without lowerdir.

Reported-by: Giuseppe Scrivano <gscrivan@redhat.com>
Fixes: 24e16e385f22 ("ovl: add support for appending lowerdirs one by one")
Cc: <stable@vger.kernel.org> # v6.7
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Alexander Larsson <alexl@redhat.com>
Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/super.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1180,6 +1180,11 @@ static struct ovl_entry *ovl_get_lowerst
 		return ERR_PTR(-EINVAL);
 	}
 
+	if (ctx->nr == ctx->nr_data) {
+		pr_err("at least one non-data lowerdir is required\n");
+		return ERR_PTR(-EINVAL);
+	}
+
 	err = -EINVAL;
 	for (i = 0; i < ctx->nr; i++) {
 		l = &ctx->lower[i];


