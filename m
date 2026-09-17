Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 900E51D54FA;
	Thu, 17 Sep 2026 18:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670985; cv=none; b=MhQEmICn/w3muaDh6TolYkovcRS8dVbhL3xrdkr8s5C77+vVLyvGsc6uqcitgw5s9gwjdRZpowtOfS78kCIIQwWBg/48p7L+ABgXXV5a/kS3ae0hOEnLd36ztQDhf57rrA0I4jIVqZt6UBFvJlfu+I2kpEaDfql5ZURjbDr1ywk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670985; c=relaxed/simple;
	bh=8RLGa+hOCiOpVw4rXsYhfBYysWaxToqlTfMW6Ag/6vA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ngRfDslaPTo168Gj0JU1eZOjt+KohcmvSiSNu8bVOGiJEVgZg9zjb891HW6dgmg8uamqd/zdqXGisbCt60gOFq2B9o1rQrT7LsztEtbYJkkLrSZcAYppFihry2PRnxyIg4RyEfsJhrY7cuueihNxUlEBdOq8y6QMyXZVC15PtM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=alue4f5y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="alue4f5y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E79901F000FF;
	Thu, 17 Sep 2026 18:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670984;
	bh=Kr7kl2QHqmYug2Dq7cgNxqsqr2H59xu6I/Noscu7ppA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=alue4f5y9GT+1QtOqahhZjNTn8aR0FCGeCGPVuBsGSm8OXzDR0N86XJdYgEEFjlmj
	 2hgYUbVCUp5fQpTJXzNU5v7E85SzAwc74LCGVZGk6bNmrsDHn8LWZF1ihd+PycsE+q
	 6aLGl13vK3K67SbVA+TRjmsOkPy8CiJNKJL07I54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rong Zhang <i@rong.moe>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 0831/1102] Bluetooth: btrtl: Dont leak return code when parsing firmware format v2
Date: Thu, 17 Sep 2026 16:12:54 +0100
Message-ID: <20260917151601.374258379@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


