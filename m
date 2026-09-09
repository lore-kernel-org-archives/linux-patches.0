Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49A757F73E;
	Wed,  9 Sep 2026 14:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964638; cv=none; b=Ut1V7+4LtfC35WBEDDH1tKS0zrWlonRxNeZrsP9aHVWPJER6TbpED/fd5yt5fH7MgsZJaZLRK45YvTgRkMX0CnpbLNXGyU8sKUXQniJ9eCh7IgjMpKBLgBNXb5vE+vMXbMKg8zqecPSKsFE2+eRCr/2T9LHaua9dgc04iE5+3WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964638; c=relaxed/simple;
	bh=hPNC2CvLkRlKG7QaJ5EuO9NE+jGo1jfM3rXN3YaOkBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bDOPV8xNsau6MN9usKVzJcfxbjiL80NaxevWMGE0ZbSF4hMy2FhEVjrj02s7pQUhzu3ANec4kafYItjmjNVUmJKnmaaIK2y58Ch9ZdZ1BRpY4FV5qyd7bUzONYZx5sQMv7myhlMT5Hybn8rxtsUAr5hi4M9jliHpN5zGiQ/sOdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ccRNa42t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ccRNa42t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FA0C1F00A3A;
	Wed,  9 Sep 2026 14:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964637;
	bh=D0L9KTtbDrAtzGJYW1efjkh+GQv3q7teORVLR5vSdRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ccRNa42titKDrLuj/p9lZ+MF6rYSbaVGOOxPNd7tSBkMCQscqi2Kz0fDM9nDCTDsZ
	 WBvZL6aeZl7K7VgFa9jWYmpZMzg/ZHpW9P7WTp8Nfu7du+as4tnH2eX/Ip+ul8ODxK
	 8hRkBNUtRlYJdsjGbMjG8+Q+eBFaOoRpSGBmkjbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikhil Gurudasani <nikhilgurudasani314@gmail.com>,
	Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 475/583] erofs: skip sufficiently large global buffers when resizing
Date: Wed,  9 Sep 2026 15:42:40 +0200
Message-ID: <20260909134254.316896054@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikhil Gurudasani <nikhilgurudasani314@gmail.com>

[ Upstream commit a7d097cf01301c5da37927c8f26123d006f0fd8a ]

z_erofs_gbuf_nrpages is advanced only after every global buffer has been
grown. If a resize fails after some buffers were enlarged, a retry
revisits those enlarged buffers.

Retrying the same size then returns -ENOMEM because alloc_pages_bulk()
has no pages to add and the unchanged return value is treated as a
failure. Retrying an intermediate size allocates a temporary pointer
array smaller than gbuf->nrpages and copies more existing pointers than
the array can hold.

Skip buffers that already satisfy the request. Once all remaining
buffers have caught up, advancing z_erofs_gbuf_nrpages again describes
the guaranteed minimum size across the pool.

Fixes: d6db47e571dc ("erofs: do not use pagepool in z_erofs_gbuf_growsize()")
Cc: stable@vger.kernel.org # 6.10+
Signed-off-by: Nikhil Gurudasani <nikhilgurudasani314@gmail.com>
Reviewed-by: Gao Xiang <xiang@kernel.org>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Gao Xiang <xiang@kernel.org>
[ preserved the existing kcalloc() allocation instead of upstream kzalloc_objs() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/erofs/zutil.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/erofs/zutil.c
+++ b/fs/erofs/zutil.c
@@ -79,6 +79,8 @@ int z_erofs_gbuf_growsize(unsigned int n
 
 	for (i = 0; i < z_erofs_gbuf_count; ++i) {
 		gbuf = &z_erofs_gbufpool[i];
+		if (gbuf->nrpages >= nrpages)
+			continue;
 		tmp_pages = kcalloc(nrpages, sizeof(*tmp_pages), GFP_KERNEL);
 		if (!tmp_pages)
 			goto out;


