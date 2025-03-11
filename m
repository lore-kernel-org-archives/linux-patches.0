Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018A025EF89;
	Tue, 11 Mar 2025 15:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707475; cv=none; b=ATPy/RS994iTzs8oybAld7f+NotB1E31j10gn2KY568FLzJFiYiRULaBTgrS7SEAb3oq9CSpMERljrMgfJc3JSjwQdNf7w6KhTKtleYpbNXt9zvew+X1MseYdL0idJAqZN0xB2k0jsT3Vwq3iPMmw0ffQ6kwX8f7ydfxnbiSPds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707475; c=relaxed/simple;
	bh=CBggDLJ2dX2gPogFOntile3JmO2Yet8wU3+AITW0RGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JWTXSOihIW638d3O6HU5katlQ9D+w9YyEkeC80FCClFDfGUGmKwLS5jhGh3sPqpw7+yQv//2B6gEWfd1wLaPkkVAGIMCCwupXWCKWw72u1yU5uFtuYjTsdRDloelaUxgVSxg1LQdY+yuwvNn/PjEB33AAP+KDA6DJ/YKFCzvluc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=amunz2mc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="amunz2mc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D9E8C4CEE9;
	Tue, 11 Mar 2025 15:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707474;
	bh=CBggDLJ2dX2gPogFOntile3JmO2Yet8wU3+AITW0RGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=amunz2mc8+dOn+0i4S2WNJSG6MMTaC6FQ4C4Shpqqfh0O1ahmwJDZihGoYze/Mtco
	 fvD5ddKOhLWhJvZi0jn8GsbnVRXoL6MIEZwIqukpznUVXP7SwaSm2mmglzdf8Sr7vy
	 yzK7OWSn8ODG6/dS5MpRcELeckZcjne7ttV2kw+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Alexandre Bounine <alex.bou9@gmail.com>,
	Matt Porter <mporter@kernel.crashing.org>,
	Yang Yingliang <yangyingliang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.10 401/462] rapidio: fix an API misues when rio_add_net() fails
Date: Tue, 11 Mar 2025 16:01:07 +0100
Message-ID: <20250311145814.177119407@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit b2ef51c74b0171fde7eb69b6152d3d2f743ef269 upstream.

rio_add_net() calls device_register() and fails when device_register()
fails.  Thus, put_device() should be used rather than kfree().  Add
"mport->net = NULL;" to avoid a use after free issue.

Link: https://lkml.kernel.org/r/20250227073409.3696854-1-haoxiang_li2024@163.com
Fixes: e8de370188d0 ("rapidio: add mport char device driver")
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Yang Yingliang <yangyingliang@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rapidio/devices/rio_mport_cdev.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/rapidio/devices/rio_mport_cdev.c
+++ b/drivers/rapidio/devices/rio_mport_cdev.c
@@ -1739,7 +1739,8 @@ static int rio_mport_add_riodev(struct m
 		err = rio_add_net(net);
 		if (err) {
 			rmcd_debug(RDEV, "failed to register net, err=%d", err);
-			kfree(net);
+			put_device(&net->dev);
+			mport->net = NULL;
 			goto cleanup;
 		}
 	}


