Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17FE71C3BEB;
	Tue, 11 Mar 2025 15:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705805; cv=none; b=qIR6qN4pDKbDTIzjYyi3BYq06Rz1kmx+y2z/ESHDOLDPJS9td5tFkDMZpHNBbompDkrbEJ9xHme0nRu5ofP7teeO0ZlFP38hoTaFcN949ZWAvGEFjIjIHbfTafljcYUpDiUSQyW8fROPZLmlYgbmML3tQZgXRf/Gi23RF8JPp4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705805; c=relaxed/simple;
	bh=FKDplNzf8UNKtiNYxj9Xzb6OlJYAoT5dIrx98cNMOPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GJ7uv2RwcVqKqX+NOvoCDH7g85x3N70nrLZBMVBRwDSavIJguTdh2tCHfGqktQjVLMbrPXL2C1sVhImrq3iv2FPOyqVNqVBtxprSKY3Z7C0USJ47R8yw+AGG1cGmL7tk9Jp4w4NarFpoB3WGKPWNLMMjQfg2oUQjZ0SRFeLC5t0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DZh2Yfj/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DZh2Yfj/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 923DDC4CEE9;
	Tue, 11 Mar 2025 15:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705805;
	bh=FKDplNzf8UNKtiNYxj9Xzb6OlJYAoT5dIrx98cNMOPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DZh2Yfj/+zlVGl6+UMUV4LHf96kyqYSIcnY4zmk0k+kHA+ucM/PIjvHngs8olrKS4
	 /bdtZNNDMBkhhjrXRB/hdEVVBR4Y28CMQCxmOYpju7v+CQERjqwrpzn6Gf9Y9TRQF+
	 pZbdfPLeIyKHQ2+iUiuq2Xbxdu03UywYRROBUBww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Narayana Murty N <nnmlinux@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 5.4 142/328] powerpc/pseries/eeh: Fix get PE state translation
Date: Tue, 11 Mar 2025 15:58:32 +0100
Message-ID: <20250311145720.552847873@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Narayana Murty N <nnmlinux@linux.ibm.com>

commit 11b93559000c686ad7e5ab0547e76f21cc143844 upstream.

The PE Reset State "0" returned by RTAS calls
"ibm_read_slot_reset_[state|state2]" indicates that the reset is
deactivated and the PE is in a state where MMIO and DMA are allowed.
However, the current implementation of "pseries_eeh_get_state()" does
not reflect this, causing drivers to incorrectly assume that MMIO and
DMA operations cannot be resumed.

The userspace drivers as a part of EEH recovery using VFIO ioctls fail
to detect when the recovery process is complete. The VFIO_EEH_PE_GET_STATE
ioctl does not report the expected EEH_PE_STATE_NORMAL state, preventing
userspace drivers from functioning properly on pseries systems.

The patch addresses this issue by updating 'pseries_eeh_get_state()'
to include "EEH_STATE_MMIO_ENABLED" and "EEH_STATE_DMA_ENABLED" in
the result mask for PE Reset State "0". This ensures correct state
reporting to the callers, aligning the behavior with the PAPR specification
and fixing the bug in EEH recovery for VFIO user workflows.

Fixes: 00ba05a12b3c ("powerpc/pseries: Cleanup on pseries_eeh_get_state()")
Cc: stable@vger.kernel.org
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Narayana Murty N <nnmlinux@linux.ibm.com>
Link: https://lore.kernel.org/stable/20241212075044.10563-1-nnmlinux%40linux.ibm.com
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20250116103954.17324-1-nnmlinux@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/pseries/eeh_pseries.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/powerpc/platforms/pseries/eeh_pseries.c
+++ b/arch/powerpc/platforms/pseries/eeh_pseries.c
@@ -472,8 +472,10 @@ static int pseries_eeh_get_state(struct
 
 	switch(rets[0]) {
 	case 0:
-		result = EEH_STATE_MMIO_ACTIVE |
-			 EEH_STATE_DMA_ACTIVE;
+		result = EEH_STATE_MMIO_ACTIVE	|
+			 EEH_STATE_DMA_ACTIVE	|
+			 EEH_STATE_MMIO_ENABLED	|
+			 EEH_STATE_DMA_ENABLED;
 		break;
 	case 1:
 		result = EEH_STATE_RESET_ACTIVE |


