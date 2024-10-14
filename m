Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498431AA793;
	Mon, 14 Oct 2024 15:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918609; cv=none; b=TuaI8WbkAA6MtxOU3+32CtbY8iA9ZOjEDVioRQgqVqVeAZn6PaVHk/v2Ibuq48GupcEbjxTgQalY1xvdtoC/JA342s7XHZp1YgRPIRs54UR1/S7XK3ApOg+VKMV5yS9nK9Gj0YEGLwS4hwXGEmXy7gAy/VRFYHNp/jd6gOLKJYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918609; c=relaxed/simple;
	bh=TX8WNMV4EoJgL6Fl5HjnstJ2Ym8QOCRIfZm005qvx4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tUz6IwR1DOBPYk4WKPUkyZW0albNFFK7UpnHlbsf8gG48rwJpAIVMF16HXus+cqZ7u0fUzriHq8ga13nx4cPiNBKFoX/rN2NXzZSWwo67iMhmTgj7Da9FrJsiPaao4T1rzCoLH26G26tEjzc/BL9/APMFyU/6clQvlhzoPN6RsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DiVj4vwI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DiVj4vwI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AF38C4CEC3;
	Mon, 14 Oct 2024 15:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918609;
	bh=TX8WNMV4EoJgL6Fl5HjnstJ2Ym8QOCRIfZm005qvx4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DiVj4vwIhqrPleCqJffQLxvsAaG0HdGQhigzvwRaFVCa4FdePYafoFdoL3lwXIXwa
	 HFvx3nvQ574uqcxirJwkz6e7j3PS8hofF6umXdyHqx14Jm3cPLYf/3JNK7t5nTo8yI
	 /3VhHsMqa1gY1fus3EBBD+IxUvBGpUFheehEjkF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>,
	Ilkka Koskinen <ilkka@os.amperecomputing.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.1 371/798] perf/arm-cmn: Fail DTC counter allocation correctly
Date: Mon, 14 Oct 2024 16:15:25 +0200
Message-ID: <20241014141232.526096149@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robin Murphy <robin.murphy@arm.com>

commit 1892fe103c3a20fced306c8dafa74f7f6d4ea0a3 upstream.

Calling arm_cmn_event_clear() before all DTC indices are allocated is
wrong, and can lead to arm_cmn_event_add() erroneously clearing live
counters from full DTCs where allocation fails. Since the DTC counters
are only updated by arm_cmn_init_counter() after all DTC and DTM
allocations succeed, nothing actually needs cleaning up in this case
anyway, and it should just return directly as it did before.

Fixes: 7633ec2c262f ("perf/arm-cmn: Rework DTC counters (again)")
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Reviewed-by: Ilkka Koskinen <ilkka@os.amperecomputing.com>
Acked-by: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/ed589c0d8e4130dc68b8ad1625226d28bdc185d4.1702322847.git.robin.murphy@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/perf/arm-cmn.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/perf/arm-cmn.c
+++ b/drivers/perf/arm-cmn.c
@@ -1671,7 +1671,7 @@ static int arm_cmn_event_add(struct perf
 			idx = 0;
 			while (cmn->dtc[j].counters[idx])
 				if (++idx == CMN_DT_NUM_COUNTERS)
-					goto free_dtms;
+					return -ENOSPC;
 		}
 		hw->dtc_idx[j] = idx;
 	}


