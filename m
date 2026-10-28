Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207867;
	b=g+dFmPtVVQJbnxdlRVncJXIPqn2f5O7CpR70C2Na1ihXMT3H+apmg60S14Id7NW1uSCq
	 M4tR4HtdIEaPsqFYmEXFHLUUR6M3sjlLkz2fxLzKxJB2hGqtoIG/5xQ/mV1GfZu0yEYq0
	 tXv14s13qaWy8vT/b9Ofe3IwiFZFh8w/zujWten6o+QKinin9tjoUZ6oYAEssx+N4t2z8
	 aHwfVlnPPeMHjfao62Wb6EoMhdOL82HOHNLpVstyOdYpE0rDqXjgtVPVYhwQSOLrsiprc
	 p7kCPYzCCm5jFBLps2Fnkbnq6penpWXLQveJlR0I6/d+xNqXCxyuBtb416y3gilux6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207867;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sTlDlhSafCMY3Z4KzRHJacyvDiwqEUTyU7urvpA8+9U=;
	b=QJhcbnS2F79swCjg3UogrZQRud0FpA3S9U/VNgVKGUKG9MCjhfET89d9Wt2/wuBd+60E
	 qjxeHyvAiyJJq4FDXd63e6VFvo48XmMtlPPUUoLfCXv7N9BGMmyp3u1luSD/PNXv0vyOU
	 5fOVkZ6R2A5uhd8P9Lde+n5wZxKfC0gvFmEGvndvg400W5gDo5rHxZvXyVulA/onclnBj
	 NPad5sYW6FxP5HE9Kzub3ut5ADQmVvGASGMXWL/spclUWbCUvi/HnnqQAw57TX0yiwTfm
	 oHcZVKgbKsM/wzf/Am0CSyHuu5g9fScZXvxKRgZCFD/90FMTidHqgtJwoif8RgE4iFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JcVPeTdC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C763560A2604;
	Wed, 28 Oct 2026 17:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JcVPeTdC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D654F1F01828;
	Wed, 28 Oct 2026 17:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207866;
	bh=sTlDlhSafCMY3Z4KzRHJacyvDiwqEUTyU7urvpA8+9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JcVPeTdCjDYYzmU08DDyUJnwbmcUmtnGeocNpgM2l3SjldHZrAG9doKs/szXfKz19
	 1vnUsGxR2DzIr+uUW47gHbolmRNJD3MGTBQp19FaePY7ySNtknD3aNG+Zlgw6KB+V6
	 9qx/vHBC6w/m4+QxZnyjR+xe/m2afqT3EUbVod9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junjie Cao <junjie.cao@intel.com>,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 166/247] netrom: fix reference count leak in nr_rt_device_down
Date: Wed, 28 Oct 2026 17:59:29 +0100
Message-ID: <20261028165951.350748510@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

From: Junjie Cao <junjie.cao@intel.com>

When a device goes down, nr_rt_device_down() clears the routes that
use this device. However, it fails to drop the per-route reference to
the neighbour (nr_neigh): neither nr_neigh->count nor its refcount
is decremented when the route is removed.

Mirror the behaviour of nr_dec_obs() / nr_del_node() by decrementing
nr_neigh->count and calling nr_neigh_put(), so that the neighbour
reference is properly released when a device goes down.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Junjie Cao <junjie.cao@intel.com>
[F6BVP: rebased on the single nr_route_lock; the list reference is
still dropped last by nr_remove_neigh_locked(), so the neighbour stays
valid while its routes are removed.]
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
(cherry picked from commit b0f6830b24b75618e299c8e5451367e8742272da)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netrom/nr_route.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netrom/nr_route.c b/net/netrom/nr_route.c
index 10294cf068f8a..67d9ed0006b40 100644
--- a/net/netrom/nr_route.c
+++ b/net/netrom/nr_route.c
@@ -526,6 +526,9 @@ void nr_rt_device_down(struct net_device *dev)
 			nr_node_for_each_safe(t, node2t, &nr_node_list) {
 				for (i = 0; i < t->count; i++) {
 					if (t->routes[i].neighbour == s) {
+						s->count--;
+						nr_neigh_put(s);
+
 						t->count--;
 
 						switch (i) {
-- 
2.53.0



