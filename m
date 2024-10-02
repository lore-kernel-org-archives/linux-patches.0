Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A811EA80;
	Wed,  2 Oct 2024 14:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880653; cv=none; b=XTIajMoCRngy6M+eszLX6Lc0/TPxvizyAMWpMFTc8JXxISy6+GpXEiDo/haYTOnhWUWa+0bf4gPgyMBWDB+RjcqjJI7melOUfrh8Mxj0+FObfrma8nBIEHrEndqlI6j0OGg9E3Z73kijX3agu5eNp/nXXY7Kc42lcS9ZcWjOTZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880653; c=relaxed/simple;
	bh=7GZiSES1nQgGCTaXzh9tGDNQlAViaRhF9sk0L/Bt8Vo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lbix//+ia53LS7+Cyuc+O2bYkkeJGK0IcgJqtIXzDJ0VjiOIX9u8Y5fjXXBwY/+B5tcKeWJrsv9WY+9lT4XuKkJdgrYi0JAyFZ8l8D23R4OiyM4qfo2RBm5uvmLvhjzazralAikd7yhy+OS2ixmk3IokXrPLu85MR1cGlAjJ790=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sGzs5MWH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sGzs5MWH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11072C4CEC2;
	Wed,  2 Oct 2024 14:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880653;
	bh=7GZiSES1nQgGCTaXzh9tGDNQlAViaRhF9sk0L/Bt8Vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sGzs5MWHVCivJ7djjkbqGgYqQdJSpeFeiygcoHffcn0AVFVoS5u75X4+Qiud2Yg2v
	 v4Ee/UOy+CxEnJEUx/qpOHkHVJc9Ze+KbLCrBZVjmn9ru6n4mS5vAbEdq9chlzOFBt
	 M8lCxJwSjO7eAUC3OeTK+uwukpiCizXMLJ53HCZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>,
	Ilkka Koskinen <ilkka@os.amperecomputing.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.6 531/538] perf/arm-cmn: Fail DTC counter allocation correctly
Date: Wed,  2 Oct 2024 15:02:50 +0200
Message-ID: <20241002125813.405400009@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1794,7 +1794,7 @@ static int arm_cmn_event_add(struct perf
 			idx = 0;
 			while (cmn->dtc[j].counters[idx])
 				if (++idx == CMN_DT_NUM_COUNTERS)
-					goto free_dtms;
+					return -ENOSPC;
 		}
 		hw->dtc_idx[j] = idx;
 	}


