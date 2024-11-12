Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F7D20EA37;
	Tue, 12 Nov 2024 10:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407288; cv=none; b=H8YjA7kNwbL9KF/502ov3pvuk7lVPuUm+ZN9RZBv7ek8/6b8sGtraB6koTtc5l1O5T0KLgroM8NuUyKNAWcxIvW7OJQkmxI5NRS2EugrO24Un+vp4mGpuWAynXbx42kHSk21ck2UvjSdiah9QLR2SOk9fODXAIckquHVo5f1xm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407288; c=relaxed/simple;
	bh=bjCo+KVI/MozsCVUTOzeJUcBTdLXj+o6DZJGGU9Ut9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y9gdGzNlMDceKBtGIwjfdW3OkHN2jLDU8dD/b0yQqQegmek5QmJOrPnzxF08yjO2lmBtXRHzJx0cHd/5OwzkxEfCyW/cPXDfxqUhkjcE+D8QaGYEjV3w9ab8dpNnpnmPrgfqdMYH0SNUxqO6D1bGwRIb78hs7DDY6ruXXCC3Zk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G0sd1AE1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G0sd1AE1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E348C4CECD;
	Tue, 12 Nov 2024 10:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407288;
	bh=bjCo+KVI/MozsCVUTOzeJUcBTdLXj+o6DZJGGU9Ut9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G0sd1AE18B1okuhU+Z3NpJX2PQFz0tVyrLNhHJ/ej7Ti5tmb+YaZ/8G8kI4FQz9Vp
	 jKy1HJf+A5X2upf4i+WfUEKCV0d5fqSmkfTqWlULNU8aYwGQAyYVXuiqzhp0DU7NAI
	 kBRSvzofE7AbeAVve307+9MM4lN0W5cAxSb2c7IA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 30/98] net: stmmac: Fix unbalanced IRQ wake disable warning on single irq case
Date: Tue, 12 Nov 2024 11:20:45 +0100
Message-ID: <20241112101845.421777065@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101844.263449965@linuxfoundation.org>
References: <20241112101844.263449965@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit 25d70702142ac2115e75e01a0a985c6ea1d78033 ]

Commit a23aa0404218 ("net: stmmac: ethtool: Fixed calltrace caused by
unbalanced disable_irq_wake calls") introduced checks to prevent
unbalanced enable and disable IRQ wake calls. However it only
initialized the auxiliary variable on one of the paths,
stmmac_request_irq_multi_msi(), missing the other,
stmmac_request_irq_single().

Add the same initialization on stmmac_request_irq_single() to prevent
"Unbalanced IRQ <x> wake disable" warnings from being printed the first
time disable_irq_wake() is called on platforms that run on that code
path.

Fixes: a23aa0404218 ("net: stmmac: ethtool: Fixed calltrace caused by unbalanced disable_irq_wake calls")
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20241101-stmmac-unbalanced-wake-single-fix-v1-1-5952524c97f0@collabora.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 045e57c444fd7..14e5b94b0b5ab 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3665,6 +3665,7 @@ static int stmmac_request_irq_single(struct net_device *dev)
 	/* Request the Wake IRQ in case of another line
 	 * is used for WoL
 	 */
+	priv->wol_irq_disabled = true;
 	if (priv->wol_irq > 0 && priv->wol_irq != dev->irq) {
 		ret = request_irq(priv->wol_irq, stmmac_interrupt,
 				  IRQF_SHARED, dev->name, dev);
-- 
2.43.0



