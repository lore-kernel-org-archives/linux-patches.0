Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917E130D3FF;
	Tue, 21 Jul 2026 20:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667134; cv=none; b=SB+vvwmP2sRtSXlE8L8bVTHaqkiRQTdVHD53CDioRAYK0CoYaKgeqKsw65NbVLX/PiK0xh/x9qqjyB9TIM2YjSonpBbMc6+Mu40RK+1/BIkeuZa17YcQ0bn73QmRJMuz9wiH8zWM5Axg/TR8aokJ/eQ35kpCuzt+V9EDoxJdoYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667134; c=relaxed/simple;
	bh=XMT1rN3mJ0IC8UAEbEhIGgxsANvm2cvgEgJw5ufeSDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mUCn7fA+yc9WiqXaPU10Fyv7HNhR56zGPmhFeSimIdRMsZ4llUabjO49GrOjr3gEue/SAMKAlaXTXbOPOLLIJt/H06a/8ikcXGsjsRJgSXaqcRXnHvVR9lmQt5iGv96O1pZowquLCwELE4C6pLvWo8NZ0nL0+djMcw1uQRsLMkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cy4Na5Iq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cy4Na5Iq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01D0C1F000E9;
	Tue, 21 Jul 2026 20:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667133;
	bh=cmluwicWAkdZxnUSPTMqkHqKKMBo/iFVOZnWb5VRlkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cy4Na5IqKZsk3NhNz89xAC7O+qW5Hmtjhpfn66QdJ8nr2lNxC3Qh1YXJHZPEWG4kJ
	 6otKMW5sV66qqZxVNYvGAuEM0s++Xk6JV3nEN+yuSMfBC9S0xm/y9zBbwySe0f2/wg
	 0ukkQE3mayPbROZ1oINUELzTaz46fG/zbqQN+RJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.6 0946/1266] batman-adv: access unicast_ttvn skb->data only after skb realloc
Date: Tue, 21 Jul 2026 17:23:03 +0200
Message-ID: <20260721152502.998531380@linuxfoundation.org>
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

From: Sven Eckelmann <sven@narfation.org>

commit 7141990add3f75436f2933cb310654cad3b1e3e9 upstream.

The pskb_may_pull() called by batadv_get_vid() could reallocate the buffer
behind the skb. Variables which were pointing to the old buffer need to be
reassigned to avoid an use-after-free.

This was done correctly for the ethernet header but missed for the
unicast_packet pointer.

Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: c018ad3de61a ("batman-adv: add the VLAN ID attribute to the TT entry")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/routing.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/batman-adv/routing.c
+++ b/net/batman-adv/routing.c
@@ -855,8 +855,8 @@ static bool batadv_check_unicast_ttvn(st
 	if (skb_cow(skb, sizeof(*unicast_packet)) < 0)
 		return false;
 
-	unicast_packet = (struct batadv_unicast_packet *)skb->data;
 	vid = batadv_get_vid(skb, hdr_len);
+	unicast_packet = (struct batadv_unicast_packet *)skb->data;
 	ethhdr = (struct ethhdr *)(skb->data + hdr_len);
 
 	/* do not reroute multicast frames in a unicast header */


