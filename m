Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13136175A99;
	Mon, 17 Aug 2026 14:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976446; cv=none; b=SZjGCwpM3aJv5FsSAmwxlzDuTuDBCSTNCr+dkqpezcG/Oubvk3rPPJEaPK0NbvA83AzKBEaOycexl8x/K6mThB7pUfhaQEjJckxj4/bz+uKsvaVPj5BzTC5pr7q22OYYKkS+XqQXxHi9X2JXti5eIszQCUEcQ1hKPGeRIIpQn54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976446; c=relaxed/simple;
	bh=ncBikIjoXFdIRPfxqGkLZwtvNSkWkJ8C9xOnmU/U89M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C2hUT59U2u5d1iDN7aQXlUrLWpMErptuHmb6Ahy9R/M2Xjsip9sxHhcb9hqsijMKmgKrrnPGQ+BLZMQibb/E8CthIz2ctmSqpGlHlOcihDX2YNgkm1Hpjmed+CdIk7RnfPUA0lMRkwBvFxZrFkxwFtuvoRtE3JIx64iZt/9rf4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J4XEliLK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J4XEliLK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 636A41F000E9;
	Mon, 17 Aug 2026 14:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976444;
	bh=zcl1oDUU+SX8XWE+oyzQ6CAK9Lx/uai6XU59y+rb8vQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J4XEliLKlPHmwVnR4jijta8AyDqnBEaKfUpZBPZY4xp9csSdmDXeUk+9zU7bx/0lw
	 W0p4hAGmBLIrskuaxpD7+N0v+HHXIiN8OrwMm0QdgFzEsJGO+x8G3TA/WoXYGGJWM7
	 QvJOTiMfMTwPaXfdcdmqzIZ4II+ed0zHWprWkIvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jun Yang <junvyyang@tencent.com>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 5.10 376/389] vhost: reset the vring metadata cache on vring reconfiguration
Date: Mon, 17 Aug 2026 15:33:35 +0200
Message-ID: <20260817132553.361241625@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1577,6 +1577,14 @@ static long vhost_vring_set_num_addr(str
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


