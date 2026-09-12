Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16962317145;
	Sat, 12 Sep 2026 15:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227746; cv=none; b=ptcWu3KTiO3xxfLYe3flZ/bRxgD/DTJI9DQ7mmgejZTj8Kl06tXzc/Uho3XoEFiWCDu4kY98zya7DgOCj1wEIqYlu9aNmq/Bmj47MUdkcmdB77xWWMrATSE3AfkuwyJasZdAJgIAAG9oYPz4YyhYCyl3nrslaBoh+oqPDMCvAsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227746; c=relaxed/simple;
	bh=GVSxwB8O+UaXiBJMupDv6DlLX9sOSQtpOKLGWhTMOak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=llK7Kzb5XTk6YJqezONAXSh5HSfwPfutGX62EXbLZ0mjyWDy/OjaTGGPVfpXI2EgC9i3drsY4G+EJ2KKBdnHYU5ztQQgtRFvhXPXeiwmC4d3+Bl44BNPCPOTcxwAe+Vj763WpT2O3fgp28/Jsz6EiK1UIpbaDWCevwOd7tRaprA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M6tkKnRZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M6tkKnRZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D92881F000FF;
	Sat, 12 Sep 2026 15:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227744;
	bh=nFFq9MJ1fCkO2iUAMQTsajLDDbw11lpPTYz6c4BzfC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M6tkKnRZWhxDLvXFWGSa9gTln3yrh4/O6xx+qONNsiXE9vot2z0hSdVRIlLN/S2S7
	 fKWfowLPZQkwJul+jFjBvAJzDtYTXwb1VaBy3Dw2hRnhCV4MUQ75l+SkU0kYm8zGhK
	 vjcvq+/yNAjG60OgUPUBCXHJeKlRjJKI6kP4x6hA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.1 0237/1191] wifi: brcmfmac: Fix memory leak in brcmf_sdio_read_control()
Date: Sat, 12 Sep 2026 08:49:25 +0200
Message-ID: <20260912065553.534609138@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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
@@ -1828,17 +1828,18 @@ gotpkt:
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


