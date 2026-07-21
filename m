Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A0E47142F;
	Tue, 21 Jul 2026 20:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664779; cv=none; b=ez8f98ZJTJGQb0ZfPrj4llBWCZT7Q75//NbANbxgH0uI0eElpabCDdWzaTuxULFulYKRTqh1rXJISXTFaCQPJ3pN2xwcigONSmgxOokQa8D0q0nf6z8z7CX4VD8gSCg/losN3Sc7gqNKf8ujQ414SSDqvtn0uc/B5iaPEtpM1lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664779; c=relaxed/simple;
	bh=/FqIDaoR80OaNHgwv9IE+IY0/9NGVw4Xbseu13VsKe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d3oUMED3ZQ7X7UC3TEL7moRY4YQVEo8oiUoR2QYtG8yDAXa5MFTssuxkWHGD4pct9zXgO6XBSxmB3RjpC80VSMfCLX8IjZjzHmENRjmghE7pHG7ezCcV1N7bbqULb0QuUNvl0JiWXWPUfnNKEG657cPAKyhqk9ll330bIOPgsqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A3hSEwdz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A3hSEwdz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37EDA1F000E9;
	Tue, 21 Jul 2026 20:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664777;
	bh=qMmyhTyh8BvVPryuHyqyJi6h04HXR43KBQH54EUfYhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A3hSEwdzSpAK6vFEN91g8sQ2GdEyFTMNZRj5fn3IvYy23LtTZ9pBruPA53LGR4W0G
	 CSX3IhMP1vZy48tRYMPPjTqVVflW6PeVa+sB53dTCt1JayJWk/N2jODwcqb0yndrE6
	 Ay/BUii/d60ud6qE7QKK87IfMQUZ2ZYNzFiue1Kw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0056/1266] xfs: dump the recovered xattri log item if corruption happens
Date: Tue, 21 Jul 2026 17:08:13 +0200
Message-ID: <20260721152443.053831950@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit a51489e140d302c7afae763eacf882a23513f7e4 upstream.

If xfs_attri_item_recover receives a corruption error when it tries to
finish a recovered log intent item, it should dump the log item for
debugging, just like all the other log intent items.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_attr_item.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 929a53db22462f..94e16f51a5ac52 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -672,6 +672,10 @@ xfs_attri_item_recover(
 		xfs_irele(ip);
 		return 0;
 	}
+	if (error == -EFSCORRUPTED)
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				&attrip->attri_format,
+				sizeof(attrip->attri_format));
 	if (error) {
 		xfs_trans_cancel(tp);
 		goto out_unlock;
-- 
2.53.0



