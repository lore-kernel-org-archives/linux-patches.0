Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8FF2C0270;
	Thu, 15 Jan 2026 17:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498405; cv=none; b=XSj+DG2u8/qA76sT18E8CZyXxiME9doB/khvwE0Hs9fYvtlyhKIxd8F9+9+pw6BNvg8hUpTqL3owDyrdMCmzdr79wUdjeuvb1MKCPip4fRk2S34oOyK1VUQQZS76E9CblM3I2u+QofPXDM/OcyZwzVLUfnh2CJFvGoKjMUd6/Z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498405; c=relaxed/simple;
	bh=K/fSK+0iv+pivVh6LEmqvVNwgxMkImDbrkz/jYQ6vUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZC6T9ApKhp9sDqfpNmTr3KBfNi+cJWPrV2m44VR3HQAOdDknfGstyVLbZxepOPOW/zqEuyIGgxPpSq1ONFC53ilbqn3/aIAbW3T/q8kwaKflgM5jZbaiqgIex9+mglPCtwL7eoHnU9mSvPAYzzsvdOytJKT/mgM5EijX4ldLs9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QTD7Cmlp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QTD7Cmlp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4884BC116D0;
	Thu, 15 Jan 2026 17:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498405;
	bh=K/fSK+0iv+pivVh6LEmqvVNwgxMkImDbrkz/jYQ6vUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QTD7Cmlp7sZwAtY9UmHq7MzKl5jVln30hkCU2tU1WAnwWfWlc5DQa0ehYULjDUGR5
	 BNnqMaz8z0aQFV9cZeIhvkTlD/85i9mE3k40BwLwtZ4bPeGt1xqZ/gX8wFQyOsmmwb
	 u5PiSworNn44JCoO9rRd4PIj1+v7l85eLwI7hFVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Patrice Chotard <patrice.chotard@foss.st.com>,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.15 387/554] media: rc: st_rc: Fix reset control resource leak
Date: Thu, 15 Jan 2026 17:47:33 +0100
Message-ID: <20260115164300.246823406@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -287,7 +287,7 @@ static int st_rc_probe(struct platform_d
 	else
 		rc_dev->rx_base = rc_dev->base;
 
-	rc_dev->rstc = reset_control_get_optional_exclusive(dev, NULL);
+	rc_dev->rstc = devm_reset_control_get_optional_exclusive(dev, NULL);
 	if (IS_ERR(rc_dev->rstc)) {
 		ret = PTR_ERR(rc_dev->rstc);
 		goto err;


