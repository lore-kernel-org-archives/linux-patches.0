Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 992B92459FA;
	Tue, 29 Apr 2025 17:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948401; cv=none; b=qcn8K81P4ADeNTRZmQOvZW6rG5YxFIzcNt+Dqzr3ADCN9Xxem5L/5z5IOSjFSFUlB4FuEMNdK2NrJe0ztARYkk+U6NTBhUe/X00yECv6cvvGl9owts78G0XIgbOW1JP3QRrvZuC9g7iRLHMLDfcY/IRS+u1JnycWFnPQRS86DhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948401; c=relaxed/simple;
	bh=6l6/8lIaV30cEsf2xDJMY4cAhCB2BagjTaNWHetHp2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I9s3kiMHM8+b34U+cUUeaEK2wfcBl6JEgNhW8xVngr1bharhtq0JKTVfjGXNppfUL0MGWww8BfhnUZSWL497WRFm1xaG4kx69GbiD1GjcSBs3vvHK84yNXQLM5py57xwLg0q9xKiJ30Qms66YrMyCKXh7RifFlxExMyklRmvXYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fdgycj58; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fdgycj58"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 015CFC4CEE3;
	Tue, 29 Apr 2025 17:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948401;
	bh=6l6/8lIaV30cEsf2xDJMY4cAhCB2BagjTaNWHetHp2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fdgycj58mGIWQUTJyJ891rYPjhTZMNG3dZfjpoaWwYTGRzEWGdScT+DCd5nIFDoKB
	 mnDHXaElA92p0r2lDAoOq1HJZvnd+IrOlWWTl0bCgXtmFwfwCMJxRLtEckgeBDmo6Q
	 eLAHNit4rZTTCpwHGDSB2Hht1W17eBCyK8vKpySs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.12 277/280] usb: typec: class: Unlocked on error in typec_register_partner()
Date: Tue, 29 Apr 2025 18:43:38 +0200
Message-ID: <20250429161126.465452362@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -936,6 +936,7 @@ struct typec_partner *typec_register_par
 	ret = device_register(&partner->dev);
 	if (ret) {
 		dev_err(&port->dev, "failed to register partner (%d)\n", ret);
+		mutex_unlock(&port->partner_link_lock);
 		put_device(&partner->dev);
 		return ERR_PTR(ret);
 	}


