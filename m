Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949EB3DA7DD;
	Wed, 30 Sep 2026 19:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795962; cv=none; b=qF6shJ/7uvDS4+oi07rZwht4IzlgOx+yd3Jq3a/7u/HXwbo8Rmcp4RJxG9ppCpeISdRfOMlKFA6M1XZs/d9KWJh/twYY/ncpfV7dpLpJeATU1iaSJlpRaXl0jYibfS7mWrbA+DNAGSK2ti2hh2K4ZC1a/DadNhCiuc0YJKEar7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795962; c=relaxed/simple;
	bh=O/+WWp8NG0GjgunPtJKzVUp1o5BXtyf1LPr8aFqFIb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gl8wSgEW3PhVVnNTcEGZ1TPIuBEW3rdlSBSSYsS91059HpKZaKnLP/fvHwDqAY72J1AnmQ1yL4ZfwNztZM3qC4+UZAP2oQVPFW7YMs66dVfX+/sfpaVtk7UKbhtikOY0dxJ7Xm5HStVCLfTlf8B8cpk0bkzbX9Q8kxzsXXpN/nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bd5z1u5X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bd5z1u5X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E03E61F000FF;
	Wed, 30 Sep 2026 19:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795961;
	bh=lQ1B/nmjYnhRWfSyD+tyOUADecNmaJCyVZpZgnOWx0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bd5z1u5Xc6n7pFDxyBURDhj652uxAX9yeQZTNxOP7wRI8fTAELazoVec+q1gomKNI
	 5pYKHyX+RSyQVUzX9Xyk1HQ3V6PZ2kxjLOdU/kvLipPSxw5RQ6vZ4q6PRM9G0C1rBM
	 CEllVNbK3bjZlNzHvohXK6IogF3pAlXfBNdLbhQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shmulik Cohen <anuk909@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0744/1193] wifi: libipw: reject too-short association responses
Date: Wed, 30 Sep 2026 17:23:48 +0200
Message-ID: <20260930152450.780071911@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index 33f5dbe274c74..762ed2704bf65 100644
--- a/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
+++ b/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
@@ -1302,6 +1302,9 @@ static int libipw_handle_assoc_resp(struct libipw_device *ieee, struct libipw_as
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



