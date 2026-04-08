Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 820FA2DAFAA;
	Wed,  8 Apr 2026 18:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672442; cv=none; b=nRSXLYNDUCBOAzSZc3rD+WUUX1You4GjQTa4mGDkceQyjRTAA69zU7ffA9+Hgs8iW6hJgKlxibi/1x49sDvw3l8XvrSgSIXBGVSn809WPuYUpVr03idxUB+HSeph7L7bUw2IxVXevrQdbC/sS18rmQSuTEd/rN7NNZTxsLF/jIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672442; c=relaxed/simple;
	bh=fgRVhHe2L2x1XLjX+f9wZj4yMKtN5OxCEBNStb/YEj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hqCPdOBPcxswU8HaeaoxEmzey2wLWASdSgx37kIYblxHXEDrdnjKusOdZMMSDNhfXUMm42p19EIbSWT442fKvcUli5pLK7moxhFU6b7OIXEP2vroUOXtwx1I2bLcUbDluNW71nPPBZ7uqFjH9kx0UdfhiuSgxfB8cnEKKD3XxJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eV+WwhE6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eV+WwhE6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3099C19421;
	Wed,  8 Apr 2026 18:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672442;
	bh=fgRVhHe2L2x1XLjX+f9wZj4yMKtN5OxCEBNStb/YEj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eV+WwhE6MDK8jh4UYKraCQUXH/2cKVMuNVLW7E34RVxn7/IPE+VM3SVu7HXOtg41j
	 Bs76qaPyL4R4gZbbkOrNxLs4p8opfGMJNcI8Z4wgSHI+pe8qYnvUNSiWZPS5GzAmMy
	 IO7g58jAi4E1NaJCJPsVRZJN+6W0toQI/VLAjoSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pepper Gray <hello@peppergray.xyz>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 001/160] arm64/scs: Fix handling of advance_loc4
Date: Wed,  8 Apr 2026 20:01:28 +0200
Message-ID: <20260408175913.237623915@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
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
 arch/arm64/kernel/patch-scs.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/kernel/patch-scs.c b/arch/arm64/kernel/patch-scs.c
index a1fe4b4ff5917..6d656179ea03b 100644
--- a/arch/arm64/kernel/patch-scs.c
+++ b/arch/arm64/kernel/patch-scs.c
@@ -171,6 +171,14 @@ static int noinstr scs_handle_fde_frame(const struct eh_frame *frame,
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



