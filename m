Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A105349B7;
	Wed, 23 Sep 2026 14:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174229; cv=none; b=NvCXzRbYmU5y+oo50tbUYn2Dcgta3gTz4oEUPqsuKKcHxqw23Cy9QVyveCu5aawtEwrkfO95HLJNrTJ+RjHWqIFiG8Dzhh6i9D1H2YlmiFaSjwAIQ9EwHovUG/y5aEQpkzpmJPLZ2Pse0UxFcYRnju6Ud2VI/Ha0Z/8kllzpbkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174229; c=relaxed/simple;
	bh=uAqXVlsYMmriBZV6/I+vUOvAFUwHkTGS50ZxRu6AxxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hCrtx2I1R5o2rmF6FG0WwoKx2A9Ly7fyzhDuHHS5pkUfHRkjbagx6nJordJMbYRqMZ82s1CpOpQiXcxH6In+GNBi5TqB4lwtNacs6x2TKCUtRaXFzCnua1JAlkXgW9LsbyPJp5yyaYoEPNZa+qW0COVyGX1Pt39Txng1AuDshqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V9tdvBE0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V9tdvBE0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59DD21F00893;
	Wed, 23 Sep 2026 14:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174227;
	bh=AmoxW4KNXtzPCQ8YecK6Gg8z8TSSE9y1nh1nHUT4axk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V9tdvBE07F8O1L4l8KeYz/PXRU6CuRo8HO0bcBhGUGzmENEUKaqfL9hzxdYNwREYM
	 wnUzPq8uuuoANnphVveWgOx3ouAvuUIi6s6NQxFTkinbL+F79tfu9GQ5jit6eJZQoL
	 i5gDDWoC7mj0fkMql4X6Jvei5oGuo/oa8FhEvZTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shmulik Cohen <anuk909@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 049/398] wifi: libipw: reject too-short association responses
Date: Wed, 23 Sep 2026 16:02:03 +0200
Message-ID: <20260923140644.693290865@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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
index 2661dac6985e4..424349a6935e4 100644
--- a/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
+++ b/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
@@ -1209,6 +1209,9 @@ static int libipw_handle_assoc_resp(struct libipw_device *ieee, struct libipw_as
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



