Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B9536166F;
	Wed,  8 Apr 2026 18:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673475; cv=none; b=jdoL2OCyR7kPGEZdplPE+bX/AK2deAcSA+Vlu6ernynkDciu8+l6689oRWYnVpCIz0X4ZZIut7BVO6aW3U5CKVOtH6+Z0cxdJQ6YSoQUHJ0L2hI8EHOENJBESrMawagclT3/clvZSfy19n86RRRetHmPeDNcw9hyXve9+cAUK68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673475; c=relaxed/simple;
	bh=djxeK3yp77I/zJhI1nA5t0VGUIR85nuFxzx5cAzqdJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nbsQupFnCD46HS3Kz+NDWsVmNS0tecmk57aKmaJT3URnaq90XmzPVykYsYwI+HGrsZJa1trSexC2sjXVgRcI3LHs6YnjJyAUatBqwBUikguSCxG5mV+T+OQC7+tksaURHcoUSqYUFIuVTHFfHCY7AhjeceN6J16oCcLv3wgYLzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pzRnpflW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pzRnpflW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD55BC19421;
	Wed,  8 Apr 2026 18:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673475;
	bh=djxeK3yp77I/zJhI1nA5t0VGUIR85nuFxzx5cAzqdJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pzRnpflWRPWxcvUVf9LaLKtXDM0V03JUIE+xWMlxCpaaPUb5lLxcWhWR6vkG877jN
	 cIIPVgXr0qjI2OEDtQXoMxB6uGPfGCWTS4cp14I0Rls88K0pawwkmH1Kw8cXqRRf8M
	 2ffW2HQr4hIjtQevPokcZD9IsIv8QO7m4OD7uE/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.18 245/277] thunderbolt: Fix property read in nhi_wake_supported()
Date: Wed,  8 Apr 2026 20:03:50 +0200
Message-ID: <20260408175943.007403878@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

commit 73a505dc48144ec72e25874e2b2a72487b02d3bc upstream.

device_property_read_foo() returns 0 on success and only then modifies
'val'. Currently, val is left uninitialized if the aforementioned
function returns non-zero, making nhi_wake_supported() return true
almost always (random != 0) if the property is not present in device
firmware.

Invert the check to make it make sense.

Fixes: 3cdb9446a117 ("thunderbolt: Add support for Intel Ice Lake")
Cc: stable@vger.kernel.org
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/nhi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/thunderbolt/nhi.c
+++ b/drivers/thunderbolt/nhi.c
@@ -1020,7 +1020,7 @@ static bool nhi_wake_supported(struct pc
 	 * If power rails are sustainable for wakeup from S4 this
 	 * property is set by the BIOS.
 	 */
-	if (device_property_read_u8(&pdev->dev, "WAKE_SUPPORTED", &val))
+	if (!device_property_read_u8(&pdev->dev, "WAKE_SUPPORTED", &val))
 		return !!val;
 
 	return true;


