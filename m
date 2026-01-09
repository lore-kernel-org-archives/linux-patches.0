Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B319335A940;
	Fri,  9 Jan 2026 12:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961233; cv=none; b=CvAw2uWIopgtfy4HnwoaeYB3K9d5u4lsMhva4sF6lF1Il62h2PVa+g1Lc2mJZkQvIfDqRWmxyEyQZ9FJegtg1SonJZVZ5+/m8xvI1GKi4O2Uatx1Pr3QgOZ7nXL5FUOjUaHG7czYWtD+KgyWrWFIoFvN/RPvyeaYLCE19P3CQbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961233; c=relaxed/simple;
	bh=dDrtfvsD6CjIE/g3Lb+2foHCzaF2Hlav0IA/QM0ZUeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kTjdSMUu8c6VxYYE+g2XYLQlFOHWdR9CunTtfhpeV5CGCNXIg8z4EwsIXga1/ncq76R6+4kqLHdppdEfGOb7R4G13ZrzMyDQAN3+Xm+5xFw4p7FW6hrE69C5l4A21VXph2/EQyUPKhIQnqDvlmu36QtRCrwesgIkWgoIC3NCFwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IowdAzsb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IowdAzsb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4168EC19423;
	Fri,  9 Jan 2026 12:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961233;
	bh=dDrtfvsD6CjIE/g3Lb+2foHCzaF2Hlav0IA/QM0ZUeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IowdAzsbEInjxmIbINuLRtXIfwF4CJIUXOSzB/ow2HA8BNTQixAJhyERkNm2597+K
	 snn3SqxcwnWVLLG7qJ2C8HdqTsZbUP7UoDKfU4vbHt+fxYU4jYOMRO9rr/TDnKItvk
	 A+uAl217Z0UsYPprIM4XiN613DLeUYAgkOYr6bIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	jefflexu@linux.alibaba.com,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Stefan Roesch <shr@devkernel.io>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 682/737] mm: fix arithmetic for max_prop_frac when setting max_ratio
Date: Fri,  9 Jan 2026 12:43:41 +0100
Message-ID: <20260109112159.711036374@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Jingbo Xu <jefflexu@linux.alibaba.com>

commit fa151a39a6879144b587f35c0dfcc15e1be9450f upstream.

Since now bdi->max_ratio is part per million, fix the wrong arithmetic for
max_prop_frac when setting max_ratio.  Otherwise the miscalculated
max_prop_frac will affect the incrementing of writeout completion count
when max_ratio is not 100%.

Link: https://lkml.kernel.org/r/20231219142508.86265-3-jefflexu@linux.alibaba.com
Fixes: efc3e6ad53ea ("mm: split off __bdi_set_max_ratio() function")
Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Stefan Roesch <shr@devkernel.io>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page-writeback.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -750,7 +750,8 @@ static int __bdi_set_max_ratio(struct ba
 		ret = -EINVAL;
 	} else {
 		bdi->max_ratio = max_ratio;
-		bdi->max_prop_frac = (FPROP_FRAC_BASE * max_ratio) / 100;
+		bdi->max_prop_frac = (FPROP_FRAC_BASE * max_ratio) /
+						(100 * BDI_RATIO_SCALE);
 	}
 	spin_unlock_bh(&bdi_lock);
 


