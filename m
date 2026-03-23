Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A9483BC673;
	Mon, 23 Mar 2026 16:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282604; cv=none; b=imLBEprz9+i2CDS/GCzgZx5aJF2nA32pIKtd5mJVw2lLq6Yk0roSGn3PQ15z49zf48XnpTD7dUwHVO+FXH9Eg4DGID0n0GQK83P3RfAjvM/ynFAU5R2L7TPdpH+zoUnczRpOuWGlYyV0EOTVOX0fCoIRlqT0K9iEVRBr8PzHvfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282604; c=relaxed/simple;
	bh=K0YtApIJaP5N6bGFBE1nOglm9miVjH7fYe7Cgam8a8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IxuLWLDe7UlT1mq+E4cCjW/MCXfQAsYO0GHSo/GTile59TzsNZrHssSrewxpOcFEfQvFfdZ2ll/tKRnV40HWdsfInV8UJyG9ygUO8J1/kBfqfeaLMLjWrhqGdbVGPXMDlGRMQpi1ZhOj3o0uDlXsyAdZAmYiP2qhExlhD8Pi4xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gi3H+vu+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gi3H+vu+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA444C2BC9E;
	Mon, 23 Mar 2026 16:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282604;
	bh=K0YtApIJaP5N6bGFBE1nOglm9miVjH7fYe7Cgam8a8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gi3H+vu++PFEtu7fVpEsUGnP0+kGNYOsijvQghcUVSsH4LofovyH7mEs89T5MOBDX
	 TcCrckx/ixLV2cBSGWqrecmxXmV8zJ/aI7DK7zt1Hb0CwxZbf8C9joI/N5D1k0Aqca
	 9OujF8S33u870dPNMtsDK7E8Q7jub29p1sLumu/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.1 217/481] usb: mdc800: handle signal and read racing
Date: Mon, 23 Mar 2026 14:43:19 +0100
Message-ID: <20260323134530.442926398@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

From: Oliver Neukum <oneukum@suse.com>

commit 2d6d260e9a3576256fe9ef6d1f7930c9ec348723 upstream.

If a signal arrives after a read has partially completed,
we need to return the number of bytes read. -EINTR is correct
only if that number is zero.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Cc: stable <stable@kernel.org>
Link: https://patch.msgid.link/20260209142048.1503791-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/image/mdc800.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/image/mdc800.c
+++ b/drivers/usb/image/mdc800.c
@@ -708,7 +708,7 @@ static ssize_t mdc800_device_read (struc
 		if (signal_pending (current)) 
 		{
 			mutex_unlock(&mdc800->io_lock);
-			return -EINTR;
+			return len == left ? -EINTR : len-left;
 		}
 
 		sts=left > (mdc800->out_count-mdc800->out_ptr)?mdc800->out_count-mdc800->out_ptr:left;


