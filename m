Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4212A24BC1A;
	Tue, 29 Apr 2025 17:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946152; cv=none; b=cWfScBOFs07STzw0NCnFQ+Wh+CKB3e4PJjZuj7pRIgvzdhN+ZQUf8eS2Mm14PXpgw4+c+yhk91Dx8KJlMUn+sXdsFPOqVjiPKlz0XT4xiASXO91o0kfVjHOzfvSpVNdyFqFxKQSn6YFivfvtmFvKfwRiR9ZcbwHgNy3bnepkUKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946152; c=relaxed/simple;
	bh=AJ7rXWnGdOk2RIr4V8svv5blRr7543UuG0yZeQdzwuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s8uh9nDiCf8PimUkUe+41nOzRo9WLgsNZxqas+14kEjehu1OoUzL1VVeHttbarLVBJ6XFmfE90q48eTFfiGkd2WZtPsygM1+Y5XHSL1DFZq7e9oj1oucwY/li/GAMdGgjQRFfED54+LUo083wMwDRaP8Hvu/3cILohkwYfqirfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XgpPdp1x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XgpPdp1x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57B11C4CEE3;
	Tue, 29 Apr 2025 17:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946151;
	bh=AJ7rXWnGdOk2RIr4V8svv5blRr7543UuG0yZeQdzwuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XgpPdp1x1vaIv/XVkC4hIlSNmwRAUwNcALs1twl9r/Sb3e6StsLV5WnUgKMT1Lf6R
	 uyaIPiUY+2jYkYxP5T/Lr9SE98yM0Tqw5AEBetGp9Sm30+B4X3u06JatxPN40vhHQZ
	 FTmPM+csEaaf09rxCOWkdHcs/aOZXgvBjIbaY7/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.14 172/311] usb: typec: class: Unlocked on error in typec_register_partner()
Date: Tue, 29 Apr 2025 18:40:09 +0200
Message-ID: <20250429161128.078155409@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 429a98abfc01d3d4378b7a00969437dc3e8f647c upstream.

We recently added some locking to this function but this error path
was accidentally missed.  Unlock before returning.

Fixes: ec27386de23a ("usb: typec: class: Fix NULL pointer access")
Cc: stable <stable@kernel.org>
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/Z_44tOtmml89wQcM@stanley.mountain
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/class.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/typec/class.c
+++ b/drivers/usb/typec/class.c
@@ -1056,6 +1056,7 @@ struct typec_partner *typec_register_par
 	ret = device_register(&partner->dev);
 	if (ret) {
 		dev_err(&port->dev, "failed to register partner (%d)\n", ret);
+		mutex_unlock(&port->partner_link_lock);
 		put_device(&partner->dev);
 		return ERR_PTR(ret);
 	}


