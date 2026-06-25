Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 256BE2D060D;
	Thu, 25 Jun 2026 13:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782392847; cv=none; b=uN+Wo9wz8/g3XVX9CmbTJsZvmhJBX/qJqgTPM3xfnosB/oo9EIa/BvZflVG7tnQ4RI+1lGpTlGzbGn4lqjE/SV5fHqBygnIDNhwlwwTNYYAEw1v7/Jv0PqCqlXWYg+H/EQ6POtWc8tvVrB0y1ZYHnHx1ZXi6xKRgfrMdN115YLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782392847; c=relaxed/simple;
	bh=kDuTVcAS6zv9/ASyxWyG6qsZGR0nlFbcNkfyi44iSnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LCL0CFrA0IyS9t9vxzs7BciKPpP1Ptm0ksWX6P8/210s6T0md7Pi+goQlbWXoGwA0jsgssDsmVi12KYyTmuXa3iAInSkLLWq2BCvxLdfaPcP6IpXE0kaFanONadv6nWZYex43kwHI10lvumMsluAhL00rn7GBGOxjMNOzju0jd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=idXImSzQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="idXImSzQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 328711F000E9;
	Thu, 25 Jun 2026 13:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782392845;
	bh=0CJaZdrV/jZiPZTrcP5dAJ4zi4sOxIDkuL9zJ+qd8Ws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=idXImSzQhA6E5bYftl53ah150Ag5VvnBD9WkXPredH4WKp3aUS72iMh5gva0Dq78g
	 622+Vs1qj850WDaiiatloe3arxrOt2hxHWZ+dZWmET4A8atFR4YD7NKxyZhurasG4A
	 jIg8V7UR46IFjpuHGiqxCqlQjfjWP+DDj3DRitdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>
Subject: [PATCH 6.18 27/60] rose: clear neighbour pointer in rose_kill_by_device()
Date: Thu, 25 Jun 2026 14:03:12 +0100
Message-ID: <20260625125649.522306490@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125645.554579168@linuxfoundation.org>
References: <20260625125645.554579168@linuxfoundation.org>
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

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

commit 606e42d195b467480d4d405f8814c48d1651a76a upstream.

rose_kill_by_device() drops the neighbour reference but leaves
rose->neighbour pointing at it, unlike every other rose_neigh_put() site
(see "rose: clear neighbour pointer after rose_neigh_put() in state
machines"). The heartbeat STATE_0 reaping path then puts the same
neighbour a second time, causing a rose_neigh refcount underflow and a
use-after-free.

Set rose->neighbour = NULL after the put, restoring the invariant.

Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rose/af_rose.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -216,8 +216,16 @@ start:
 			 * looping forever in ROSE_STATE_0 with no owner.
 			 */
 			sock_set_flag(sk, SOCK_DESTROY);
-			if (rose->neighbour)
+			if (rose->neighbour) {
 				rose_neigh_put(rose->neighbour);
+				/* Clear the pointer after dropping the reference, as
+				 * every other rose_neigh_put() site does.  Otherwise
+				 * rose_heartbeat_expiry() (STATE_0 reaping) sees a stale
+				 * rose->neighbour and puts it a second time -> rose_neigh
+				 * refcount underflow / use-after-free.
+				 */
+				rose->neighbour = NULL;
+			}
 			netdev_put(rose->device, &rose->dev_tracker);
 			rose->device = NULL;
 		}


