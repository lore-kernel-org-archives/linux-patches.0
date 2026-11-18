Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032867;
	b=4zyyr7db+65n+oIm2Jp0ZdsqkNeIU2IxMk+wBOJcE2pLsgW4SzAgs9gAKGLVywsP3QEX
	 twI9WWlM/18uaOHgj5KzntcA9Ht+m37xB8dN4qW95rixGKBEnWuA72rvemHZIMVaPeIY3
	 j9kk1kykI0pG3BxoEELkGsO7Vxk/Ie+aogyFCwSLkUnGMX4VqmMCJpUKQfKXt4rYhY13T
	 2Pfmao55ziLKVfpOJJ7roZ9mNlAFUMiWvFTSm2Iv48WTjzgon8ZzqD0L6faymKJTPzy5m
	 tXi8Ij+6nW161FE+Jow39WSUrjNiv7Fj11ZUFCblewq4x7To8v+kY/h4BPg/UbTNUnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032867;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CT0SOOnTTP4j7lJZpmIACreerSnrP2kepdfJ9ubUBmo=;
	b=rFsUwQDVauCDECr7GoYGtkFqE5w/QbwH6+/R2N+Rn4DHrgcwjAtXVK/zHk+x0IlTfxdN
	 Eh9HltfKdlqnrroHsvumtw8nfT9dMtdoK1qTdw4LozQJIkX3DpCCrvzBpzvEDuXvj1yLz
	 0Dmtuc+lBF0Tp0h4h8dP0dsIx7/YYZDJWrcQlmqZt/oOJq5mSIcAgMttlVJPBowJFxrez
	 VtveMDcQwbjSA8ZOYj1Pv93JFAM93bC+/GUvIyHKchWc2lvTX3nZZbph2qKPPx7qp1eXx
	 x1ptc8zTJxX+vv2WvDflP5Twh9v4tT6qqTDupquD+/EtCOChMmqqyFtr1OO7OeXD00g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k4PcVcen;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A632E60A260A;
	Wed, 18 Nov 2026 20:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k4PcVcen
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 045D41F000C4;
	Wed, 18 Nov 2026 20:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032867;
	bh=CT0SOOnTTP4j7lJZpmIACreerSnrP2kepdfJ9ubUBmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k4PcVcenLzuJZwFlVMVKPpOoUWmFqZGrg+bLxDF9+gHZukWsdMgHpstcgQgVdkHA3
	 KMPjxnqNv4h2pmqT0KMKH3XRFry2NwGsKtmFsnOl5ANAgXhb2/QPIE0lGt9W4g6GbO
	 FCfbji2A0LW+S5x2vYG0AsrEckhWLX1Hjdx8IQ/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Markuze <amarkuze@redhat.com>,
	Tal Zussman <tz2294@columbia.edu>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1565/1756] ceph: fix page vector leak on encrypted netfs read EIO path
Date: Wed, 18 Nov 2026 16:01:32 +0100
Message-ID: <20261118150111.844069550@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Markuze <amarkuze@redhat.com>

[ Upstream commit 00a0d7f377f6af59bc559b2e07dffff63eaa5544 ]

ceph_netfs_issue_read() pins pages with iov_iter_get_pages_alloc2() for
encrypted inodes and attaches them with own_pages=false. If
ceph_inc_osd_stopping_blocker() then fails, the request is dropped
without calling finish_netfs_read(), so the page array and the
references taken on those pages leak: ceph_osd_data_release() only
frees pages when own_pages is true, and __free_pages() would be the
wrong destructor for GUP-pinned pages.

Release the vector with put_page() and kvfree() on that error path,
matching finish_netfs_read(). Unencrypted ITER reads are unaffected.

Fixes: 1464de9f813e ("ceph: wait for OSD requests' callbacks to finish when unmounting")
Signed-off-by: Alex Markuze <amarkuze@redhat.com>
Reviewed-by: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/addr.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 63ead85dff268..0c2abc4adea67 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -432,6 +432,17 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
 		osd_req_op_extent_osd_iter(req, 0, &subreq->io_iter);
 	}
 	if (!ceph_inc_osd_stopping_blocker(fsc->mdsc)) {
+		struct ceph_osd_data *osd_data =
+			osd_req_op_extent_osd_data(req, 0);
+
+		if (osd_data->type == CEPH_OSD_DATA_TYPE_PAGES) {
+			int num_pages = calc_pages_for(osd_data->alignment,
+						       osd_data->length);
+
+			for (int i = 0; i < num_pages; i++)
+				put_page(osd_data->pages[i]);
+			kvfree(osd_data->pages);
+		}
 		err = -EIO;
 		goto out;
 	}
-- 
2.53.0



