Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3783026CE04;
	Thu, 15 Jan 2026 17:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499684; cv=none; b=R25S9IOTxAjVHr/P+9GlcfkIlCMapwuXDphcEz1MuJhHR+TLT2/Rj+QBi6KFcRjMDdsQ4oYh8vQOM6xy2EfIaNs7z7S2JRiw948WLd00DLtrthgaDLY78SisLrQKasaR4W4TTFbcv8mkRTWmWSZzAtrNdxwimoUcD7IAtSgRzJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499684; c=relaxed/simple;
	bh=hWIRxinghydKp0u6+Q6199cwo/t2KY3BL7mfIVtKqRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ExaTO5ei8UTpMUxd1j4LjD/LlO26bHmPE3mqKoTtvoIjrOK6BW/1J6AdmeejMBGA8Ynat0+Up2Z3QDAoGpMKzx7IrC/qLcz7ZmyfGPVtc7qkruwnVwc2BbRJqxfceRELBR+XrHxF8p6hZaMAA1FQQxAZy1oehUT+wbBGQWK25kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sWnr83A1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sWnr83A1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA5E3C116D0;
	Thu, 15 Jan 2026 17:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499684;
	bh=hWIRxinghydKp0u6+Q6199cwo/t2KY3BL7mfIVtKqRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sWnr83A18j9XinmdgYKtFJCRjcchjT2+58k3NKXvnbX4TubTbezRsOuVwyzK06qif
	 Vj475CelOXJ3/Jv3eMsbZwFqE75ZnbSQbGHgxA8XtyIxTouHzgt+RaJDaG93yD89O2
	 dknYNzfVAhiiEMtvTHDwz3zoBjKujXqYpmMO+sNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Patrice Chotard <patrice.chotard@foss.st.com>,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.10 314/451] media: rc: st_rc: Fix reset control resource leak
Date: Thu, 15 Jan 2026 17:48:35 +0100
Message-ID: <20260115164242.259656828@linuxfoundation.org>
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

From: Haotian Zhang <vulab@iscas.ac.cn>

commit 1240abf4b71f632f0117b056e22488e4d9808938 upstream.

The driver calls reset_control_get_optional_exclusive() but never calls
reset_control_put() in error paths or in the remove function. This causes
a resource leak when probe fails after successfully acquiring the reset
control, or when the driver is unloaded.

Switch to devm_reset_control_get_optional_exclusive() to automatically
manage the reset control resource.

Fixes: a4b80242d046 ("media: st-rc: explicitly request exclusive reset control")
Cc: stable@vger.kernel.org
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Reviewed-by: Patrice Chotard <patrice.chotard@foss.st.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/st_rc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/rc/st_rc.c
+++ b/drivers/media/rc/st_rc.c
@@ -279,7 +279,7 @@ static int st_rc_probe(struct platform_d
 	else
 		rc_dev->rx_base = rc_dev->base;
 
-	rc_dev->rstc = reset_control_get_optional_exclusive(dev, NULL);
+	rc_dev->rstc = devm_reset_control_get_optional_exclusive(dev, NULL);
 	if (IS_ERR(rc_dev->rstc)) {
 		ret = PTR_ERR(rc_dev->rstc);
 		goto err;


