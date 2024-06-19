Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8659143C4A;
	Wed, 19 Jun 2024 13:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802001; cv=none; b=FkquaMXobhC0pTlqlYTJweFO9so0gBmU3zvgCZZNy5ooBfkXNmcivfNPwlvyZhY6/+2Z/XPYiUV1L3rMqH/S8c8vwsi8ON+4D+bzfHQx+P5i/oqFIcvAyruHZQy1Ci62I8cxIDc48osEHAK6PhEQ/BAAvMzPgHMmJ3yuJ9VrAtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802001; c=relaxed/simple;
	bh=v690Sqozx9Z0+MlyycJyn+dtM3Ous1A+wAUmXYyB0vc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R4ToOSiXX1eB/KaQaFgjuF2xmIwGJIZt+jvdDOdizzurW7bxL8Bn5Qe62PkqDIWwJT9lr/iSd3/vuPqb/QJU4qQhOdfCWjqlWW8cM24xxzta8+8VTCLjR9WmjioHjLfFDNyEYmOcc7S2kXzovqLziXnoBfUWDWIe5OyxeJWoJes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=urE4Sjk5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="urE4Sjk5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFEBAC2BBFC;
	Wed, 19 Jun 2024 13:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802001;
	bh=v690Sqozx9Z0+MlyycJyn+dtM3Ous1A+wAUmXYyB0vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=urE4Sjk5X8MRXro5hk2JzC1G8qgGbjtoFyDjgMywXVY7GhF9jWZlKIt4j7iQs6uvH
	 oKiREidBYkZBLy7G5izP/buevjsQcl43FqWPyV/rbVP4sGxiHgAL0s26OPulAwHXmw
	 sA5K851A+q6x6qX2zo2FOGdFeJmH+MusEwbAp+zM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Sergey Ryazanov <ryazanov.s.a@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 047/267] net: wwan: iosm: Fix tainted pointer delete is case of region creation fail
Date: Wed, 19 Jun 2024 14:53:18 +0200
Message-ID: <20240619125608.171600507@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Aleksandr Mishin <amishin@t-argos.ru>

[ Upstream commit b0c9a26435413b81799047a7be53255640432547 ]

In case of region creation fail in ipc_devlink_create_region(), previously
created regions delete process starts from tainted pointer which actually
holds error code value.
Fix this bug by decreasing region index before delete.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 4dcd183fbd67 ("net: wwan: iosm: devlink registration")
Signed-off-by: Aleksandr Mishin <amishin@t-argos.ru>
Acked-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240604082500.20769-1-amishin@t-argos.ru
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wwan/iosm/iosm_ipc_devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_devlink.c b/drivers/net/wwan/iosm/iosm_ipc_devlink.c
index 2fe724d623c06..33c5a46f1b922 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_devlink.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_devlink.c
@@ -210,7 +210,7 @@ static int ipc_devlink_create_region(struct iosm_devlink *devlink)
 			rc = PTR_ERR(devlink->cd_regions[i]);
 			dev_err(devlink->dev, "Devlink region fail,err %d", rc);
 			/* Delete previously created regions */
-			for ( ; i >= 0; i--)
+			for (i--; i >= 0; i--)
 				devlink_region_destroy(devlink->cd_regions[i]);
 			goto region_create_fail;
 		}
-- 
2.43.0



