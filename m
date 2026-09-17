Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E714F391F;
	Thu, 17 Sep 2026 15:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660220; cv=none; b=jQL0Fk91eugu5/JRgxH9VT3VGcg4L5AoIVYY9dRA2Et668THEqQnSJffrk9A55UrjO/YvyX6/W9ob0mSbHv+42kK0Qnpip+eRPyc9FrLKNFufUModSMHcsqNeIjk0rniMOU4kp6zXrBSdGf5hhOqfMhplM7EP/X8ofUA42QUVhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660220; c=relaxed/simple;
	bh=JNbbyF+iEy3QXbaNOliOYW/fTJs0aiLCKY8j6rc+2Go=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ozAQhhXKrAwWDAY2R5jP1elxsR0NrM8PkKPBpcmZjzfisCGt6dxIuVsQbUn5n6z8Ghqpmp9kzB27dYxX+m+2vBCTY06rM3mMNNSCk2TFpPFpgE4dRA2tbArWwop6jeFbwKfSrlRLPLBHo9iWReAfqCQSYtBHKYKiKeyZi+Fh63E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dp/LROIu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dp/LROIu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93EDE1F000FF;
	Thu, 17 Sep 2026 15:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660215;
	bh=iJ0XADePvmjS60aE0PTWPYYiJqgNAjYRv6vxdNquL4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dp/LROIuS7Gq/owyT455ShYTSZUGz1fy2DQKr2hhGeLTBGVBC1iriyT3ZmSeMUGDB
	 F2mIC/zRvnLyuHQCLLbJysC466j39Js/cPUMoSfnJTQgvZhNk+HVPw+CN9Yx1P2rFv
	 nzo4H2O5mA/IThlPW8XTnsGN3oCjW3sUAW3j6R6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rong Zhang <i@rong.moe>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.2 517/733] Bluetooth: btrtl: Dont leak return code when parsing firmware format v2
Date: Thu, 17 Sep 2026 16:13:45 +0100
Message-ID: <20260917151405.032928797@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -591,7 +591,7 @@ static int rtlbt_parse_firmware_v2(struc
 			 * headers.
 			 */
 			if (!key_id)
-				break;
+				continue;
 			rc = btrtl_parse_section(hdev, btrtl_dev, opcode,
 						 ptr, section_len);
 			break;
@@ -600,8 +600,7 @@ static int rtlbt_parse_firmware_v2(struc
 						 ptr, section_len);
 			break;
 		default:
-			rc = 0;
-			break;
+			continue;
 		}
 		if (rc < 0) {
 			rtl_dev_err(hdev, "RTL: Parse section (%u) err %d",


