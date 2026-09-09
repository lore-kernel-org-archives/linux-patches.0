Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C56577E42;
	Wed,  9 Sep 2026 14:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962672; cv=none; b=ZcQFmk4pgFUMHTV282W2wW2GAflTWrptGmJ3S2Nj74LhLGfnJvBfZCCYf7zh25153vqECuWoWhBtF3fa+lNKcE7Rboj6HFyIkgaR3SpT5v+w+mFp3juw/bEJ8bnGF7gr9EjM4VKK0uA6tNq8fYCFJV5MD47Ic+vfeyu6Aisrm0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962672; c=relaxed/simple;
	bh=3w54mKGW/ZozEG0+OQh6+N0corBJ3BLXhbFVj1klb2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yxv5GjwbyCPzZWHRviMNEV1ottYzeWvLpo+japMgYh6Ji6Ljiw3jIglEku+NPAe9eSdpU3tSkeC9kCykUWkqfMlwDZcQP4SVbXrEfD5sdqqMH4Gr2CxgpmaGsfBL2tIUxmX/th+hdT5ss97QPXzlFVP2IOvdESMtuWB1fOKueJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iihs2338; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iihs2338"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B32291F00A3D;
	Wed,  9 Sep 2026 14:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962671;
	bh=Hsc1ILJipGGube1Hx79S2dUmDNDdq5DblEgOd5zvTBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Iihs2338eVsjJEMGPbmKk9B5wfZIYVg/gqa/wvAqo5DNwJ4U8fckFhJCM1Z0fckJj
	 osr7RV9qiIR5S1+sgjW/4omSI/HxzWDpJP+Ax3zYzvGv5NoPzt2NjMk8zxVI72qDwb
	 8TgqISCoc8675f8DARZNcGVa7dYH4TD+SgQrExEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Nguyen <congnt264@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 7.2 371/556] media: intel/ipu6: fix async notifier cleanup leak on parse error
Date: Wed,  9 Sep 2026 15:40:51 +0200
Message-ID: <20260909134243.738875934@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Nguyen <congnt264@gmail.com>

commit abb1f808ceab5a3275f8a6b4e37cff17f9f781c1 upstream.

isys_notifier_init() calls v4l2_async_nf_init() and then adds fwnode
remote subdevs in a loop with v4l2_async_nf_add_fwnode_remote(). If an
endpoint parse or add fails partway through the loop, it jumps to
err_parse and returns without calling v4l2_async_nf_cleanup(), leaking
every v4l2_async_connection already added to the notifier's waiting
list.

The register-failure path just below already cleans up correctly, and
the caller only tears the notifier down (isys_notifier_cleanup()) once
isys_notifier_init() has returned success. Clean up the notifier on the
parse error path too.

Fixes: f50c4ca0a820 ("media: intel/ipu6: add the main input system driver")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4
Signed-off-by: Cong Nguyen <congnt264@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/pci/intel/ipu6/ipu6-isys.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/pci/intel/ipu6/ipu6-isys.c
+++ b/drivers/media/pci/intel/ipu6/ipu6-isys.c
@@ -761,6 +761,7 @@ static int isys_notifier_init(struct ipu
 
 err_parse:
 		fwnode_handle_put(ep);
+		v4l2_async_nf_cleanup(&isys->notifier);
 		return ret;
 	}
 


