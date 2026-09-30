Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C240933DEF9;
	Wed, 30 Sep 2026 19:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795959; cv=none; b=mBHOmNmVIKrPJUNs/pgVMJaGx7b4LUgNHUqvKROULCbvuhRiEqFhYRupwjOAGvomkzjK+9pVvBtUB/X1RSVpADbCtSX6RnJAaK0mstK7U7MzlPiFeB1nCe/px53dyb30eRDH+GJMVs4JYmNu8PLep3CfNRrLK6I2cRlK/dzVHsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795959; c=relaxed/simple;
	bh=JU6XjjbzWd2snJUi7yhF7mY+0VGiT9TJZ/6fdCs+pqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hVvMy+NE9gMWTEZA8HaGe52BHyVtzlCnC8pvBGdelJ3dwjoxFT4kzvgKoMi256o1EccE5JY+kadp7dPBjWEsaUWODg3bFr9+7k8QB2sq6TFGyrw/meCllUjkBwpA6cPDu/o+wI5mNqn/xQ3dD0DStPwM1XsnOA9bvNQCXfFvrf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hkz1aG2F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hkz1aG2F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CBA01F000FF;
	Wed, 30 Sep 2026 19:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795958;
	bh=YPVZ5LI3r1TlD5ZLCIKo48+I+rzH/4EMqG7vlB1eBLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hkz1aG2F52lkmbnOcaC+/PsAF2V4vj7F1tEq7O/vYExWCrGQCb9kyVe+3RKMK3zeo
	 HWeNO4yjfgIFX27Vq3/kxCfKg+hcnCr0CnHJjvVXVFsV27j9y62XROcuOCsoH8iPCU
	 C3jZLbyXcowRBeMW36fIujg5qQncRjDHHc+1OdTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shmulik Cohen <anuk909@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0743/1193] wifi: libipw: reject too-short beacon and probe responses
Date: Wed, 30 Sep 2026 17:23:47 +0200
Message-ID: <20260930152450.758455194@linuxfoundation.org>
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

[ Upstream commit 5ce5721e8cbe3e80db8f43851cc2a2a92485ef4b ]

libipw_process_probe_response() and the libipw_network_init() call it
makes assume the frame contains the full 36-byte beacon and probe
response prefix, but the ipw2100 and ipw2200 receive paths only
establish that a management frame carries the generic 24-byte
three-address header.

libipw_network_init() then computes the information element length as

	stats->len - sizeof(*beacon)

stats->len is a u16 and sizeof() has type size_t, so the subtraction is
evaluated as size_t and wraps instead of going negative.  Truncating
that to the u16 length parameter of libipw_parse_info_param() yields
65524 for a 24-byte beacon, and the parser then walks the receive
buffer as if it held almost 64 KiB of information elements, reading
past the allocation.

Reject the frame before any fixed field is touched.

Found by an AI-assisted review of length arithmetic in management frame
parsers.  Verified with a KUnit case under Generic KASAN on arm64 under
QEMU; I do not have the hardware, so it is not tested on a real device.

Fixes: b453872c35cf ("[NET] ieee80211 subsystem")
Assisted-by: Claude:claude-opus-5
Signed-off-by: Shmulik Cohen <anuk909@gmail.com>
Link: https://patch.msgid.link/20260812190412.18333-2-anuk909@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/ipw2x00/libipw_rx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/ipw2x00/libipw_rx.c b/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
index 2220a9814c8a6..33f5dbe274c74 100644
--- a/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
+++ b/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
@@ -1514,6 +1514,9 @@ static void libipw_process_probe_response(struct libipw_device
 #endif
 	unsigned long flags;
 
+	if (stats->len < sizeof(*beacon))
+		return;
+
 	LIBIPW_DEBUG_SCAN("'%*pE' (%pM): %c%c%c%c %c%c%c%c-%c%c%c%c %c%c%c%c\n",
 		     info_element->len, info_element->data,
 		     beacon->header.addr3,
-- 
2.53.0



