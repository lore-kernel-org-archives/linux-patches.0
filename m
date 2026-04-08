Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B943D8905;
	Wed,  8 Apr 2026 18:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674058; cv=none; b=Feq9Q9aDW9jOooMOPqphvaceviiISEgBazhM6Ju1Hb9GIaC+lzTgNiqZQFmE7EdejCTB2bTG2Kg5/dhpRzgJzADxCmKnhNWJOjqzAaBk9hs2OVKdI8n/Aqjr1bxo075NnWzGsWLvpEYauafBBVJukzzJRdkKNdSLdpN6wZxXPnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674058; c=relaxed/simple;
	bh=YP7JVdyNpbTCPNx2tyL3jR3GNurLETxnixFU4Zc/bpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iWn/73PTN/qEIYcnuuslBlJeH3n0/pgn/egkdR/WQPAzdSpkiymPqzokB2q8eZyUV8qleFDG5xvQR1yrFupw8hppYbeaO8KX2y3WneH/PVBXen8gzzPaf/NMxXIlZcfb5Fopo1g/HVqAdJn55TrNHYQzdCN71GJWZtzuUZNYoao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=onoJAtz5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="onoJAtz5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66829C19421;
	Wed,  8 Apr 2026 18:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674058;
	bh=YP7JVdyNpbTCPNx2tyL3jR3GNurLETxnixFU4Zc/bpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=onoJAtz5pDr4vKjWPeU3FYTajQ4Lzf6kjE0pwWpz/nrrs/BiSnwfyco+joW3oURgs
	 QuU3Q9QnUbuJW8PdlSg1ahVvsNcbTt5pIjGc4q4ZpwoBJLB2Fj2qebjMEr3sEKH0cV
	 MaMAxICPrK5hxsWzqOCumqjPEJMEsUCMfnMg1qbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.12 193/242] thunderbolt: Fix property read in nhi_wake_supported()
Date: Wed,  8 Apr 2026 20:03:53 +0200
Message-ID: <20260408175934.308759210@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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
@@ -1010,7 +1010,7 @@ static bool nhi_wake_supported(struct pc
 	 * If power rails are sustainable for wakeup from S4 this
 	 * property is set by the BIOS.
 	 */
-	if (device_property_read_u8(&pdev->dev, "WAKE_SUPPORTED", &val))
+	if (!device_property_read_u8(&pdev->dev, "WAKE_SUPPORTED", &val))
 		return !!val;
 
 	return true;


