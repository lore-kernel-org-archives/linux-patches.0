Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA25B211468;
	Thu, 13 Feb 2025 14:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457969; cv=none; b=JBmoaX59qJN7MzK23wSPS6Z3LHjoPC+GWHgHxou9+HL8oaFB0xe5FOSVP1Jv9o0Pd1TqAQeaQwwaz9ATCrGTR1Zp8zcn12nJbZjUAhitZtmi3C/SZxmxfC2J1kKVRzUuGnC1/yg/OqVKMJOhRU8F1ra/0SoujKatZPX9Cl9rJEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457969; c=relaxed/simple;
	bh=UPNdboZj/N+JFP8DWY46Hj/LAHK7QHaalhINdJ/0jh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FJgVzBbuFwAZWjzLc45o6ezNIcjm2rpGZ68JILq7MB9Db7G1nnhXLyB7EMI7VaNHWvbLrfMW7SnGtdtpf71PCZxPOdXPjfCnBuALhNFX4Tmoz+N/C9HGGOkrxslAv/ydMAJo5nC0JlsEEAmXAj+r7+VgIWmnqaN2v+aukA7Fndo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2VsoHubL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2VsoHubL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FAE5C4CED1;
	Thu, 13 Feb 2025 14:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457968;
	bh=UPNdboZj/N+JFP8DWY46Hj/LAHK7QHaalhINdJ/0jh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2VsoHubLzEGSIC7xlohsDtBZBzTfBSLfyIfVaBhWxiVkj1lcuCNoN27yp+W6S+Pqq
	 UBfXsd6nyxmP42Zm4Ei+hcqirBBHOOesTg5uiqwPD9vUv0D6/nWFV5oE7eWQXJgPle
	 eJdQZVyVOCOzlKBVsuuJrEpvcvBozJnmm6bQ+aHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Narayana Murty N <nnmlinux@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.12 232/422] powerpc/pseries/eeh: Fix get PE state translation
Date: Thu, 13 Feb 2025 15:26:21 +0100
Message-ID: <20250213142445.489551211@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -580,8 +580,10 @@ static int pseries_eeh_get_state(struct
 
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


