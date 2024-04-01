Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2322A47A5D;
	Mon,  1 Apr 2024 16:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987686; cv=none; b=qUEbqCccD7YrMd8q/8V1Y2FKHCmhYwSS4AiTu0dVUlUB1gB2MQU4nb6jSi5Zb8Rn2cLONkzBfafa6dA3Ii5rJ7vEiMJvShIFXTUDXY3Rp+C1ldk9ygc12Vz1u8Bm53/wF2+v3Rmh+WgrnolDzZ8MlMZPAVGUMhUsqtSMDWoOV98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987686; c=relaxed/simple;
	bh=AziIWuca8i4Y4oMawj8/KbfL3KmR7A5Jhg7eDj/NUKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PzKQEiBZOiFyxOsmM9FL5XEPV2AzhW6NiPBU9EQhw+QFAoOiXTfDxDGpC6O6E3d4Yv/9HyGLy72foqwGiXhOq/ObIBusaYTM5xbuTUe7uDM5y8z1o/wGaD6XWn2DY4AYsjrsRLvF1rFm8b4A7/uYeZ9KoxmW9DAMiKtR9g5HSkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wjaffVL6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wjaffVL6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FECEC433C7;
	Mon,  1 Apr 2024 16:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987686;
	bh=AziIWuca8i4Y4oMawj8/KbfL3KmR7A5Jhg7eDj/NUKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wjaffVL6wUCDkMO8v2GfgxEkb7OJNqyitoBZTGvQqej9tS4anzF4w9j7R+clAbXjG
	 k74qFIvV9Dxq63NiybiUXZlWqlTwgPTtaME9xSU2HloRROWxvGjK0JVfVAuYBoz+I2
	 uDCVACgKCOdzB+N9vgzVpaEojyetjpgj7iZU+Qmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Wortel <wwortel@dorpstraat.com>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.8 322/399] net: phy: qcom: at803x: fix kernel panic with at8031_probe
Date: Mon,  1 Apr 2024 17:44:48 +0200
Message-ID: <20240401152558.793088519@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Marangi <ansuelsmth@gmail.com>

commit 6a4aee277740d04ac0fd54cfa17cc28261932ddc upstream.

On reworking and splitting the at803x driver, in splitting function of
at803x PHYs it was added a NULL dereference bug where priv is referenced
before it's actually allocated and then is tried to write to for the
is_1000basex and is_fiber variables in the case of at8031, writing on
the wrong address.

Fix this by correctly setting priv local variable only after
at803x_probe is called and actually allocates priv in the phydev struct.

Reported-by: William Wortel <wwortel@dorpstraat.com>
Cc: <stable@vger.kernel.org>
Fixes: 25d2ba94005f ("net: phy: at803x: move specific at8031 probe mode check to dedicated probe")
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20240325190621.2665-1-ansuelsmth@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/at803x.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -1503,7 +1503,7 @@ static int at8031_parse_dt(struct phy_de
 
 static int at8031_probe(struct phy_device *phydev)
 {
-	struct at803x_priv *priv = phydev->priv;
+	struct at803x_priv *priv;
 	int mode_cfg;
 	int ccr;
 	int ret;
@@ -1512,6 +1512,8 @@ static int at8031_probe(struct phy_devic
 	if (ret)
 		return ret;
 
+	priv = phydev->priv;
+
 	/* Only supported on AR8031/AR8033, the AR8030/AR8035 use strapping
 	 * options.
 	 */


