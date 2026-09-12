Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B4532B102;
	Sat, 12 Sep 2026 13:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221008; cv=none; b=ghImRLoDqxpG+NmKoWjH2MXM4cOJvotoN+Xormk1Wkvs85iTt1/45QZeLfkViNGng2nHA+xuZu8sQlwG+Pp0X4QLZSRSGwzJSdS6wypnapttc69MBlYckPGp9eH+9BDJz7OsWYM0h90ofoBP6VJXQdLPPwDKipEN1pthwctqXm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221008; c=relaxed/simple;
	bh=iQY4Xm7f3DOUh/UMcuNgtBSQjF09fApmOugPpKETrv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wu3cU8PlKT2og3CqHN9nT46nqWEhu37aFLNuCZENjMtkXshZLKPJgxfIdkhFJkVis5RCIggJmue3kyWgvS/QH/3w2eQLmWGu3WRAe2HsTGii9/JH7rnyenn+x9dlEyWBVSbTv7m38me9mRRNQ1VyzXrFxBV/ZylrnpiLdk1Oz3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WZtbANuw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WZtbANuw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 076B11F000FF;
	Sat, 12 Sep 2026 13:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221006;
	bh=anI2TMsNMxT3ZQIG8r1qqhEt0vUkWw15c/+AfbGQGdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WZtbANuw3rWhA8FIaCDNXi7AVjah4/yEfmbKDRWSb6s9ny9hCDw9g/xbgJV+VPf9d
	 1Oy9a6GKWIIY5Mv/JKgKiaOhjlpuQrUPmlxQE2czpH+fJ+rJSY6Iqtj5KAEJngoQGh
	 fy55ZdeJGnbHNkmlnqAH917YnHSzMFCVfFSMzy/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.6 0293/1424] wifi: brcmfmac: Fix memory leak in brcmf_sdio_read_control()
Date: Sat, 12 Sep 2026 08:45:25 +0200
Message-ID: <20260912065613.846987866@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
@@ -1826,17 +1826,18 @@ gotpkt:
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


