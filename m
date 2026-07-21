Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883A8403B1E;
	Tue, 21 Jul 2026 17:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654371; cv=none; b=CzNM/pclpb6nqrtS+dbfB36tbINtisS6GtJP2E8kCYK/bcvxspL75abb1J1EkzJL/YUnqn2gH4UdQiVrStDbMxt9OdNBYOx0sFg7ekC2IAhaedpzQHAVW2KOYGrmxw9bPQyFkMtDt0+noAXSle2cyiadPfMJ5rPeza/3c+ENOBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654371; c=relaxed/simple;
	bh=8ORpfGzEYrnspoFJXpP8V+L/nE0Yn6ALJKCg5G0wzIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lsNGJ2L5DugqUQxn8JphHmi74CCMQIM9oIv+UatWE+Rj/m77E47nPxT7kHLJNnWggEfzmrzvL0QT8aq6LYn2JrRtA42HgR9VyLzB8NLXYVPcBxFXJnS3M7ozake0QHp/5bfNxUQWI2NI0okhatCQLNxk1z6Qh/XZxTs9q7rOZ2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CGbcDNKL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CGbcDNKL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC13A1F000E9;
	Tue, 21 Jul 2026 17:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654370;
	bh=GyWAjFfGm+HJJdLmHUDMgWCv5XM5ijCp7sdGPmCPW04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CGbcDNKLBMN8tu1mwREvDwljGGapTo7Dh0PwlkGrLK108G3qBu3TkMTwjr//HWlzn
	 /E+FCVEVB1fJyRyW7Av2m+N1Aqg+TygQabuurDU0d+gJSQuIIyvU7PsYwSzBzC6gTG
	 UrhprEcANxV0RJX+Jwk6WnEoLVDV2Db4vYT7rE5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.1 1679/2077] mm/damon/core: make charge_addr_from aware of end-address exclusivity
Date: Tue, 21 Jul 2026 17:22:32 +0200
Message-ID: <20260721152632.348403658@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit 5a2d162e22bf33eb89d53e802d0fc1ec422e19b6 upstream.

DAMON region end address is exclusive one, but charge_addr_from is
assigned assuming the end address is inclusive.  As a result, DAMOS action
to next up to min_region_sz memory can be skipped.  This is quite
negligible user impact.  But, the bug is a bug that can be very simply
fixed.  Fix the wrong assignment to respect the exclusiveness of the
address.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260428042942.118230-1-sj@kernel.org
Link: https://lore.kernel.org/20260428032324.115663-1-sj@kernel.org [1]
Fixes: 50585192bc2e ("mm/damon/schemes: skip already charged targets and regions")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 5.16.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2106,7 +2106,7 @@ static void damos_apply_scheme(struct da
 		if (damos_quota_is_set(quota) &&
 				quota->charged_sz >= quota->esz) {
 			quota->charge_target_from = t;
-			quota->charge_addr_from = r->ar.end + 1;
+			quota->charge_addr_from = r->ar.end;
 		}
 	}
 	if (s->action != DAMOS_STAT)


