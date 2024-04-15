Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8820676025;
	Mon, 15 Apr 2024 14:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191929; cv=none; b=agm9VHvlf/7/9Yn/5WCFPLyklxwfQXiNoRyGeDrsBidhOCJt4AsBXR5GLCgxwI8jWxmn6mmyHy1ENr/Psg17Iz2LFeKiOYX/7tEnZ4zY/U6wFzHaQV3RTQqoRyMkoqMYw0ABZoUsmKRxES+Bsq0XnL2HkgNzYFyjXCZqSFa2suA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191929; c=relaxed/simple;
	bh=6m/UdAMcvm/dEjEuz3cyv/QCw7JLN/ltaTZSiPbIcns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IPnlT7ysPcTdD+8RBtFowAeN1hKtFEIbsFyf3QV4/et7KpDi4nl2uNG+hDVyB1AF+OVcDjrRGO9oTi272hgnI6D7XaWa2Bg/vo+7rDvilVykGQ3b4dd8XFg8bMCAtNO8Mj+FgIzqxQ7B588sQFB25XeNoQ8rEtbsLLHriz9V8ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SVnQIr4p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SVnQIr4p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12E8FC113CC;
	Mon, 15 Apr 2024 14:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191929;
	bh=6m/UdAMcvm/dEjEuz3cyv/QCw7JLN/ltaTZSiPbIcns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SVnQIr4p+iuAcNtkSIXDQPKQ5mrxrM5CQGVy72T6vB+ZoZ1tJ9eOi0pu/LAq32rai
	 RbWxlGlOmVZBBke+uIJLXEOBndfnAIDUbyXdKAt68e3g38fbGL/GFpnPiGoMMU/olq
	 DjL4XRmbWLO+DlptK9KeeP9d46tTwLCK6pW+yf44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a6a4b5bb3da165594cff@syzkaller.appspotmail.com,
	Sven Eckelmann <sven@narfation.org>,
	Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 6.1 03/69] batman-adv: Avoid infinite loop trying to resize local TT
Date: Mon, 15 Apr 2024 16:20:34 +0200
Message-ID: <20240415141946.271253711@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141946.165870434@linuxfoundation.org>
References: <20240415141946.165870434@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Sven Eckelmann <sven@narfation.org>

commit b1f532a3b1e6d2e5559c7ace49322922637a28aa upstream.

If the MTU of one of an attached interface becomes too small to transmit
the local translation table then it must be resized to fit inside all
fragments (when enabled) or a single packet.

But if the MTU becomes too low to transmit even the header + the VLAN
specific part then the resizing of the local TT will never succeed. This
can for example happen when the usable space is 110 bytes and 11 VLANs are
on top of batman-adv. In this case, at least 116 byte would be needed.
There will just be an endless spam of

   batman_adv: batadv0: Forced to purge local tt entries to fit new maximum fragment MTU (110)

in the log but the function will never finish. Problem here is that the
timeout will be halved all the time and will then stagnate at 0 and
therefore never be able to reduce the table even more.

There are other scenarios possible with a similar result. The number of
BATADV_TT_CLIENT_NOPURGE entries in the local TT can for example be too
high to fit inside a packet. Such a scenario can therefore happen also with
only a single VLAN + 7 non-purgable addresses - requiring at least 120
bytes.

While this should be handled proactively when:

* interface with too low MTU is added
* VLAN is added
* non-purgeable local mac is added
* MTU of an attached interface is reduced
* fragmentation setting gets disabled (which most likely requires dropping
  attached interfaces)

not all of these scenarios can be prevented because batman-adv is only
consuming events without the the possibility to prevent these actions
(non-purgable MAC address added, MTU of an attached interface is reduced).
It is therefore necessary to also make sure that the code is able to handle
also the situations when there were already incompatible system
configuration are present.

Cc: stable@vger.kernel.org
Fixes: a19d3d85e1b8 ("batman-adv: limit local translation table max size")
Reported-by: syzbot+a6a4b5bb3da165594cff@syzkaller.appspotmail.com
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/translation-table.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -3948,7 +3948,7 @@ void batadv_tt_local_resize_to_mtu(struc
 
 	spin_lock_bh(&bat_priv->tt.commit_lock);
 
-	while (true) {
+	while (timeout) {
 		table_size = batadv_tt_local_table_transmit_size(bat_priv);
 		if (packet_size_max >= table_size)
 			break;


