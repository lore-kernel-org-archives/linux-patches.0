Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2554F25A321;
	Wed,  8 Apr 2026 19:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674933; cv=none; b=ZckBOT53+0kIdOt109REIsqCvsnzqntOM1veXJ37YpbPbAcjv1mljCYlr060TtkLRbi0YvTlw//ayonlxAf9b0tlBo220r1ZpSoNTLCpQSio+NUea9NDBVgD//5sMDoGZKi8knz7mGL4U3U+TffCBNA4FerMlcw81kRHyidMFh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674933; c=relaxed/simple;
	bh=aTKTRM+qWIWVlOBGELy7qXQjKnKRbtd5rMpQPvybXDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=akyK6qsPZyg/ZuIibrJF+EfWf0np9180b8+VDFfPlH56sn++wI/eEjj4m0eDRRwVFBbWyQVzvMLJOMcdIA5RpxImHB8Otp5aJ+D4FnyM0NUsqsy5CPy2elTMtbLogdcLQLW3oNCxA62DeKIjmtivYDsW+tsa322NMapehevQgyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s8PGvXHY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s8PGvXHY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE49AC19421;
	Wed,  8 Apr 2026 19:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674933;
	bh=aTKTRM+qWIWVlOBGELy7qXQjKnKRbtd5rMpQPvybXDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s8PGvXHYvDx/nvN7GRhgJVeqFxoXwtP34Dlgfhhbn19udlKaeuQPFARLUZHA0hmMS
	 /5HHwd2bKxRgWVICgfwPI0zdU4KjiZl66HGD2aRL/oDAX3pcHKRflLD4mSxqOhOKGE
	 xXWfPpxPvghsrhqTSERjO5mnKG+MgwR16Dw4UZQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.19 290/311] thunderbolt: Fix property read in nhi_wake_supported()
Date: Wed,  8 Apr 2026 20:04:50 +0200
Message-ID: <20260408175950.208908021@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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


