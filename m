Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B22A2253FE;
	Mon, 10 Mar 2025 17:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628395; cv=none; b=RKqx0DlKL24JjvAb06ofDeHhAdfQWy3eCraIXp662aEHwIPSsqF7Q7oMVFbD0OhOkPoxj714pMswmbtuWeoZ3geqUPP+eUB+uNvAAmJNJoKNMZspBDnE1/1i33LkoQ/yhxiJgqlciaz6xMcSlgl7rOwKlvSTlYqZCk5YjIvN7Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628395; c=relaxed/simple;
	bh=etNTLrtl0VAfpbvDzYO9miSkQNzDePbGjNR0pAOsWJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gQX6uSN/VXhwFgwpAB/Ua2lABIlYWd5wwmfbvyAkj0w4cmWlWh4uXXrg/JyBgvWExbAx+H2KnQ6xz0XDHE0665ByJ2x7V8Aw6RMgDZMCKhLuxSyUdKZudJQjVbwQUeTa7ZqWw0dnjfB0i/LPXZTuKnwEhut0pjzZdGDq5UACJco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d3rsPES2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d3rsPES2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5EDFC4CEE5;
	Mon, 10 Mar 2025 17:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628395;
	bh=etNTLrtl0VAfpbvDzYO9miSkQNzDePbGjNR0pAOsWJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d3rsPES2cjESQm5X6Uh+AjvqRTm3amfUNoJ43SZI2J0RQpaobvMD4kYDq/11CyvAt
	 HKGFA8qm0CaAw7XImpGcwnxfokt4fBFhdRHaIA15MXbIpidoL9k/LVb5zYwdyo58HJ
	 5C8qJSNXZ49VuA9DPD+8JvygOpcQ7FxnpdKj57T8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>,
	Gerhard Engleder <gerhard@engleder-embedded.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 043/109] caif_virtio: fix wrong pointer check in cfv_probe()
Date: Mon, 10 Mar 2025 18:06:27 +0100
Message-ID: <20250310170429.275702567@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
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

From: Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>

[ Upstream commit a466fd7e9fafd975949e5945e2f70c33a94b1a70 ]

del_vqs() frees virtqueues, therefore cfv->vq_tx pointer should be checked
for NULL before calling it, not cfv->vdev. Also the current implementation
is redundant because the pointer cfv->vdev is dereferenced before it is
checked for NULL.

Fix this by checking cfv->vq_tx for NULL instead of cfv->vdev before
calling del_vqs().

Fixes: 0d2e1a2926b1 ("caif_virtio: Introduce caif over virtio")
Signed-off-by: Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>
Reviewed-by: Gerhard Engleder <gerhard@engleder-embedded.com>
Link: https://patch.msgid.link/20250227184716.4715-1-v.shevtsov@mt-integration.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/caif/caif_virtio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/caif/caif_virtio.c b/drivers/net/caif/caif_virtio.c
index 0b0f234b0b508..a8b9ada7526c7 100644
--- a/drivers/net/caif/caif_virtio.c
+++ b/drivers/net/caif/caif_virtio.c
@@ -745,7 +745,7 @@ static int cfv_probe(struct virtio_device *vdev)
 
 	if (cfv->vr_rx)
 		vdev->vringh_config->del_vrhs(cfv->vdev);
-	if (cfv->vdev)
+	if (cfv->vq_tx)
 		vdev->config->del_vqs(cfv->vdev);
 	free_netdev(netdev);
 	return err;
-- 
2.39.5



