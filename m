Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0E93B0ADA;
	Wed,  8 Apr 2026 18:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672860; cv=none; b=oQGNHJa4vvV1wkNnLnRrsXX045bClSnmIvtdTiK8PaGAB88HawbvZu4dc/BviM2ZMjUcw2znjUDuf0NePK7pm/49r1AGmjJVt+l2/qCyKfc7mgD91tHzs2QKJGdyU16VBYqhxzREczExHCt026vNUXzFv3oPFodJwBUznro8ORU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672860; c=relaxed/simple;
	bh=PDhdkuTah6hMwDvo9wkBvsSfOHvMi74/z6fJXhvcu28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C1RdiyAaUbLaYVS20C+ltDvT00NF3Iq6n8PdPWbVx9a13EJh3lZ1H63fdkbz5nyGG6RuOrYlzr5dtWw13qi+xXE/X5ZJqL3+d1TD2SaRuaB6Y47pj77ZedVbEyPG47hipRTU2lMuonREVGTVFokbvIzalNs4CSnNWzRTt9Ij+1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h4+f1Iwp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h4+f1Iwp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6A74C19421;
	Wed,  8 Apr 2026 18:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672860;
	bh=PDhdkuTah6hMwDvo9wkBvsSfOHvMi74/z6fJXhvcu28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h4+f1IwpxOlPs0Hv7c4jVkKJG4cyVDf25m/6z+xdvFaJ5g4/wMSAYoOdH8ccy8ps2
	 /ovCEMwSJKT2SmvKuR37zr+a5fsjxOp/ppfXXMOkJkpOB8fr0Pg6RNjnsN1YwC8Ux1
	 8ayCoRgTcdVcskA+emvyQrQsq1bxO0KINynhGufc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pepper Gray <hello@peppergray.xyz>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 001/277] arm64/scs: Fix handling of advance_loc4
Date: Wed,  8 Apr 2026 19:59:46 +0200
Message-ID: <20260408175933.895784114@linuxfoundation.org>
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

From: Pepper Gray <hello@peppergray.xyz>

[ Upstream commit d499e9627d70b1269020d59b95ed3e18bee6b8cd ]

DW_CFA_advance_loc4 is defined but no handler is implemented. Its
CFA opcode defaults to EDYNSCS_INVALID_CFA_OPCODE triggering an
error which wrongfully prevents modules from loading.

Link: https://bugs.gentoo.org/971060
Signed-off-by: Pepper Gray <hello@peppergray.xyz>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/pi/patch-scs.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/kernel/pi/patch-scs.c b/arch/arm64/kernel/pi/patch-scs.c
index bbe7d30ed12b3..dac568e4a54f2 100644
--- a/arch/arm64/kernel/pi/patch-scs.c
+++ b/arch/arm64/kernel/pi/patch-scs.c
@@ -192,6 +192,14 @@ static int scs_handle_fde_frame(const struct eh_frame *frame,
 			size -= 2;
 			break;
 
+		case DW_CFA_advance_loc4:
+			loc += *opcode++ * code_alignment_factor;
+			loc += (*opcode++ << 8) * code_alignment_factor;
+			loc += (*opcode++ << 16) * code_alignment_factor;
+			loc += (*opcode++ << 24) * code_alignment_factor;
+			size -= 4;
+		break;
+
 		case DW_CFA_def_cfa:
 		case DW_CFA_offset_extended:
 			size = skip_xleb128(&opcode, size);
-- 
2.53.0



