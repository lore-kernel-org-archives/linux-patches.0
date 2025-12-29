Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBAF131B111;
	Mon, 29 Dec 2025 16:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025073; cv=none; b=YZt+YcNrHt2vFZ/HdFWdCCI5LhKrgd3Bsdgm+poXkgDLKj1N+JhPAf0H4Go6aRvaip0mtfof8RV4bihT7CWbESSGRjegi2zUFRqaTSdLZ64NAPR1Uy9Qv+ojeySJ9u1xUPDyp6I/VdWhX/HTqgG70bVmmihhCiRPnn/KzQXuJbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025073; c=relaxed/simple;
	bh=4v2kAMW9hOo8IB4GEUyUzc3a7QvcEXVg6CzVC6uIs28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NgUe56yb9ihqwAlLhU6HtKR8BRwOUsrTqrRUMZrUb911ebYRmYEQMx7RbGQG7GvPixjnTD9sXrZgGVBl8dunFcNYV/iRN7zLioRbvAw8ZARVZvEhMdxiK22Z+Pw35QuwdT33RREL6r0aNKHL71AjOpxeNhkFI0wuIA482ULsLYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L2pls8kE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L2pls8kE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B9ECC4CEF7;
	Mon, 29 Dec 2025 16:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025072;
	bh=4v2kAMW9hOo8IB4GEUyUzc3a7QvcEXVg6CzVC6uIs28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L2pls8kEieBC1EolS8MQpxLYqe0KmRX/gmGXOTT4OUyQyIV8PODRMojnitI6yY7mf
	 uFi7WriOHoTcpvWoJdaFCEgQwYNk3dK7v4yfIhkTBPkZzVoIeVxxWpRYLCQSH6JLBs
	 mcBLVBhTasAK+3MEVjZV+S4fskw1H0cajLBNiLOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 084/430] nfc: pn533: Fix error code in pn533_acr122_poweron_rdr()
Date: Mon, 29 Dec 2025 17:08:06 +0100
Message-ID: <20251229160727.454638443@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 885bebac9909994050bbbeed0829c727e42bd1b7 ]

Set the error code if "transferred != sizeof(cmd)" instead of
returning success.

Fixes: dbafc28955fa ("NFC: pn533: don't send USB data off of the stack")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/aTfIJ9tZPmeUF4W1@stanley.mountain
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/pn533/usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/pn533/usb.c b/drivers/nfc/pn533/usb.c
index ffd7367ce1194..018a80674f06e 100644
--- a/drivers/nfc/pn533/usb.c
+++ b/drivers/nfc/pn533/usb.c
@@ -406,7 +406,7 @@ static int pn533_acr122_poweron_rdr(struct pn533_usb_phy *phy)
 	if (rc || (transferred != sizeof(cmd))) {
 		nfc_err(&phy->udev->dev,
 			"Reader power on cmd error %d\n", rc);
-		return rc;
+		return rc ?: -EINVAL;
 	}
 
 	rc =  usb_submit_urb(phy->in_urb, GFP_KERNEL);
-- 
2.51.0



