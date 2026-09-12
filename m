Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA279345EA7;
	Sat, 12 Sep 2026 14:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224907; cv=none; b=qmELeA/NrvvAjfLKEd6oFtchwgt/09eOMtf4o+xmcvF4FEhjD73vTvA78Z3vTfqPLCJwDrZioNjco9tC9Aw36WcW6ymqVCSxeHvfZov3PztVPISwcFEKCxokIn2/XBpwTJz5ukQ34R7zYEUcWFjiTcrQlAt9yUvpvjZZ2Pq1i7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224907; c=relaxed/simple;
	bh=xlRNI/ZU4dSYLB6jzC5qrsL0QOcVlbZ3f58w6i6p2ak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rI/c1k5hurzbSR06s6Q65SDP87LdTR7NYyuaUp5UkAxAjpqW7hN+y/vGuGjPSmM+y3T1Uj4yOW2RF1LiUb9CuuQ5uI11QlQ7AZPXfEim5KwUlEFAKAjbS3oyYthrndJ+l4kbodjAog+9msyuBUVRXaCi/gR3qM2pAaWZR+Q1H3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SxUIRsEd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SxUIRsEd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EA971F000FF;
	Sat, 12 Sep 2026 14:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224906;
	bh=tPN21LpWourQ3I7F4nD0CqrBfQyZXvtt7DgGu3rhE4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SxUIRsEdktAY5/KUiGWjj/bEShVQkwr0wRlj6jCOfvWcCjGQwcJrkJ9GLLNvuQprb
	 sy4zLyUGqkk8emNNwthpb70Fb/ViRfqeAsOfM6Hr93dXhg642QYQAbjm209oZbQPVW
	 X3ETLF+vIsUc8yipXoS0ZQfo41k6OHsxlln57ehI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1087/1424] arm64: hibernate: Restore DAIF state on error
Date: Sat, 12 Sep 2026 08:58:39 +0200
Message-ID: <20260912065631.649894458@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Vladimir Murzin <vladimir.murzin@arm.com>

[ Upstream commit 541549827889d0380fd73f8aacb5de6ef7a5a1ac ]

Sashiko AI has reported that if swsusp_mte_save_tags() for some reason
fails we return from swsusp_arch_suspend() with DAIF being masked -
that is not what we'd expect. Restore the saved DAIF state before
returning from the error path.

Fixes: ee11f332af96 ("arm64: mte: Save tags when hibernating")
Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Reviewed-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/hibernate.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/hibernate.c b/arch/arm64/kernel/hibernate.c
index 165f61b07da13..6a357dfd19ce1 100644
--- a/arch/arm64/kernel/hibernate.c
+++ b/arch/arm64/kernel/hibernate.c
@@ -342,8 +342,10 @@ int swsusp_arch_suspend(void)
 		crash_prepare_suspend();
 
 		ret = swsusp_mte_save_tags();
-		if (ret)
+		if (ret) {
+			local_daif_restore(flags);
 			return ret;
+		}
 
 		sleep_cpu = smp_processor_id();
 		ret = swsusp_save();
-- 
2.53.0



