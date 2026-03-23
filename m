Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556EE3947A6;
	Mon, 23 Mar 2026 14:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274902; cv=none; b=mRG4lMpqlulDi0+c2RLe/F6+oi3Vpu9dAob7w+JKjyoxgZzu9ibmiyKUPOEL1qp1T/tWtPuW9ZPVjAHY0d3vzypuvxMVWelfGw+dc6gzP9oRDz3xqeucF4M7s8UROUbZYHaXQf2v2GUWFYQL+xzIApspZK9UwtBbE8aFXAhY3Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274902; c=relaxed/simple;
	bh=tFgUffysI1DYQfvWr8O9EtPoAsEVINVCp0/kNQZhK50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QE1I9/B+DLyUvSG/rMrdlLOyGGPAylaq0anC7pyf2Wrt9TlDzk8dJKUnOsq+W90BTT4NWKo0w3PDk1oWQiOZ1ehL72rTnq9a7K6f/iF2WzLSjhVCLopVLN6TeUnZm0To4x1g7rVepPyYUE3KrJk9L8O4O1cTO1nbV+OsGiNlKkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h9lJgP9w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h9lJgP9w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E10AEC4CEF7;
	Mon, 23 Mar 2026 14:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274902;
	bh=tFgUffysI1DYQfvWr8O9EtPoAsEVINVCp0/kNQZhK50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h9lJgP9w8bPsXx7OA1UiGVqqQ4h/U3z3umIhrmdonMMBmwE9TVX03mM4nw5O7Cw9t
	 ASuGNeukfbXu3wUoB5eY2v7in+FAfy5z5k15swzMrqFUngMpwwrjLJ4IWa1P/la5DE
	 wwWO9z1Bdwgv7R4wYRPx9cu5+njQ5+X7zpXHpryQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 150/212] net: airoha: Remove airoha_dev_stop() in airoha_remove()
Date: Mon, 23 Mar 2026 14:46:11 +0100
Message-ID: <20260323134508.505523993@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit d4a533ad249e9fbdc2d0633f2ddd60a5b3a9a4ca ]

Do not run airoha_dev_stop routine explicitly in airoha_remove()
since ndo_stop() callback is already executed by unregister_netdev() in
__dev_close_many routine if necessary and, doing so, we will end up causing
an underflow in the qdma users atomic counters. Rely on networking subsystem
to stop the device removing the airoha_eth module.

Fixes: 23020f0493270 ("net: airoha: Introduce ethernet support for EN7581 SoC")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260313-airoha-remove-ndo_stop-remove-net-v2-1-67542c3ceeca@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_eth.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/airoha/airoha_eth.c b/drivers/net/ethernet/airoha/airoha_eth.c
index 0394ba6a90a9b..b16b9ae7d3311 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -3046,7 +3046,6 @@ static void airoha_remove(struct platform_device *pdev)
 		if (!port)
 			continue;
 
-		airoha_dev_stop(port->dev);
 		unregister_netdev(port->dev);
 		airoha_metadata_dst_free(port);
 	}
-- 
2.51.0



