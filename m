Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316FA3B776C;
	Thu, 17 Sep 2026 17:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664836; cv=none; b=UZmIo48aBv3XlsVKsDlIN2qkDY9lBNg3X0e1M+fafXQzrr6CBnVQM+twPrE+zYn31+2/Cx9Ey6GscOEd/MTLJLChctwm7I7Y+DEEUVI9ReUoj9I2VuYTSkP9F43sF75+JPUPjEYPoCbR6f54b7zAsa2clXVTAW4NdL4DSJst+Ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664836; c=relaxed/simple;
	bh=zi0NCtTTf8+4PP4cCQbtKDSkaBwxSG1JU9M5k64QdoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uqkHs0DYnFSgNPkPdgraZtdKZ9tYvhh02gLp9aaD0VCIdIoLseem6EmEdVFLG6+Dq2rUKy3x9Q7INMAI3nuZaReJ5m9JW2ihcnIRvSE2fLp4G+0QaTUBv2IaXpaH0ohUcO8eQLFsgHzVdVCgEN5Yg7leMvEmiyfS0fXtlgLyiwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zxrG2S3g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zxrG2S3g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83A791F000FF;
	Thu, 17 Sep 2026 17:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664835;
	bh=l/LjKbmzfCJMW/5DBDIxnHwsjw/+2wxcMExirc5FFns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zxrG2S3gN0VRrOhiGVjnaTS2O+UQOJn7HJnP8jgbI3tZGUpPLAc+MGrbVP5aw/D/c
	 Wf4I8YLYXhd5uUZMKgenPceT0KJJ6DjXlBfbXsM/y/QxcbcSqg+oHd3JVv5UyEY4gQ
	 4lyyU5OK2Tbjq/I6sXHC/49Y/vDCecesQ5NBBL9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0503/1250] wifi: libipw: fix key index receive bound checks
Date: Thu, 17 Sep 2026 16:04:58 +0100
Message-ID: <20260917151605.593428136@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 74ed3669f26803b1761c1f55403062bea44c3466 ]

libipw_rx() reads skb->data[hdrlen + 3] to extract the WEP key index in
both the software-decrypt key selection path and the hardware-decrypted
IV/ICV strip path. In both places the existing guard only checks
skb->len >= hdrlen + 3, which proves bytes up to hdrlen + 2 but not the
byte at hdrlen + 3.

Require hdrlen + 4 bytes before reading that item in both paths. This is
a local source-boundary check only; it does not change the key index
semantics.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260705083519.23567-1-pengpeng@iscas.ac.cn
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/ipw2x00/libipw_rx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/libipw_rx.c b/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
index b7bc94f7abd8a..c8841f9b9ad91 100644
--- a/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
+++ b/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
@@ -414,7 +414,7 @@ int libipw_rx(struct libipw_device *ieee, struct sk_buff *skb,
 	    ieee->host_mc_decrypt : ieee->host_decrypt;
 
 	if (can_be_decrypted) {
-		if (skb->len >= hdrlen + 3) {
+		if (skb->len >= hdrlen + 4) {
 			/* Top two-bits of byte 3 are the key index */
 			keyidx = skb->data[hdrlen + 3] >> 6;
 		}
@@ -660,7 +660,7 @@ int libipw_rx(struct libipw_device *ieee, struct sk_buff *skb,
 		int trimlen = 0;
 
 		/* Top two-bits of byte 3 are the key index */
-		if (skb->len >= hdrlen + 3)
+		if (skb->len >= hdrlen + 4)
 			keyidx = skb->data[hdrlen + 3] >> 6;
 
 		/* To strip off any security data which appears before the
-- 
2.53.0



