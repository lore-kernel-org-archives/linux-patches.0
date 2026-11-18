Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026113;
	b=z+fQz61zpZGxqPsK0K8Ebhk8R81RStKYU2UWavqeBrvhiid+U4JquNcBJhyHrMSUsDmu
	 OgiV302DLrjajeFTVH//NUkAHmuErdvWu+hh9i+gjpvaB16J97qhbJ+qCRPUP9h5yEsrf
	 zvUtfoRbZin6ZzPTXov4wKiUoHtHlSVLfLev7/BO0R44m+qoWFAdrGi1s39A6MP0uf9+i
	 aICc0XKzjt1koa+W6Ax5dd4Pz2etu7eknT8lZkUgwa22dBF58fvpwDFi0dqa05inisYiY
	 Q8jHt7BEt/mSPSi8uX+2jvE2k/3WtCh+p0MJthj29mv6eAAdzRvjpY8vnKFHdMJVaKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026113;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5XbRTme/YqhgsPPlSw7m5Gx+OHC0efG59MxZADbcCv4=;
	b=Txe18tdWqWrIeJ2G+AazL8+K5ursU/BlCs0d/tmq1D97UmI1olAH4d+nnjVKXBXQqO9N
	 4swiv634rbXgnxcdf5/JFZouAGaxjnd6sdLmwrXRhVMQL36VWp+5XFxmm9jnW9aDN0UFb
	 RBGdm9kd9pCEjRKJZQUrrgSY8bAFGdbBchA/r919zeu40MrnEvJJuTQEXFa0XKLgKuRh7
	 IzGLYA18zuGNhJz980Hy16vnOLaJzlElfzR+9O5cD21UJ8SfWrcDUPnPxIRKrtF49+DAQ
	 iT9IPooEJx8nIxrOSXGBbB+H0U/vrRP9Xwcqj2Q/98rgj83u6I9O1Sdlo22ntGDhW0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0UdH1UyB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89379606A31C;
	Wed, 18 Nov 2026 18:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0UdH1UyB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C40EC1F000C5;
	Wed, 18 Nov 2026 18:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026113;
	bh=5XbRTme/YqhgsPPlSw7m5Gx+OHC0efG59MxZADbcCv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0UdH1UyBp3dq3uwxgvf/+AspRRBVNwroGz55OVuAKlKVRuc50bjsgd/ulpOCrsMyK
	 aymY1/omTqHh188UB83iKLKXQhsn7Jq8HGv5/T7cM1Mn6HqR9Trkt2n7XA+rU7WJZo
	 Xlv+Sy0vBiJz19VbRENBl4aX7H0JqiLb9askFK+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Bo Liu (OpenAnolis)" <liubo03@inspur.com>,
	Binglei Wang <l3b2w1@gmail.com>,
	Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1318/2151] erofs: fix xattrs handling when metadata compression is used
Date: Wed, 18 Nov 2026 15:50:53 +0100
Message-ID: <20261118150210.103620033@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Binglei Wang <l3b2w1@gmail.com>

[ Upstream commit 6b722cefbf83558af07586ca94cdb4b370d5a82d ]

erofs_bread() reuses a cached folio on page index match without
checking folio->mapping.

xattr.c calls erofs_init_metabuf() twice on the same buffer without
erofs_put_metabuf(); the two in_metabox sources differ, so buf->mapping
can switch while buf->page still belongs to the old address_space.
The next erofs_bread() then reads the wrong mapping, dropping shared
xattrs with METABOX.

We require folio->mapping == buf->mapping in the reuse check; otherwise
drop the cached folio and re-read via the slow path.

Fixes: 414091322c63 ("erofs: implement metadata compression")
Cc: Bo Liu (OpenAnolis) <liubo03@inspur.com>
Signed-off-by: Binglei Wang <l3b2w1@gmail.com>
Reviewed-by: Gao Xiang <xiang@kernel.org>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Gao Xiang <xiang@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/data.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index 3e6b512efe21c..244437a39232d 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -32,7 +32,10 @@ void *erofs_bread(struct erofs_buf *buf, erofs_off_t offset, bool need_kmap)
 
 	if (buf->page) {
 		folio = page_folio(buf->page);
-		if (folio_file_page(folio, index) != buf->page)
+		if (folio->mapping != buf->mapping)
+			/* the cached folio belongs to another address_space */
+			folio = NULL;
+		else if (folio_file_page(folio, index) != buf->page)
 			erofs_unmap_metabuf(buf);
 	}
 	if (!folio || !folio_contains(folio, index)) {
-- 
2.53.0



