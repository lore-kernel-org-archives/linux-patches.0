Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F5743CED7;
	Mon, 17 Aug 2026 14:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978715; cv=none; b=ZQCO1QOEnE2/0w5Hh1B9ynMrfZJP7jTH1pCXGBvUF0hnLDnfUlYi5NTfzeghaGBQSYpCKY00QeYSCsFrY+zqAEHIbxVmr05MNzLh1quo7LfsUeuT2fU2gIX8MXSjf3p64C5ER5bwBfmQO/wXkePOufKGWgtSNRrOvX+Gl0kBA4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978715; c=relaxed/simple;
	bh=q1yjtH8pvJPkkTvHFBB4OGQAP4I9pZbK7KZq2fF51gg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QNc91A1LoHgb5VoiPRI6aG0AwWKqjqVsgRw/XfCE8nOjfu/cIL3e/l+ObiEIJepBCLmn0frljImYk2cINiizxhxQWujxaQcTKl4bU+x/kbQIONBPjPhlkMduNreYdWtVQl0kDqE+KxsFmabaRKpFBiMVEIuBEcNzxh1GOTi9KjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HHlIWKdX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HHlIWKdX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D35A1F000E9;
	Mon, 17 Aug 2026 14:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978714;
	bh=HtTTgA35HlyUwfjgT2xQj3GnXr9OdSFQlDUpnNvdkV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HHlIWKdXbtr/syrJr0vu7jz6+Bwo+lMAQyNxnF1dvx6dpn5u5pB4GPJ1k0ZxXUiGa
	 qUF33zcDNUH4vPbbzKz7MiUswlAzrYSOLpltmKXopQuyFGvXUYKsOeGGk1AG7bg41B
	 DMN19r+JUP/QOVygVknumXa5T35uqZoYnTFspIcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jun Yang <junvyyang@tencent.com>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 6.6 133/156] vhost: reset the vring metadata cache on vring reconfiguration
Date: Mon, 17 Aug 2026 15:34:27 +0200
Message-ID: <20260817132539.893929884@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
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

From: Jun Yang <junvyyang@tencent.com>

commit de845981da67a6b049080c87e605130b0c30adc5 upstream.

vq->meta_iotlb[] caches the vhost_iotlb_map that backs each vring
metadata region, and iotlb_access_ok() returns early on a cache hit,
taking the hit as proof that the region has already been validated:

	if (vhost_vq_meta_fetch(vq, addr, len, type))
		return true;

The cache is reset on VHOST_IOTLB_UPDATE and VHOST_IOTLB_INVALIDATE, on
device IOTLB (re)initialisation and on vq reset, but not when
VHOST_SET_VRING_ADDR replaces vq->desc, vq->avail and vq->used, nor when
VHOST_SET_VRING_NUM changes the region sizes.

With a device IOTLB attached both ioctls are accepted while the vq is
live, and neither validates the addresses at ioctl time: vq_access_ok()
and vq_log_used_access_ok() return true early because the addresses are
GIOVAs, deferring validation to prefetch time.  Once the cache has been
populated that deferred validation no longer runs -- vq_meta_prefetch()
hits the stale entry and returns true -- and vhost_vq_meta_fetch() keeps
translating through the old mapping as

	map->addr + addr - map->start

for an address the mapping no longer covers.  vhost_copy_to_user() and
vhost_copy_from_user() consume the result with __copy_to_user() and
__copy_from_user(), which do not check it either, so a subsequent used
ring update or descriptor fetch accesses memory outside the region the
IOTLB actually maps.

Reset the metadata cache whenever the vring is reconfigured, so the new
addresses are pushed back through iotlb_access_ok()'s slow path.

Fixes: f88949138058 ("vhost: introduce O(1) vq metadata cache")
Cc: stable@vger.kernel.org
Assisted-by: tencentos-corvus-ai:kimi-k3
Signed-off-by: Jun Yang <junvyyang@tencent.com>
Message-ID: <20260803014823.68623-1-juny24602@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vhost/vhost.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1937,6 +1937,14 @@ static long vhost_vring_set_num_addr(str
 		BUG();
 	}
 
+	/*
+	 * The metadata cache holds the IOTLB mapping that backed the previous
+	 * desc/avail/used addresses and vring size, both of which are being
+	 * replaced here.  iotlb_access_ok() takes a cache hit as proof that the
+	 * region was validated, so the stale entries have to go.
+	 */
+	__vhost_vq_meta_reset(vq);
+
 	mutex_unlock(&vq->mutex);
 
 	return r;


