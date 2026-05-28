Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4EB72D1303;
	Thu, 28 May 2026 20:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999520; cv=none; b=d0/TSXYeh+QkoW4IxwmYO3h+ZaQavuSrES/d/pWZW98ekB21ejDylmCu0jJwrpRZ9sl5R5U6vl2L3aV1tCFf4aOc4SgjGcN+n+UIZvbRMd24waXlNVimCAlnehG6Tyzm1gEJ7Kazb1Qxp3GWhjVUstVkv+68lYzrRy6ZWxHRjfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999520; c=relaxed/simple;
	bh=FuLQikTWTI2tisEmcQR2yB36nfunGXLBQvZYqQuxbYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=khfs3tBDpCrNq8q8s8VpG9HLrN/q08ipvBp7IKIpguxeB9wl3YlzE/+EOEOhgxt1xpagKEd6bXKU3CWGlBFBeVKe7laSk6P3njxJmRcbnlfJ5vw9k265kaF8PxZ5IP63ch5s5CUY1agB/PTFOpsJt7BxNljAiGm6JwKfvHTtfRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NjMu5SjN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NjMu5SjN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F7871F000E9;
	Thu, 28 May 2026 20:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999519;
	bh=yqN7PObfl3EVpoaLTbZT/HZWW8WOP6j4lrOAdFUJZZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NjMu5SjNEe+Y0XbIw1wopiDJFwQmmuoDhXS4x3Wi+oN6tHKAdC+giJkriyX5Bl0MT
	 5CZIzaxYQkb7MqLJ3yiY+hM9G4PBJqcSypEKN7QFJXIW6j9pjQJu68YGWSYiN1MwlP
	 uKstH+vZVVtEmO61InvsjX1X9WWWtlpgefcFIZY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Dawei Feng <dawei.feng@seu.edu.cn>,
	Geetha sowjanya <gakula@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 096/377] octeontx2-pf: fix double free in rvu_rep_rsrc_init()
Date: Thu, 28 May 2026 21:45:34 +0200
Message-ID: <20260528194641.133848534@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: Dawei Feng <dawei.feng@seu.edu.cn>

commit e8fb3de2a8effcaf62bec2c56b93d8bb480371d1 upstream.

rvu_rep_rsrc_init() allocates queue memory before calling
otx2_init_hw_resources(). When hardware resource setup fails,
otx2_init_hw_resources() already unwinds the partially initialized
SQ, CQ, and aura state before returning an error. The representor
error path then calls otx2_free_hw_resources() again and can free
the same resources a second time.

Fix this by splitting the cleanup labels so that a failure from
otx2_init_hw_resources() only releases queue memory. Keep the
otx2_free_hw_resources() call for failures that happen after
hardware resource initialization completed successfully.

The bug was first flagged by an experimental analysis tool we are
developing for kernel memory-management bugs while analyzing
v6.13-rc1. The tool is still under development and is not yet publicly
available. Manual inspection confirms that the bug is still
present in v7.1-rc3.

Runtime validation was not performed because reproducing this path
requires OcteonTX2 representor hardware.

Fixes: 3937b7308d4f ("octeontx2-pf: Create representor netdev")
Cc: stable@vger.kernel.org # v6.13+
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Signed-off-by: Dawei Feng <dawei.feng@seu.edu.cn>
Reviewed-by: Geetha sowjanya <gakula@marvell.com>
Link: https://patch.msgid.link/20260513151320.213260-1-dawei.feng@seu.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/rep.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/marvell/octeontx2/nic/rep.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/rep.c
@@ -609,7 +609,7 @@ static int rvu_rep_rsrc_init(struct otx2
 
 	err = otx2_init_hw_resources(priv);
 	if (err)
-		goto err_free_rsrc;
+		goto err_free_mem;
 
 	/* Set maximum frame size allowed in HW */
 	err = otx2_hw_set_mtu(priv, priv->hw.max_mtu);
@@ -621,6 +621,7 @@ static int rvu_rep_rsrc_init(struct otx2
 
 err_free_rsrc:
 	otx2_free_hw_resources(priv);
+err_free_mem:
 	otx2_free_queue_mem(qset);
 	return err;
 }


