Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD7353451AB;
	Fri,  4 Sep 2026 06:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501761; cv=none; b=r6cu1PleG0/t2k92IFC1KE12C296wUEM8Ml5GQaJX584MvBDMlaGSjVDK6SrP4PgyYpT1E5qwzSUuD58Vr/xqe4zBwUcP5T3VeBRUTeN8jOUiW9ScHzN9mkegV7FA01QVhzXGsWWAUDApVKLpTu87A45cWB2NlK2QBF84dusm+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501761; c=relaxed/simple;
	bh=1ohY4H++YukCU1hoFUZ1QkVjPwLQMFo18veMYyAxPg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gj1Nw2yGAxba3hZV3RGQN4ii04kzNWF7EwHRsJfHkvFYyip8qiSW0UncuXDuymHKfoEzEujxeqBEMXWEag6E6/Wea41ThMTLL66FeMY6I6swwx2FtJdNwIeGnD0atYljYSkE/TcYh+WKZ2pLMeJdY0EEGt9NpxbMg2GOxz+8s7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QHZ/+BOZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QHZ/+BOZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 230911F00A3D;
	Fri,  4 Sep 2026 06:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501760;
	bh=3zsfPNlktrOalcOpYCMOq2tV7/fPP9U/Vh8njIcFrMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QHZ/+BOZVTzK5YiT7yJuiXVNnDKGtQTfEFHquqHVA7TLs5pOR/KWv8QBmHyDExCZN
	 f9EIT+2bJK6m1Out3VXg4/T1ozo3M0LV9bwCtDiOQsKx9jpUw1Ueje2e4IIhUZHtrr
	 5fDbqbXX98rBGxft2sZU17AbVWKYdRAP/B1nly+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.18 522/552] wifi: brcmfmac: Fix memory leak in brcmf_sdio_read_control()
Date: Fri,  4 Sep 2026 07:01:19 +0200
Message-ID: <20260904045802.462442868@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

commit 0d10db8e94fcb23a799789aaa696b4d8f937e207 upstream.

The memory allocated for buf is not freed in some of the error paths in
brcmf_sdio_read_control(). Fix that by adding vfree() calls.

Cc: stable@vger.kernel.org
Fixes: dd43a01c5cdb ("brcmfmac: use dynamically allocated control frame buffer")
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
[arend: rework as suggested by Johannes]
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Link: https://patch.msgid.link/20260803093506.1647790-1-arend.vanspriel@broadcom.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -1827,17 +1827,18 @@ gotpkt:
 	if (bus->rxctl) {
 		brcmf_err("last control frame is being processed.\n");
 		spin_unlock_bh(&bus->rxctl_lock);
-		vfree(buf);
 		goto done;
 	}
 	bus->rxctl = buf + doff;
 	bus->rxctl_orig = buf;
 	bus->rxlen = len - doff;
 	spin_unlock_bh(&bus->rxctl_lock);
+	buf = NULL;
 
 done:
 	/* Awake any waiters */
 	brcmf_sdio_dcmd_resp_wake(bus);
+	vfree(buf);
 }
 
 /* Pad read to blocksize for efficiency */


