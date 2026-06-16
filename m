Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA03169AD2;
	Tue, 16 Jun 2026 17:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632156; cv=none; b=Pf46GxiOcwKueDGWR/1wEbwSQFm2slIVM9To8eZ6D0lt9fFtF9AsGMnG7uvViCzFBR4tb1AjIIxf+57UAXR4CQXAkLSebeSEtwdvWiuH0+QVy2c88D04aBP5o5nyykbfhoRaXTAg63hnBF8J5Xq95c33ySSQQ+1RqceMu5mU2sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632156; c=relaxed/simple;
	bh=rAPa3QoOiJNlFOpF2lkqXpFqRkfHRo2Zly/gSEsZB5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EdGNRmgxBakiM4iAe6dQnqAAuqc1DmHCxMjrmGc648rE0KUYg2CFA41zK/N9XWuF5NY1T+B/ogQ8afHNN4JUxH+yT1kUGaQRd8R6YMwJdVAmR3bZjVjYPTCn7G2GsFwY7wIBcdffDz+EfNH7lghJ7F3vCEQvL0ID+YQgBQX0k+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=09/2tGMM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="09/2tGMM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1583D1F00A3A;
	Tue, 16 Jun 2026 17:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632155;
	bh=XSxasNlNcqrajhi1yoVgqyK5e5mxN7zVQQg5r0E0fS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=09/2tGMMkeOX242LoeI8fv0nr+BUW1Uypz0j0VOwA3EjLYfeTyDOZcwpyU7IWskWG
	 vMiw9Fi/7ome7avIRUnOzFMd9c8ipaYZXIOBts7vA9DhLUTvqIZnIDs9tzhOBZESfB
	 n96xnohnKgC1idFaDLsGUdy4RyWY0OvLKvlXfIqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 357/522] xfs: fix a resource leak in xfs_alloc_buftarg()
Date: Tue, 16 Jun 2026 20:28:24 +0530
Message-ID: <20260616145142.493302693@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

[ Upstream commit 29a7b2614357393b176ef06ba5bc3ff5afc8df69 ]

In the error path, call fs_put_dax() to drop the DAX
device reference.

Fixes: 6f643c57d57c ("xfs: implement ->notify_failure() for XFS")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[ kept `kmem_free(btp)` and `return NULL` instead of `kfree(btp)`/`ERR_PTR(error)` ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_buf.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -2036,6 +2036,7 @@ error_pcpu:
 error_lru:
 	list_lru_destroy(&btp->bt_lru);
 error_free:
+	fs_put_dax(btp->bt_daxdev, mp);
 	kmem_free(btp);
 	return NULL;
 }


