Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9254736921B;
	Wed, 30 Sep 2026 15:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783362; cv=none; b=cxvB76sRrcZPWMznwmj5ErZFH7OzhxMThc7JrpBRBErqcgPxMpEg87erbuz16NQ7pvxEq+93uFMk8trR7jU20k4zh7e/ZHf5N+HZFDnB4eUc6zixNjxjl8bU28qgz+FMsVVDpfVGoqoNWn1koDys/Gb/Jb7/VZaEAtEA36FAnBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783362; c=relaxed/simple;
	bh=I9LAn83qPWCUrOICTAwssDlrdLDTdQOUCwzM87n1b/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b6HG5uHu0oOk0ZOjfUHDM9EyRjFDUXz8+f5yoNog/C3oyiyAx+YmJTMuMNHgbFCv+Bp/HbFLNlFfrDYutdk9InBwRPtzwVAyzL8fgwaAp7Hp3wexy/ezqpRhWu12uK4veeeJNfDy7u9LzQMBViUp8PeOiTrs0x4RMVrP1262TOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pFvVZGiT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pFvVZGiT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9E9B1F00893;
	Wed, 30 Sep 2026 15:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783359;
	bh=S5ZSzRvVsBhhl7b9hpxf1h2q+NTa0iBp4cn0ivb3vR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pFvVZGiT/5PzD5u3M9c5HUYAwVgdDhIygXRJqPriCkSQ1w+LcP5Xdzetms732x9DC
	 iGIUW4QWF52amRiOmpxRLB2erAxhQxLbALngBzgGkrc4h94lxJE17ZCgCklfXL6qgv
	 7hq96HTdhgOphZa4CeDLV2HoGbiES082MdAfOskA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shmulik Cohen <anuk909@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 371/595] wifi: libipw: reject too-short association responses
Date: Wed, 30 Sep 2026 17:24:24 +0200
Message-ID: <20260930152355.656925832@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

From: Shmulik Cohen <anuk909@gmail.com>

[ Upstream commit adb7118b7d2cfd7e8213c17d7d2829f353017754 ]

libipw_handle_assoc_resp() reads the capability, status and aid fields
of the 30-byte association response prefix and then computes the
information element length as

	stats->len - sizeof(*frame)

stats->len is a u16 and sizeof() has type size_t, so the subtraction is
evaluated as size_t and wraps instead of going negative.  Truncating
that to the u16 length parameter of libipw_parse_info_param() turns a
frame shorter than the fixed fields into a length near 64 KiB, and the
parser then reads past the receive buffer.

Both the ipw2100 and ipw2200 management receive paths reach this
function having established only that the frame carries the generic
24-byte three-address header.

Reject the frame before any fixed field is touched.

Found by an AI-assisted review of length arithmetic in management frame
parsers.  Verified with a KUnit case under Generic KASAN on arm64 under
QEMU; I do not have the hardware, so it is not tested on a real device.

Fixes: 9e8571affd1c ("[PATCH] ieee80211: Add QoS (WME) support to the ieee80211 subsystem")
Assisted-by: Claude:claude-opus-5
Signed-off-by: Shmulik Cohen <anuk909@gmail.com>
Link: https://patch.msgid.link/20260812190412.18333-3-anuk909@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/ipw2x00/libipw_rx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/ipw2x00/libipw_rx.c b/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
index c8b9b0875ab2e..307a1f06f9fe2 100644
--- a/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
+++ b/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
@@ -1324,6 +1324,9 @@ static int libipw_handle_assoc_resp(struct libipw_device *ieee, struct libipw_as
 	struct libipw_network *network = &network_resp;
 	struct net_device *dev = ieee->dev;
 
+	if (stats->len < sizeof(*frame))
+		return 1;
+
 	network->flags = 0;
 	network->qos_data.active = 0;
 	network->qos_data.supported = 0;
-- 
2.53.0



