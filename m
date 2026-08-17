Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C71883E6DFA;
	Mon, 17 Aug 2026 13:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975048; cv=none; b=PvJueQyVXBz9wKQmUTTlxs8DuHxjGcn3ZN9CcseR/ySiLiPNkQdMKgW55hkCBrBvIQNiKHnZ9TsLz/jkvAlOe9Bw98h3NQKX2OWKGKavSU1AyfwUk1A6FrrPyJmL95EmQ2d+iXqqMsgvSfVdYFL9hHanBYIRj5egWelsFMfkMQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975048; c=relaxed/simple;
	bh=Ghs9LcnfwxSxiDHxevxXoyEjvoXvMFZU1WyWtkM09eY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QpGaHIwPSgbwteP5RgmFo0xsnf32fEBmYsEWt7wQirKSqq8HG7JDGz3b68pJ/aE8en3L3DLLMLZHTBGGJlg69gzPDU/MmQFqQfFlxmTq7Xd9xuBI2uibd0e1bBWRhf5Fm2mA4w88/RKS54r3V99i6UPZosNho4ta+ouNs20dxKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WyCBDjAe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WyCBDjAe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7C441F000E9;
	Mon, 17 Aug 2026 13:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975047;
	bh=Viuq08NO/jJid+EERjkQszAcCL3MT+cRTx3cVF6nulk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WyCBDjAeoUL20OlGMiNS1ojJKmX9kv735PLV482tnEe6aXYmEAK2tlGj+aCWMqzOr
	 U60Yzsb2HYCxOBCzR/87QlJs1VNONgek+73H0KxjeCQ0y9DhbgLRbteSgo5Vuz0vij
	 bAmpgeLumJSxcWIJv8CzKyQ/3uVdh9Ct4ERJWw0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp David <pd-lkml@3b.pm>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Dima Ruinskiy <dima.ruinskiy@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 143/250] igc: fix netdev not re-attached after resume if interface is down
Date: Mon, 17 Aug 2026 15:31:44 +0200
Message-ID: <20260817132542.393064770@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

From: Philipp David <pd-lkml@3b.pm>

commit b0ce5fd9fabe7c79463cf4602217d4dfeff5b1fd upstream.

__igc_resume() calls netif_device_attach() only inside the
netif_running() branch, so an interface that was down during suspend
is never re-attached on resume. It then stays in the not-present state
that __igc_shutdown() set via netif_device_detach(): ethtool reports
ENODEV and every attempt to bring the interface up fails the
netif_device_present() check in __dev_open() with -ENODEV, silently,
since __igc_resume() returns 0. Only reloading the driver recovers the
device.

This is easy to hit in practice because NetworkManager brings managed
interfaces down before sleep unless Wake-on-LAN is configured, making
the adapter unusable after every suspend/resume cycle with WoL
disabled.

Re-attach the netdev on every successful resume, as igb and e1000e do.

Fixes: 6f31d6b643a3 ("igc: Refactor runtime power management flow")
Cc: stable@vger.kernel.org
Signed-off-by: Philipp David <pd-lkml@3b.pm>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Dima Ruinskiy <dima.ruinskiy@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://patch.msgid.link/20260804222205.1580328-11-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -7573,11 +7573,13 @@ static int __igc_resume(struct device *d
 		err = __igc_open(netdev, true);
 		if (!rpm)
 			rtnl_unlock();
-		if (!err)
-			netif_device_attach(netdev);
+		if (err)
+			return err;
 	}
 
-	return err;
+	netif_device_attach(netdev);
+
+	return 0;
 }
 
 static int igc_resume(struct device *dev)


