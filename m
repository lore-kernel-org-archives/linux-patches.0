Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F46441638;
	Thu, 30 Jul 2026 15:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425067; cv=none; b=kaxst9b8Fob9sPN2dTiicf/Vim29UFpB6tkGDX5hl3LVQRNVAppV0azK8F3usV0mRvOlqLqRMWYQjJajL5SZwGGMhhJUY86YezUDXGMps2okWisT7675Cm22mJQRwZIeNRrJvF6/7AQrzObwiyi2YwQdshcEm/SASbIpEoBFMXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425067; c=relaxed/simple;
	bh=9G5lmVQBEWwJewDc0yi0zS4JXgbdvE1YrxgaY8RS82U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XzL1sw7FfvoUaEpw4vrv8XzZB2A55MqCP2WFAJsohqy8+7yufXY6agFVFOyKzM3vNDsbYws8oZ7JLMcLyq7YStjT9mTYvmRrUxBb1O2Fk4cmGTYfoQgFQAGOHKUdgpJDPLwXh670RCuuMQxNoFW+TW5FzBMXCnyNmPEOTxKH9ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IZiXjCxk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IZiXjCxk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C40D1F000E9;
	Thu, 30 Jul 2026 15:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425066;
	bh=yh8UU+1BnOj3kaRPB3fz7Rwuaz616eXhveZOQLeuHL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IZiXjCxkv6YHANH3W55nkLwLB4RzgljMw9JlU5mJ7C6tR23X1PJs9zg/aoYazU20q
	 detknrX/t9XjCptwoZC3HyLcJnuB589V3jo+vr65pMK8+i1K0XIp8pJeUxMZDsfghO
	 osEH2s/KdYw1mf2RxrlFu5/2KVyCNeS3D4vDNJt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>,
	Xie Yongji <xieyongji@bytedance.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 615/675] VDUSE: avoid leaking information to userspace
Date: Thu, 30 Jul 2026 16:15:45 +0200
Message-ID: <20260730141458.187905492@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Wang <jasowang@redhat.com>

[ Upstream commit 9c1523803445ee0348f62b77793266dd981596e0 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
@@ -930,7 +930,7 @@ static void *vduse_dev_alloc_coherent(un
 	if (!token.group)
 		return NULL;
 
-	addr = alloc_pages_exact(size, flag);
+	addr = alloc_pages_exact(size, flag | __GFP_ZERO);
 	if (!addr)
 		return NULL;
 


