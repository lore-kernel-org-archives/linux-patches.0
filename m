Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7083F2F0C5F;
	Mon, 22 Sep 2025 19:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569661; cv=none; b=SpFZkU37oH+xVSqiwHkDe5jZA7rcFC3rz+CTJGasx/LYYTigA20Wq0zopA4daOow9abadxwMRqNJGF2bTX8D6eqouLz1roJPDPxMHtKzIpZjhCmqqr+WwHsGivjoMs7Tw5G3Q2Qy3HHs9l28jLChX8Lt5HrbRgcnps1fiehoXDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569661; c=relaxed/simple;
	bh=O95EqnRdJggBdCRjeb1IsUPnzn7995LuALcYw6rPGJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CwOPvheqgiHgOnn2+AO9VOculPVIdvNkLHaeEHCf2UrrUa+ulWy7o7MJ5vfn7PGhyZLN/RhWg3zz7QFzOin/uk5xdu+W1XFlIcLNfxN/hWEly2lw1dCBAP48mf2oAkIBLwaX3Jehpo4SL0gNwFi29F1vrmzK9IzWpERNWjEk1Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bT31dqMB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bT31dqMB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D39BC4CEF0;
	Mon, 22 Sep 2025 19:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569661;
	bh=O95EqnRdJggBdCRjeb1IsUPnzn7995LuALcYw6rPGJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bT31dqMBOR9JJBIRUf5KwZdIKeTQLGUsunVCOjIP7TkKZ/ZO71j2BEGLvUA8gvum/
	 CHX6p1e4zt55HZsBHHp9bY0qNiDhvZ9vTpcRC3QurIQ0VlZT9FxvG16CZi/C11g8Mi
	 kp+HtjyOkegdxE/CUtwdHHR0pWBwCwQ6fDpEhU7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 08/70] um: virtio_uml: Fix use-after-free after put_device in probe
Date: Mon, 22 Sep 2025 21:29:08 +0200
Message-ID: <20250922192404.702360177@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192404.455120315@linuxfoundation.org>
References: <20250922192404.455120315@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 7ebf70cf181651fe3f2e44e95e7e5073d594c9c0 ]

When register_virtio_device() fails in virtio_uml_probe(),
the code sets vu_dev->registered = 1 even though
the device was not successfully registered.
This can lead to use-after-free or other issues.

Fixes: 04e5b1fb0183 ("um: virtio: Remove device on disconnect")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/virtio_uml.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/um/drivers/virtio_uml.c b/arch/um/drivers/virtio_uml.c
index 8adca2000e519..d790acfc2c674 100644
--- a/arch/um/drivers/virtio_uml.c
+++ b/arch/um/drivers/virtio_uml.c
@@ -1229,10 +1229,12 @@ static int virtio_uml_probe(struct platform_device *pdev)
 	device_set_wakeup_capable(&vu_dev->vdev.dev, true);
 
 	rc = register_virtio_device(&vu_dev->vdev);
-	if (rc)
+	if (rc) {
 		put_device(&vu_dev->vdev.dev);
+		return rc;
+	}
 	vu_dev->registered = 1;
-	return rc;
+	return 0;
 
 error_init:
 	os_close_file(vu_dev->sock);
-- 
2.51.0



