Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED7B372B5E;
	Wed, 30 Sep 2026 19:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795735; cv=none; b=V7vvDdtrxkVmfJiXTiLEtZsEt0Wncr0fkTaKMDhO2v3Vc1QRK5bCTcYbt672YcDwyUSISb2sna9EVmeIFUPG2BvC+EaG9kcJ5yfDU8VxAQ+LsGcTMQuw1a4xOAkoJyyPIOYdVcrj5KN03vv5fXT/96/0otL7Y+LHkJX/0s6sK7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795735; c=relaxed/simple;
	bh=QZW0Uz6mmpe1kfz2Ab7speMGcDsXNTfbQLXyL9wJ3Uw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Up/t5dJYNIThsfbjoCe7eVfPJnkJXUPgr55wuMSVB3u3FpcfoJoMxyzla8VBtW5mMOAnlKuSLtg+ckhB+TDDPMwxPwgJs1E55r0kbZyAIIL9YGAvf4uGb4CcTWnVBr6K3HyrHBqouX3tU4ytfQL6HoO5EdX3d55JOhr/sUObm6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zra48CPl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zra48CPl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 478631F00898;
	Wed, 30 Sep 2026 19:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795733;
	bh=wxt1mHijC+ttoOobG3q1cZJNsmtocqhbr0uyuScHdCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zra48CPlUYR/J+NHrkh1b1r7SCBHoqIXS+GhCW9Jt7psfYObMkSQJHwjheqkJwQHU
	 VNPCLPCxciNRzKbVNlRnkyX0yGFouWE7ZrVv+6oHnadF7HXPcMd/4eBHh3PMrVBXhx
	 z0ZVyHqamXzQVZmIFqnsZXhQScCd754hjuYAX0b0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rong Zhang <i@rong.moe>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 0619/1193] Bluetooth: btrtl: Dont leak return code when parsing firmware format v2
Date: Wed, 30 Sep 2026 17:21:43 +0200
Message-ID: <20260930152447.997224764@linuxfoundation.org>
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

From: Rong Zhang <i@rong.moe>

commit 83e3e515fd261600ed8491fb0a8bcdfb115c904e upstream.

When key_id from chip is zero, rtlbt_parse_firmware_v2() intentionally
ignores all security headers. However, the implementation simply breaks
from a switch statement and leaks uninitialized return code `rc' (if the
first section is a security one) or the previous section's `rc'.

Fix it by really skipping a loop with `continue'. For consistency and
readability, also do the same for the default case.

Fixes: 9a24ce5e29b1 ("Bluetooth: btrtl: Firmware format v2 support")
Cc: stable@vger.kernel.org
Signed-off-by: Rong Zhang <i@rong.moe>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btrtl.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/bluetooth/btrtl.c
+++ b/drivers/bluetooth/btrtl.c
@@ -560,7 +560,7 @@ static int rtlbt_parse_firmware_v2(struc
 			 * headers.
 			 */
 			if (!key_id)
-				break;
+				continue;
 			rc = btrtl_parse_section(hdev, btrtl_dev, opcode,
 						 ptr, section_len);
 			break;
@@ -569,8 +569,7 @@ static int rtlbt_parse_firmware_v2(struc
 						 ptr, section_len);
 			break;
 		default:
-			rc = 0;
-			break;
+			continue;
 		}
 		if (rc < 0) {
 			rtl_dev_err(hdev, "RTL: Parse section (%u) err %d",


