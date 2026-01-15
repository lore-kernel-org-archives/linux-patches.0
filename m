Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1FDA3D3012;
	Thu, 15 Jan 2026 17:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499837; cv=none; b=XvJwWBOLfhqCYF8IvUmXHJU5SgtdhmyjK3RO2lelb069wBRlRto2ESRP/sIm/mpoKVjl76/kqGL1HNqLWF97hDd/UUDvtz7RN+wULyoMhvkYXMJrUKtBLwQN7kvV8tbfzxP68YjM8Xg7NsMUu1O3tfspchPQUXjo8sURrR0X7lY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499837; c=relaxed/simple;
	bh=7iGf8vtiQ5uImAqyL+vu9QvvY0/RxvSz20T3ODRJqZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bDcra5EqK665SkWUI68bGkXwTM7usAsJVERa/+aKEgXjehtqe9aaaWDOI42ItPmfmkoZPQTJ1jQ+1QuSk/KMCo0LQlXrbLqRQU62usg6TrjxJu9QwWzzdLYRWRcbxfGsryb+1bzra7jAGLkYpXSHkTvQDsiOltbbHHUpbgDLBHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zgBnvdNb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zgBnvdNb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CD6AC116D0;
	Thu, 15 Jan 2026 17:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499836;
	bh=7iGf8vtiQ5uImAqyL+vu9QvvY0/RxvSz20T3ODRJqZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zgBnvdNbetImcUZsK8TM+3S1Iuu7EFxlJEvLBbd3GMKGQWuYFOnSt+7HKiy5Ph47m
	 xJPF6urEYJcpxVNWw5tHAcV/J4yC6R8nK9GELb+o+62u4u0X4f1Xp/HuDtEjWuuqww
	 mXixGS7sKj7mvWGBKaJjnpFTUHGW7t92YxUPodhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Johan Hovold <johan@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Vladimir Zapolskiy <vz@mleia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 366/451] usb: ohci-nxp: fix device leak on probe failure
Date: Thu, 15 Jan 2026 17:49:27 +0100
Message-ID: <20260115164244.147973751@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit b4c61e542faf8c9131d69ecfc3ad6de96d1b2ab8 ]

Make sure to drop the reference taken when looking up the PHY I2C device
during probe on probe failure (e.g. probe deferral) and on driver
unbind.

Fixes: 73108aa90cbf ("USB: ohci-nxp: Use isp1301 driver")
Cc: stable@vger.kernel.org	# 3.5
Reported-by: Ma Ke <make24@iscas.ac.cn>
Link: https://lore.kernel.org/lkml/20251117013428.21840-1-make24@iscas.ac.cn/
Signed-off-by: Johan Hovold <johan@kernel.org>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Reviewed-by: Vladimir Zapolskiy <vz@mleia.com>
Link: https://patch.msgid.link/20251218153519.19453-4-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/ohci-nxp.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/host/ohci-nxp.c
+++ b/drivers/usb/host/ohci-nxp.c
@@ -224,6 +224,7 @@ static int ohci_hcd_nxp_probe(struct pla
 fail_resource:
 	usb_put_hcd(hcd);
 fail_disable:
+	put_device(&isp1301_i2c_client->dev);
 	isp1301_i2c_client = NULL;
 	return ret;
 }
@@ -235,6 +236,7 @@ static int ohci_hcd_nxp_remove(struct pl
 	usb_remove_hcd(hcd);
 	ohci_nxp_stop_hc();
 	usb_put_hcd(hcd);
+	put_device(&isp1301_i2c_client->dev);
 	isp1301_i2c_client = NULL;
 
 	return 0;


