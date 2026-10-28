Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209608;
	b=eJ6tirdncnmqHM5oO3N3ym7B2hRH9rPFmgZYA4765fDsqdfUTHZ5oH6vCrr5vFD7oOUE
	 8EX70OSB7HEzFEeAQt2F89sfqvvfEquqC1unMxbIxw7+8XZaiOwTTfKXMqHV/3t83B1dU
	 QaZV1E5hvuIKSZUxDeGQm/vV6oX+mr0TxpRFVPqUUE7CMJOdyac8uxdgOXbAB3xyAhw1g
	 9pwpY2cPCct7MDdFThuBMTjTMx3c4kWDwO4+UwH8+eMRnDmwbO1OP6/FBESKP0eGvWgCz
	 b/njtEUctcOrAJklpQMzrOwDH9qQxj6OTxOk0jZcZk0qISeIayvt9b7XX6Vy9nAuGyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209608;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JnlV1eqYjWovXbUYwYQxWAjZocdybpTp+yG5i74O6b8=;
	b=0s2pGEfUVgbCJOW95o6IdR1zyHhHwpBJq5ZAk4nTfqfAA0Jo+AtcdeqgE+BJH9zwQ57t
	 8x/tWhcx1EIevZpo71eeTPHFtFbUawD8fj1cbrv0ydhK/sPrDh7Fu4HwAkBxzt2HHGFPc
	 4tKEyHid2zyx0gvAq3ol8UjrXQKHvcw2Dfmo47XtWVkmlGtocX5oZZQYdLDcdNBIiNOpX
	 GRsZUHCpG9kB9dzHFmAXZE+FNUvTu60dX4EUaaxdmLtifCMStIS03+Kq7Gah/Avd3IRhu
	 NTTHdFrLo13Zc5seR75kFR3A92QFUYpuPs+DlE4OnjVuDzpd+o+vM4H8IetjGwzLFuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RhIRcsIN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64289606A321;
	Wed, 28 Oct 2026 17:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RhIRcsIN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A731F01828;
	Wed, 28 Oct 2026 17:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209608;
	bh=JnlV1eqYjWovXbUYwYQxWAjZocdybpTp+yG5i74O6b8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RhIRcsINFDZoaZhwI4qOpCIyN408fqdHn+cjO+Pt79VDQ5gERJlMxrGCaX7oPvFpO
	 7Gh5Va1SEZBNBtBpzARgCEW0zTEXdcVDWSY6MFtYYYw9Z6njl6V+lejKjQXXDYmu6D
	 /cn3MElydKk0WKFL1WfbhuWJKA7izTTEaHNlh1vY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junjie Cao <junjie.cao@intel.com>,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 015/109] netrom: fix reference count leak in nr_rt_device_down
Date: Wed, 28 Oct 2026 17:59:59 +0100
Message-ID: <20261028165942.723399057@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
References: <20261028165942.357251485@linuxfoundation.org>
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



