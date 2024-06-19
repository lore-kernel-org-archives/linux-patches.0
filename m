Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F183B14B96F;
	Wed, 19 Jun 2024 13:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803634; cv=none; b=IeNjfHestjHzgCdgdMaXlpAp7Dw7IrRTYTmHndz+TPx3fOIIauKbMYJQQ4zb56reIGJCjGW08qIowu4FDTfB9vfwWuJdeSV4/xYaPKrQFT6zsVILr+WmsgH74SHXXu3KPJ6rOABm360B9nsPgdT6LldZgXFb/vS4uJz6qVdxBq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803634; c=relaxed/simple;
	bh=DY6/D12ttJvuRIkoqs1ovXvtq0rs9+64/jn5c2yqy18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QBQWD28YjqnoS24DTBwK6dGu0RM8jcta94EWplMf+Em1cq9G9x9/1iiLAptm3AqYKy++r3wFUvytCehXv16wnEqT2lvH6GOgrYOrqaav8G7hwcdfiToBcVxSRd/FESA0vqwawg35d86DWB2/TytUDPRMcL93eMVow4BrBQbJjy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wfj+lWXh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wfj+lWXh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16EA7C2BBFC;
	Wed, 19 Jun 2024 13:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803633;
	bh=DY6/D12ttJvuRIkoqs1ovXvtq0rs9+64/jn5c2yqy18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wfj+lWXhqYKrPcvRub8SxWHFqgpnk3M3IKqDit60G7onrvdfoYe++lBzQcumQCRFo
	 5uz86cRpoYOg+rwvF8wM6ceOqJN05HBxrdBfAtswUqcVOXXsVM/CnJMi7dttr4O5ld
	 PVfHdiNRmnsKuDE5oEPDYYXeb0Oj6fh9C9gy+ITk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Sergey Ryazanov <ryazanov.s.a@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 034/217] net: wwan: iosm: Fix tainted pointer delete is case of region creation fail
Date: Wed, 19 Jun 2024 14:54:37 +0200
Message-ID: <20240619125557.969098276@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



