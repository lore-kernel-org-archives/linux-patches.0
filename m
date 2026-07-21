Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8429046D2B9;
	Tue, 21 Jul 2026 17:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654090; cv=none; b=W4PHMrPx1fClEmGSkl9pv9fqjQQinb7I8S9DqSZHQ6xFNfWTU3OAVjpBCJZ6XkXOPQCzERuBVlwOoj2VxL+8VGLerYkUPe5e1RPmrKF91ROg7J3Il6pdPaWw6z1zUJ9JLQtZJKbj7rkxhNFt+xnJdClyv7QDlqCHDezwO+lsKjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654090; c=relaxed/simple;
	bh=Yp+aCI37Ll5jhKbm8ijQKJieOKRaFQUl6NG7nbyrNzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qmma+p00ic/EaDwbZP9XyKCliBqADQQ4LNJOA9/+RDMM1qK8VnQwMdcmEGW1dbnu4M9AJPYmHYjZvGOrHfHAmDEO943ta8xUX1KZVo7rMRG1sYSwiyLrhexbWqOZ+ZMuKYjUTF9BkY78ytDuQ279e1yPE4Wv8EDXmkUbTv/XNMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vssuU3Uo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vssuU3Uo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA1961F000E9;
	Tue, 21 Jul 2026 17:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654089;
	bh=zgchvcEwPCy993hFNZ0WRRbUbemRIaeoO07ydAH8a/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vssuU3UovLdsuPPvfJMk/22svzpxoVPqNco4npM6NtvzaVseEPt+PpumHXj1l+7YP
	 nSvd/xbLjaNq1gT+p1QX5ZFBTRV02g2b5orcZa3xFZNICWjLRtyvcfNV7o4jYOfDJc
	 Y/3irsP5/4zJYlJtDLyaohqQHiSkWcaPahW8goyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>,
	Xie Yongji <xieyongji@bytedance.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 7.1 1519/2077] VDUSE: avoid leaking information to userspace
Date: Tue, 21 Jul 2026 17:19:52 +0200
Message-ID: <20260721152628.611726077@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Wang <jasowang@redhat.com>

commit 9c1523803445ee0348f62b77793266dd981596e0 upstream.

The bounceing is not necessarily page aligned, so current VDUSE can
leak kernel information through mapping bounce pages to
userspace. Allocate bounce pages with __GFP_ZERO to avoid leaking
information to userspace.

Fixes: 8c773d53fb7b ("vduse: Implement an MMU-based software IOTLB")
Cc: stable@vger.kernel.org
Signed-off-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Xie Yongji <xieyongji@bytedance.com>
Reviewed-by: Eugenio Pérez <eperezma@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260130050750.4050-1-jasowang@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vdpa/vdpa_user/iova_domain.c |    2 +-
 drivers/vdpa/vdpa_user/vduse_dev.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/vdpa/vdpa_user/iova_domain.c
+++ b/drivers/vdpa/vdpa_user/iova_domain.c
@@ -124,7 +124,7 @@ static int vduse_domain_map_bounce_page(
 		if (!map->bounce_page) {
 			head_map = &domain->bounce_maps[(iova & PAGE_MASK) >> BOUNCE_MAP_SHIFT];
 			if (!head_map->bounce_page) {
-				tmp_page = alloc_page(GFP_ATOMIC);
+				tmp_page = alloc_page(GFP_ATOMIC | __GFP_ZERO);
 				if (!tmp_page)
 					return -ENOMEM;
 				if (cmpxchg(&head_map->bounce_page, NULL, tmp_page))
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -999,7 +999,7 @@ static void *vduse_dev_alloc_coherent(un
 	if (!token.group)
 		return NULL;
 
-	addr = alloc_pages_exact(size, flag);
+	addr = alloc_pages_exact(size, flag | __GFP_ZERO);
 	if (!addr)
 		return NULL;
 


