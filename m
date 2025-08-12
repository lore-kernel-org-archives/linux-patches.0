Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1453A2F7461;
	Tue, 12 Aug 2025 17:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020209; cv=none; b=c9NSXgPBMus9y0k+CDEwi6CkOaSwvTvat9o2E/lVbmDOwHmYCAEq+F21VI73uhYRIrkEtN1H1htcn0XMUVMH4xc6WurdvW77NdN+RWnAKQRHsgkWcHSZWBLxNR0tLJ84eOqWbU1B7mNhwPScOVta4weEI2BQrHnlSooksxNLrZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020209; c=relaxed/simple;
	bh=Bo7BJSoAcIdaeV8/8LTWKdnEFWhik4Ie/wAgADto+1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gGDXF/H5oT5Wk9EY2XHMyJP29bsEQMxbZ3CexiBZ4IyRvjW+g+ewIRw+cGvK1IUOxl/Q+ssB3h74H/W4T6SPlQe2g6U83a1a00QvSmt3R8ai3vRtuqZcTmcUXmVD5PMix72AVTMV1/zb8iVy+O0PLCVnii/JghyJGs51eIfy+Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZgyOy7Xz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZgyOy7Xz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AEE2C4CEF0;
	Tue, 12 Aug 2025 17:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020208;
	bh=Bo7BJSoAcIdaeV8/8LTWKdnEFWhik4Ie/wAgADto+1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZgyOy7XzPJ/ANQls9qVEBuYCAStU1Ph5TQiASVKuLfllxVv9eDEdTbIDdZnkRRTAx
	 kebxea3ooczZHiqrgiBpkWoMrVgbNZnUvqZ3pdWqZHnGWNC2bcC+BZnIeaR2fwU10l
	 7nIrsHhGZL8ZVUEQZbbxYbK5jN7CFG21sLl+HTwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 011/253] staging: vchiq_arm: Make vchiq_shutdown never fail
Date: Tue, 12 Aug 2025 19:26:39 +0200
Message-ID: <20250812172949.182892749@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Wahren <wahrenst@gmx.net>

[ Upstream commit f2b8ebfb867011ddbefbdf7b04ad62626cbc2afd ]

Most of the users of vchiq_shutdown ignore the return value,
which is bad because this could lead to resource leaks.
So instead of changing all calls to vchiq_shutdown, it's easier
to make vchiq_shutdown never fail.

Fixes: 71bad7f08641 ("staging: add bcm2708 vchiq driver")
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Link: https://lore.kernel.org/r/20250715161108.3411-4-wahrenst@gmx.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
index 44ab7ea42fc85..3fafc94deb476 100644
--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
@@ -714,8 +714,7 @@ enum vchiq_status vchiq_shutdown(struct vchiq_instance *instance)
 	int status = 0;
 	struct vchiq_state *state = instance->state;
 
-	if (mutex_lock_killable(&state->mutex))
-		return -EAGAIN;
+	mutex_lock(&state->mutex);
 
 	/* Remove all services */
 	vchiq_shutdown_internal(state, instance);
-- 
2.39.5



