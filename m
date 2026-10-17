Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E2D33C13F9;
	Sat, 17 Oct 2026 17:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257539; cv=none; b=AKzuW8w9Z66U37QwlKG5XHSQdIs+FF6Rs0NTnCmJJZquI8zakVX5U1kpg7T9wEYm9Dd8sCDrjDq1u4/intR/qqeKOoXgCR2GAkD2dfchZR6g1UPBysXp17X3V3gSLwVl3TlcgDrdQgHy9IXl004rJU+yvAqgQidVn0fSArqYj5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257539; c=relaxed/simple;
	bh=dR8oWgf6P6zWo5myQE2CH00ZxZzN3bg8L/1JyCjGWXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zs5bhopwnHjwbmu0Eg6TYdL+JM5ZGNd2P7xdMscQvOE+OLiZTAXN6RE61Le08ZlkjC+yQD0Rl4/rYsmUYsN03lcIP65SiZS59CzlBhbHpS4oPDxjbk+ZmtKhgibbGhWxncFGe1h9wV1/Acv3MJcXKzHJdQ4pVIB8mrT5mBXSwuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YzITJ9e7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YzITJ9e7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59ACB1F000C4;
	Sat, 17 Oct 2026 17:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257537;
	bh=K5x7YkDHB0F06r+E0hf0KncadavIm/vHpwLdV35ruE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YzITJ9e7kyemd23p7lDr2D0oh4/b2lLpSdQxKAQy4np6quEnotqDt2EIgA4Jk+pry
	 cKiB7vkTa4+4oi2q/PaOVpngRp/mI7g67Q77RFBlqopmj4AUnqvZz6h0Mm6xnAvCAL
	 gCuVXGjwCGqV49gI6JbS2zHvvkrfqogxxqAMqjiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Gromm <christian.gromm@microchip.com>,
	Navaneeth K <knavaneeth786@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0591/1674] most: core: fix leak on early registration failure
Date: Sat, 17 Oct 2026 17:47:43 +0200
Message-ID: <20261017160446.253769533@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 2c198c272f9c9213b0fdf6b4a879f445c574f416 ]

A recent commit fixed a resource leak on early registration failures but
for some reason left out the first error path which still leaks the
resources associated with the interface.

Fix up also the first error path so that the interface is always
released on errors.

Fixes: 1f4c9d8a1021 ("most: core: fix resource leak in most_register_interface error paths")
Fixes: 723de0f9171e ("staging: most: remove device from interface structure")
Cc: Christian Gromm <christian.gromm@microchip.com>
Cc: Navaneeth K <knavaneeth786@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260116162950.21578-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/most/core.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/most/core.c b/drivers/most/core.c
index 0fbf06d34e0b9..3d1102faec8a2 100644
--- a/drivers/most/core.c
+++ b/drivers/most/core.c
@@ -1282,12 +1282,17 @@ int most_register_interface(struct most_interface *iface)
 	int id;
 	struct most_channel *c;
 
-	if (!iface || !iface->enqueue || !iface->configure ||
-	    !iface->poison_channel || (iface->num_channels > MAX_CHANNELS))
+	if (!iface)
 		return -EINVAL;
 
 	device_initialize(iface->dev);
 
+	if (!iface->enqueue || !iface->configure || !iface->poison_channel ||
+	    (iface->num_channels > MAX_CHANNELS)) {
+		put_device(iface->dev);
+		return -EINVAL;
+	}
+
 	id = ida_simple_get(&mdev_id, 0, 0, GFP_KERNEL);
 	if (id < 0) {
 		dev_err(iface->dev, "Failed to allocate device ID\n");
-- 
2.53.0



