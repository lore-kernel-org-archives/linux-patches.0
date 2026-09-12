Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7BB440BCCE;
	Sat, 12 Sep 2026 08:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202186; cv=none; b=EqsteiSCKZ4z7Q/eeq7eyeyFrHgyPqHIG5C8DtvqP1PFPp+/kUQcaudX5Ka3ZZHKjUuk/RrwzvJyRZM9tUVAN6fBfASi3IvaET/XQQVa5MN7q1AknM6qvgxWS5OIIsZVk9OszjvMYMbWferkW2v6WgvH2jNK98YedXB+hYeGl1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202186; c=relaxed/simple;
	bh=NZhz9CsCekul3Zpc2gEaXo849/XCeWYai5ClvEuYCwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jpnCNiApmW63+D/skLgrmg4XP7H//pS+1qCmnek/AAhVtkSgCJ3CNFZdsG5G/1gS1OuhzgblkY6+06u7dXmNJiWF2ZjZL3yS5iJ3IxHWdP69QvDBKPlSkGJHIQJSmf/Yd1wTgQaHxLHgjDrGmvoVf7d7wdSWwAvCqNFkcfB3hhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZSVD8Ntu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZSVD8Ntu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 993431F000FF;
	Sat, 12 Sep 2026 08:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202182;
	bh=0EyDAuDw5EjTxdpoDjxZ6NbQWPrRqHTv4I3ioaDv5gA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZSVD8NtupsbbMdy/9KJr2HmvxWtzvc4BdYB8H52tyoVui5zrYxgMLQeJ0K7IURc69
	 /zsGNjWqHzNUJYHWQuq/U0emEAKYZ3h7pC3T3KCEB/vmy0tNHIIuVcgFfLexDge67X
	 6mEBNCw4u3YEKnfnPd6g1WGJTACTdVU0PwKc7DN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1151/1815] arm64: hibernate: Restore DAIF state on error
Date: Sat, 12 Sep 2026 08:48:21 +0200
Message-ID: <20260912065716.034123569@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 1eb1c1074c5b0..7bf1174277772 100644
--- a/arch/arm64/kernel/hibernate.c
+++ b/arch/arm64/kernel/hibernate.c
@@ -348,8 +348,10 @@ int swsusp_arch_suspend(void)
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



