Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837D814D431;
	Tue, 10 Sep 2024 10:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963127; cv=none; b=s9i7YeNf88x+jbk0VvIkzEcY+R08D33FauDIFldfdt0d5KWks/TapKXCmBf+BoLdfU82waL1GgXTTOhsAtlY1kM2xt/8U4qXlPhUqwQx23FCkpCTb0EYj89alYEgH5jInm5z+xG1lTeKtuaB9/obRCYAQxDm9qpdvTKAPadtjFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963127; c=relaxed/simple;
	bh=WWdzVjMVRKmnby9QpcYZdyxiZ0AVHfJrqIa7MiN3LWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dz4BgGoqARaP3qv8lkZKUjcxDlWy5MR17piFXcUkGV0gtxweoPOXY3PjlUk4lMqsI6RfeYdZkr4qwHANFKJ66PwYukXWJlDOfvGrlbwd/gubq2PfnsZs8LXofgnRymuE4zIBd1CX92fIaL7bsZhdmDEV0uO1PdV5IEcRbkwep8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KcClpX0X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KcClpX0X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AA14C4CEC3;
	Tue, 10 Sep 2024 10:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963127;
	bh=WWdzVjMVRKmnby9QpcYZdyxiZ0AVHfJrqIa7MiN3LWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KcClpX0XPiNPDX4IoeTLhvsgzNUzkA32821t9rViRJieX4GTjsOz7dTWS4UHO1YiA
	 g/OFrVCj7zCgYh7ag29n+6kiZn1jupOJH3kHKPrSEAbcMCKHePyJ6Rvm51G9iZlSxq
	 PP8tzAYFj0LaQdAowA6BS2FCvP0MescOENjIn4Dw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saurabh Sengar <ssengar@linux.microsoft.com>,
	Naman Jain <namjain@linux.microsoft.com>
Subject: [PATCH 6.1 145/192] uio_hv_generic: Fix kernel NULL pointer dereference in hv_uio_rescind
Date: Tue, 10 Sep 2024 11:32:49 +0200
Message-ID: <20240910092603.943262182@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Saurabh Sengar <ssengar@linux.microsoft.com>

commit fb1adbd7e50f3d2de56d0a2bb0700e2e819a329e upstream.

For primary VM Bus channels, primary_channel pointer is always NULL. This
pointer is valid only for the secondary channels. Also, rescind callback
is meant for primary channels only.

Fix NULL pointer dereference by retrieving the device_obj from the parent
for the primary channel.

Cc: stable@vger.kernel.org
Fixes: ca3cda6fcf1e ("uio_hv_generic: add rescind support")
Signed-off-by: Saurabh Sengar <ssengar@linux.microsoft.com>
Signed-off-by: Naman Jain <namjain@linux.microsoft.com>
Link: https://lore.kernel.org/r/20240829071312.1595-2-namjain@linux.microsoft.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/uio/uio_hv_generic.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/uio/uio_hv_generic.c
+++ b/drivers/uio/uio_hv_generic.c
@@ -104,10 +104,11 @@ static void hv_uio_channel_cb(void *cont
 
 /*
  * Callback from vmbus_event when channel is rescinded.
+ * It is meant for rescind of primary channels only.
  */
 static void hv_uio_rescind(struct vmbus_channel *channel)
 {
-	struct hv_device *hv_dev = channel->primary_channel->device_obj;
+	struct hv_device *hv_dev = channel->device_obj;
 	struct hv_uio_private_data *pdata = hv_get_drvdata(hv_dev);
 
 	/*


