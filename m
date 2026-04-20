Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C9C2D77E5;
	Mon, 20 Apr 2026 15:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700458; cv=none; b=DbZ3FvQjze72TsNGcFUXyug0Ln9IW3LInTr6c8WbLfKVXPEshQuzpLnfE2u7UCY9bkLR3ME+6llh+POQodtiUF+B1MBhDyUzwsj3T/D4B1O1Te7quLKxVddmY3a2cmKDOtwGL3luxjjGbWWjinPxCNvgZ4VIr4pfcvQ0jQwnRec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700458; c=relaxed/simple;
	bh=6RoqYq+PyQdlIVkuo1G7RwZ0GaUmQLu49hrHpcQTTKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MXTSRcjthDEiEenB1hG+MxBMMPz22YDd3vZEfh2V86ipmPpwZMq9oOZbg5K1cY8Q4ErOfhNXkmE75ZsSffZrGNYJTvqeXnVugsyECxtCyzsw0ERr2ZkY3zkL7vw+60njXV/sKeS57i/zqzuVi6RlqHF69nPAwnuNZeOqh+04jfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V0AYuNWV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V0AYuNWV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A0A9C19425;
	Mon, 20 Apr 2026 15:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700458;
	bh=6RoqYq+PyQdlIVkuo1G7RwZ0GaUmQLu49hrHpcQTTKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V0AYuNWVRYK8yLVXyPru8Uu1dMRSQscJ47qx4C+qwg7j2UTk7zKhg+FxhNuxX1c1i
	 LVrcXFoNXp0oyzwUXV6Mn9dQ5R0WjOIQo7TJ3jR8ID5jTi2/u0s2fm+uKjwZh/FJl8
	 oCQUnUFqXPbt5onFkIWm2ZCKLdC0/e74rMokd5sQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vikas Gupta <vikas.gupta@broadcom.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	stable <stable@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.19 149/220] bnge: return after auxiliary_device_uninit() in error path
Date: Mon, 20 Apr 2026 17:41:30 +0200
Message-ID: <20260420153939.394444616@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 8b0c25528cb64f71a73b5c0d49cbbcb68540a4ce upstream.

When auxiliary_device_add() fails, the error block calls
auxiliary_device_uninit() but does not return.  The uninit drops the
last reference and synchronously runs bnge_aux_dev_release(), which sets
bd->auxr_dev = NULL and frees the underlying object.  The subsequent
bd->auxr_dev->net = bd->netdev then dereferences NULL, which is not a
good thing to have happen when trying to clean up from an error.

Add the missing return, as the auxiliary bus documentation states is a
requirement (seems that LLM tools read documentation better than humans
do...)

Cc: Vikas Gupta <vikas.gupta@broadcom.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>
Fixes: 8ac050ec3b1c ("bng_en: Add RoCE aux device support")
Cc: stable <stable@kernel.org>
Assisted-by: gregkh_clanker_t1000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/2026041124-banshee-molecular-0f70@gregkh
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnge/bnge_auxr.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/broadcom/bnge/bnge_auxr.c
+++ b/drivers/net/ethernet/broadcom/bnge/bnge_auxr.c
@@ -194,6 +194,7 @@ void bnge_rdma_aux_device_add(struct bng
 		dev_warn(bd->dev, "Failed to add auxiliary device for ROCE\n");
 		auxiliary_device_uninit(aux_dev);
 		bd->flags &= ~BNGE_EN_ROCE;
+		return;
 	}
 
 	bd->auxr_dev->net = bd->netdev;


