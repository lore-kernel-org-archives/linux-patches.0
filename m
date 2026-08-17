Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 685582E8DEC;
	Mon, 17 Aug 2026 15:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979145; cv=none; b=oiHuioLyXB4s+v+1Pl5nWV8ppH/yGwLbJ1s7kah9E1GUsMdeqlsWr5qqL1aK5NyXfAmh7LfOWEBrwUZCzQ7jLLuEPlegZDYd5htO3/ZwDFWJ4z+grpX4oPhqrSW9qL1G2gU1S+Besj5IdpY8qZGltKb3uZdHTD7o9c6/2vASMjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979145; c=relaxed/simple;
	bh=TA29+p55cinzTiL6ys7hSXrEMadmBMFviPQ3O/CV6T8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z5/WGpYurqWv49shFroqyOz0LEtnG8+Vi6V6l1zqn+BglxMcP6fmhMiIqxqlVaczsqw5MkvODpvUDY9C4hQFNCb8wq7HeWUpT8ivhUB7joVHfctC+Hdf2DbWefu6esYCf7ClTG1EJh1hk2iCwoh86tZ8AD69WTj60imBL5q5o1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hpEFcXrj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hpEFcXrj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C12051F000E9;
	Mon, 17 Aug 2026 15:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979144;
	bh=PK81IMuB2DVEgyQxb54w4ByvEN0Tn7tR9nBZgaDWvF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hpEFcXrjQV9ZDszdSREs9rdYcCR7y+e81Rau/5iMT4BL9JdVFLn1EnOAzJsj/nPwc
	 x01ZOvf3SqgdjG5FjEi7nJGE0nSqC+kObMjKSxQ/CZ8zSvnVVMi4LKDkgdNyjk6p0N
	 Otq51p0dGZaH2uchctBkV6EEyy4/u+DT4ALkWQ/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 125/609] dpaa2-switch: put MAC endpoint device on disconnect
Date: Mon, 17 Aug 2026 15:27:01 +0200
Message-ID: <20260817132548.035550244@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 4c1eabbef7a1707635652e956e39db1269c3af2b ]

fsl_mc_get_endpoint() returns the MAC endpoint device with a reference
taken through device_find_child(). The switch port connect path stores
that device in mac->mc_dev and keeps it for the lifetime of the connected
MAC object.

However, the disconnect path only closes the MAC and frees the dpaa2_mac
object. It does not drop the endpoint device reference stored in
mac->mc_dev, so every successful connect leaks that device reference when
the MAC is later disconnected.

Drop the endpoint device reference before freeing the dpaa2_mac object.

Fixes: 84cba72956fd ("dpaa2-switch: integrate the MAC endpoint support")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260708111025.749311-1-lgs201920130244@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index c8478fdcb3aa5f..8f7c3466f52c45 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -1514,6 +1514,7 @@ static void dpaa2_switch_port_disconnect_mac(struct ethsw_port_priv *port_priv)
 		dpaa2_mac_disconnect(mac);
 
 	dpaa2_mac_close(mac);
+	put_device(&mac->mc_dev->dev);
 	kfree(mac);
 }
 
-- 
2.53.0



