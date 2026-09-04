Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7B03B14B4;
	Fri,  4 Sep 2026 05:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499045; cv=none; b=A6Xs18+G+3mOrvVU/TxpeXvl5rBxvIFu9L0LECToTexk6VFXgPinDhXr4oLn9uyln6TXyLLdYrhoVMg+wqb/+Cd8asLeY/gQuSEtapZNJlb3l9NwCvv0qXbM9DPemO0gqQbTAVTShLhugs+gRD9EJb0xyTdImpa674Hu3i1YQ+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499045; c=relaxed/simple;
	bh=EQMKbaSBHisdfq9CQlxD1WJZ9pUibN8YVTEhw0yTSR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZHGur3aWHY+1srxVk3xEW8bzU49GQBpGwqMQyUxkfid3QmWzXa/rOKnWnkItG2kJY4j57zOSKICQZaj7Aso3J/kTpc3B/tZTyHNG2HBEAm/dzQtyg+F5+Enqdo2i/TcVID7w6Em8y6jUIflrv3aoh0Xf3HNfA0mLmd/nywQaI5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZQyRphb0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZQyRphb0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 704631F00A3D;
	Fri,  4 Sep 2026 05:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499044;
	bh=5vTSPkZFMQUh90YZW8hc+drSmq0zQmD23X5m1Wcl4Qk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZQyRphb0RMvNGq4EuZ5dJgMqVCDAlm+YEninF9O+5v51aRf4pLp2nX/CztncIHWzs
	 S9qZkmprjRlbwX4+bP5LJOVE75xoJr9x/E8bm32eoqdoDQUrip9ouhopdlru262xsi
	 DdZf3B6GdUovXMP8AVfna/3w3En7MKHhTTlmdaSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikhil Gurudasani <nikhilgurudasani314@gmail.com>,
	Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>
Subject: [PATCH 7.2 279/713] erofs: skip sufficiently large global buffers when resizing
Date: Fri,  4 Sep 2026 06:54:07 +0200
Message-ID: <20260904045810.095171761@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Nikhil Gurudasani <nikhilgurudasani314@gmail.com>

commit a7d097cf01301c5da37927c8f26123d006f0fd8a upstream.

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
 		tmp_pages = kzalloc_objs(*tmp_pages, nrpages);
 		if (!tmp_pages)
 			goto out;


