Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19895012B0;
	Thu, 17 Sep 2026 17:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666326; cv=none; b=MtyqeU+DUJKzhDV13Y7kyC7O56f3dObYNp3uemNhnTZYkr+ZzICuWwMc7S+U+xuBQ6AMcxaNERYIcWT4HTIB33LU/78U/y2MVdtgFYCDUheeiVrZBLtlshcE7BDBf9f3mVnI+GWaIerSjj8NpcDE1Fd8o711MwB6BbQWg1kxkJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666326; c=relaxed/simple;
	bh=32RAonvGakRl1g0BTgi4vUHsFzw4prIHRDXgCHjKPns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EYdTck4ey/MXA3t64+9VhFKvoPi2X3SY432eUvQRuIs702JDfrReaDx6dQAtV5p5RK15CUmN6GFPBGHUCledyzA8RJ2KrKFsd3Bl6CVLYfivrwiO92TEawl5hL1p0B9D05nw9F3hpIRZ4OkHiANYhtUYBL1gcoO/b07AtOIDQOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VIoDdffN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VIoDdffN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA6E1F000FF;
	Thu, 17 Sep 2026 17:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666324;
	bh=REQCHJPgg7D341rOBUqKEnnFdOBMwxmuGLfZrujVMUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VIoDdffNGcvmMYepSgyww2aX3MKy2921vcf1GApylY9NFseLUAmqnWJTtBwXur3om
	 32SGlRHFDO9dGHW3i55pcvbrhMmbc52M/8XI9cYN/WwvBmwPCi+cauUb7CGsAiSAPh
	 zn6/qqz1Gws9H9TxphMSJAPd0w4mCZx0AjLVy5ww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rong Zhang <i@rong.moe>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 0999/1250] Bluetooth: btrtl: Dont leak return code when parsing firmware format v2
Date: Thu, 17 Sep 2026 16:13:14 +0100
Message-ID: <20260917151619.114327883@linuxfoundation.org>
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


