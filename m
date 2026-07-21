Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5164847141E;
	Tue, 21 Jul 2026 20:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665298; cv=none; b=tAs+jWIwQ6i+Hxgxgg2BM6Z8FZmIZvqIFM77KCK5x7Y936ysY9gnN46gFHZoBoQYlnH4PwU3n9Xa4Qov8u/8nb6Y55XXPAH9Kdf30YD5fk6+OuqyxSu9QWjn0zca7/ZaPmokQBTYsE7mFxsZx7B3LlG8ZDp9QHluJD97bz31r7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665298; c=relaxed/simple;
	bh=X1iEaL/lVgCdJNUbLXxUKuH6sTVsBuDwEbKZASART2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fjayn+r38erC5Oexreq2Vz1h/5iiTSbyZldhWofehUOp8AyIvut9ccN3ROYkYWsr1OfiWNb9EpGSyDz0jKUeO3kTgJVgdUD8pLBkBS+TD2S2Hx8zTwiyWhSeFDFEP9bLa1mMTLGS2YzUpaQWwL8cJpec1kWg8MnMcc2b8/mvzEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DWangQ6U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DWangQ6U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B689D1F000E9;
	Tue, 21 Jul 2026 20:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665297;
	bh=QZhchE2E6dcsb7P4UsIWQurUSy7szBq0Zc2KRnD6uN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DWangQ6UTKzbvs57Zg4+b7F58nVXcKvDiGd6j8W1dfQGCcGk1ApdwCWmeDacY9aXG
	 n2jSmDCq9Vw1z4svXJnR9EuFh6XTUmCYP1Qt/JD8iRckBWYya1O+i4b9XCIBIbBGV+
	 Ml2ce4Qt/PwSqs7G4jvi2H+k51CYYLSzKjl6XgGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.6 0251/1266] usb: typec: anx7411: use devm_pm_runtime_enable()
Date: Tue, 21 Jul 2026 17:11:28 +0200
Message-ID: <20260721152447.429760862@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

commit 0ef7cc27da8b9e315a4a5a665c68c44206f5e559 upstream.

anx7411_i2c_probe() enables runtime PM before returning successfully, but
anx7411_i2c_remove() tears down the Type-C partner state, workqueue, dummy
I2C device, mux, switch and port without disabling runtime PM.

Use devm_pm_runtime_enable() so runtime PM is disabled automatically on
driver detach. Since devres action registration can fail, route that
failure through the existing probe unwind path.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: fe6d8a9c8e64 ("usb: typec: anx7411: Add Analogix PD ANX7411 support")
Cc: stable <stable@kernel.org>
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260701114006.75738-1-mhun512@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/anx7411.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/typec/anx7411.c
+++ b/drivers/usb/typec/anx7411.c
@@ -1542,7 +1542,9 @@ static int anx7411_i2c_probe(struct i2c_
 	if (anx7411_typec_check_connection(plat))
 		dev_err(dev, "check status\n");
 
-	pm_runtime_enable(dev);
+	ret = devm_pm_runtime_enable(dev);
+	if (ret)
+		goto free_wq;
 
 	return 0;
 


