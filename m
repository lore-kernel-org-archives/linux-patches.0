Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784963876CC;
	Fri,  4 Sep 2026 06:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502937; cv=none; b=Fg+Wz/F3glHh8ZcZOOUujgQLRUyZu1WeSLhcoiZ3TucsDPLePp56D7KnKWxOEeqymhSTa29vDgSskE4TiCDhGPu3Um4o/bqKooYEB9sEh6y3MC3t3kXyHZo56u4XH8GpQMno5w+m1G51dyaHtVQOmzAzCKKahgC9ncFxv5TsotQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502937; c=relaxed/simple;
	bh=LV1G4EQqtDT8GTNePHgfrEW0Kp+Frqbj6r0Bhe2qgxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uQ9uMNCANiD0k+BIDAdlyJEugt0FV2tXilOakzR2jjvrx9OXcI+VI+WY5g/hpHg/U8bDzJhGZuObs6wOizSjz2JsgfyCYgDRxLhzfDZwAFcjoQo9m9lg0aubv3Y8g95WZBE/kEG4zDTPQA/lwMfx7oAYFaVeDHlamCjVaUFIz3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h0l/MRba; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h0l/MRba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C245B1F00A3D;
	Fri,  4 Sep 2026 06:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502936;
	bh=Te9Qhp2smVuhNNOXy7eL4SBLRK8b28i1mrK+FQ622Jg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h0l/MRbaKf3UmHC91x1u4ETIWc0ItmoUQKFKNHfZS538RRRYtegJkObCyCH+GykWw
	 ajkEu/Pb5R6ZtjjlG7BknkBRmVS+Kvk84PjfdzF8QiRUw5bKTLZTPNL6+U7dkUhFjp
	 Sc2s/u4ZusLMvhsO65eT9FNWHGPlE59XaS5C95Ws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 382/403] wifi: brcmfmac: Fix memory leak in brcmf_sdio_read_control()
Date: Fri,  4 Sep 2026 07:03:05 +0200
Message-ID: <20260904045743.480545247@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


