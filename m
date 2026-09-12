Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98FDA2F7F17;
	Sat, 12 Sep 2026 19:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241658; cv=none; b=tDfiePiw3J5Z5AZhwSRermg5aYI440XeDKSYb3n+cAGpFYw+YVVOWdX1VJW9RMGwUleSKBint1iRnUBFL1DD4wyOTWWzWvtn4niIoLuAX+bb3esslfJDDGhAjKUQ2tMvRLyzox9d7HP2QB0k3UaKaXMkGOdRS8hgpLNu+ipj3mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241658; c=relaxed/simple;
	bh=Q4HsMTXol12nH5ixVqOpVIoEXs1zDnYyaI8kQkp5LC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qwQHr5kMxiEn5GvWKJVtzp6iYsqHHUO1IbSFfrYZ+K6Z/XqkPWzQ4cBCigf+1Mv7M+iQt+62WQlQqVeTTqeH9ehgZR9TnhWgCS3jcMJYMsOmK3g6fF54HFgXVh45mIl9+3g/iL8Qlgpq2RV79OPfyQdS9K6qhkQEGYtYOYS0yA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PX8OWSJI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PX8OWSJI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C9C91F000FF;
	Sat, 12 Sep 2026 19:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241657;
	bh=4v6qXwRnaOMACTKKe1Pct2U8fhRHWUvle9c3jKlbqx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PX8OWSJIWs54CIDAhMoTXc0+4/QXK+AFxjlPhY7MtVSGHsCIyP0M6six6aoX1cO2G
	 g5kF3DPPg8Tv9RnNr2xr0I3fZhHzMjbPU8wrLhYpfkrIGAU1PlkaZKSPffUgyHKrEL
	 u/WZ3HJBGIusmHL3YUsJUtRuSBervk4FKf9PNBhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 180/798] wifi: brcmfmac: Fix memory leak in brcmf_sdio_read_control()
Date: Sat, 12 Sep 2026 08:56:48 +0200
Message-ID: <20260912065521.153490453@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1815,17 +1815,18 @@ gotpkt:
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


