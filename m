Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF5735334E;
	Tue, 26 Aug 2025 14:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218536; cv=none; b=qXBKIYVmHdejNS8cKIaFVWn4fhEX0cceo7HPiZNoPYsaFm/ANWERanJlrjfFM+uJ+Htgo79PvibWlK73aWUF6BUCF3RGqeoFgI4zenW6w14Y5l87p8DaNjOODqR7hYfGis9ZopRAx1INAWFx8zrAmCmIOrqrbIKShTgccMgs1dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218536; c=relaxed/simple;
	bh=Kbg+FpA2YNzlnucto3Eem1+b2gcC60BF64+RAtsOR8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UZjMsEWTSROqx4NaEBYu7duhqZm6s9u9WlkCvGJLizod8ofh6ue+zanJvi/mB4UWDoO0h4kFW10GtnJcG6AdTBH8H0X3N6IGh6aTKPZCI8BS63pf3jlKPUT7fd+LuL6glR5B7hjbCya067UqNDKyrAtmmwqqH1dB2QmllLHtySw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G5cL3CPj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G5cL3CPj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8228C4CEF1;
	Tue, 26 Aug 2025 14:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218536;
	bh=Kbg+FpA2YNzlnucto3Eem1+b2gcC60BF64+RAtsOR8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G5cL3CPj7yEacNxdfQyCglE9vutJzr7oPcOmcjEypkixoNZgfZBmP8a4O+HWcn4w8
	 xdR/D49ePdUhIoQ8rsbZfpYtKBa7/9VOLeIszTTi8JjOuANGkJViOaoYqXpwOEBOvq
	 jOJ01Nsj6zAG+cbvHdUBux6PTRhmEKFUjL7mtmOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 037/403] Bluetooth: L2CAP: Fix attempting to adjust outgoing MTU
Date: Tue, 26 Aug 2025 13:06:03 +0200
Message-ID: <20250826110906.843770792@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit d24e4a7fedae121d33fb32ad785b87046527eedb ]

Configuration request only configure the incoming direction of the peer
initiating the request, so using the MTU is the other direction shall
not be used, that said the spec allows the peer responding to adjust:

Bluetooth Core 6.1, Vol 3, Part A, Section 4.5

 'Each configuration parameter value (if any is present) in an
 L2CAP_CONFIGURATION_RSP packet reflects an ‘adjustment’ to a
 configuration parameter value that has been sent (or, in case of
 default values, implied) in the corresponding
 L2CAP_CONFIGURATION_REQ packet.'

That said adjusting the MTU in the response shall be limited to ERTM
channels only as for older modes the remote stack may not be able to
detect the adjustment causing it to silently drop packets.

Link: https://github.com/bluez/bluez/issues/1422
Link: https://gitlab.archlinux.org/archlinux/packaging/packages/linux/-/issues/149
Link: https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/4793
Fixes: 042bb9603c44 ("Bluetooth: L2CAP: Fix L2CAP MTU negotiation")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 4939152f6adc4..1272ad73e4011 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -3484,12 +3484,28 @@ static int l2cap_parse_conf_req(struct l2cap_chan *chan, void *data, size_t data
 		/* Configure output options and let the other side know
 		 * which ones we don't like. */
 
-		/* If MTU is not provided in configure request, use the most recently
-		 * explicitly or implicitly accepted value for the other direction,
-		 * or the default value.
+		/* If MTU is not provided in configure request, try adjusting it
+		 * to the current output MTU if it has been set
+		 *
+		 * Bluetooth Core 6.1, Vol 3, Part A, Section 4.5
+		 *
+		 * Each configuration parameter value (if any is present) in an
+		 * L2CAP_CONFIGURATION_RSP packet reflects an ‘adjustment’ to a
+		 * configuration parameter value that has been sent (or, in case
+		 * of default values, implied) in the corresponding
+		 * L2CAP_CONFIGURATION_REQ packet.
 		 */
-		if (mtu == 0)
-			mtu = chan->imtu ? chan->imtu : L2CAP_DEFAULT_MTU;
+		if (!mtu) {
+			/* Only adjust for ERTM channels as for older modes the
+			 * remote stack may not be able to detect that the
+			 * adjustment causing it to silently drop packets.
+			 */
+			if (chan->mode == L2CAP_MODE_ERTM &&
+			    chan->omtu && chan->omtu != L2CAP_DEFAULT_MTU)
+				mtu = chan->omtu;
+			else
+				mtu = L2CAP_DEFAULT_MTU;
+		}
 
 		if (mtu < L2CAP_DEFAULT_MIN_MTU)
 			result = L2CAP_CONF_UNACCEPT;
-- 
2.39.5



