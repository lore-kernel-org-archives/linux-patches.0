Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 708522727F3;
	Wed,  8 Apr 2026 18:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674283; cv=none; b=hTBZZ8c/fhlQtUSSBPFQHl7azHTyTsIPQRRrTxIdBixS7obaji+lUnM8txvtWjLBxHXZ7T0kyWlS+Zz+ARQWFz5Hu9IUr78P/NWM0rNARzIutYU1YSQijg1J9EtqTbexGLQiCMak5Hy4rPp3gbcNk7hcPHCVbIrkhAjun/3h1gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674283; c=relaxed/simple;
	bh=OBJrZLgvCO52phuyv5JF/AJTtZZtB/cGe2spJfap/Eg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k70uBk5QZXVSbqWtw8yTaKlpIJhV/O34RI98n8yF5RaZN4sUlYARoTIEouBKHqgaQnY2JdxPquNYuH0u/A0D3wU3QLFBVfqHfB2MtCyBFJ0N9ahlShyjy0ArksSBEbrRFc/O1ItlgahsqKicWjCJuEvK2NcwWexkINgGhV5fsOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aYXxVppU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aYXxVppU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D63F5C19421;
	Wed,  8 Apr 2026 18:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674283;
	bh=OBJrZLgvCO52phuyv5JF/AJTtZZtB/cGe2spJfap/Eg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aYXxVppUHK5cW2HS+aecTz4nTMdY2rWFLGj6Zqn87ZUL5yJx+yBZoTuVU9xZoQMNR
	 jZ4Y2368DfDCxCIZyavuxGNvESC5L5mgrt/tQV8AG3wOZfU2bF9kxtKFrYn7HaQIWK
	 pecwVxufzor3Den7zjFXY5o7AV92CUTCXI1LSWwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pepper Gray <hello@peppergray.xyz>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 009/311] arm64/scs: Fix handling of advance_loc4
Date: Wed,  8 Apr 2026 20:00:09 +0200
Message-ID: <20260408175939.758807470@linuxfoundation.org>
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



