Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 768962E610D;
	Tue, 15 Jul 2025 13:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586949; cv=none; b=JXWyXdjWCIcuXfp+ksoE10kcA7gBesa8nr5//LuqilAdVq8Ep+E5rLYwFzI4uGK14M9JVxkdNkWo9V7NVpL9o7dDBzJVxa5B3oSE641SxFmdTfQARUb1OEO9/OK1/9jOOmp6n3T49Z2VGlykd7D6Swiqpm9NAG/4J8pToGjClO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586949; c=relaxed/simple;
	bh=AeaYmvRAb/EWQAJ3MS4zGZuwFH+kqG8mPdfKWpc0+hM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f8eyQS1dH+QNU0dxMONoYHnyL2cVVbDLcN7YCCeOt26ypX9mGVycRLEK5qL6xkZybAol5d2xTgfr1QGCsj3g3IeNeL7PJz1cQM3n32LV7xRYtxMT5AGUXX/+nb8vKEFug1CxAeMvngSFSWXyTsMF0ivv9FvpbRcwUuDTBjF4MjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fXoJWACB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fXoJWACB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04121C4CEE3;
	Tue, 15 Jul 2025 13:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586949;
	bh=AeaYmvRAb/EWQAJ3MS4zGZuwFH+kqG8mPdfKWpc0+hM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fXoJWACBvImb7kRRYAvNF0BFX9YHFiKsrk2OAhBuzNv8qDP6cwZKX2pbc3DXXq4DN
	 fNLgj5iEKq+gTjqtrrJwmvynWPyLON0oXJ5bek310NsjvruQ2scK74wmJ6gWGW1V37
	 uuOqZ97pICALjjzkthDRCfVSm2koyXjtmhW/CgKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Honggyu Kim <honggyu.kim@sk.com>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.15 109/192] mm/damon: fix divide by zero in damon_get_intervals_score()
Date: Tue, 15 Jul 2025 15:13:24 +0200
Message-ID: <20250715130819.264497662@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Honggyu Kim <honggyu.kim@sk.com>

commit bd225b9591442065beb876da72656f4a2d627d03 upstream.

The current implementation allows having zero size regions with no special
reasons, but damon_get_intervals_score() gets crashed by divide by zero
when the region size is zero.

  [   29.403950] Oops: divide error: 0000 [#1] SMP NOPTI

This patch fixes the bug, but does not disallow zero size regions to keep
the backward compatibility since disallowing zero size regions might be a
breaking change for some users.

In addition, the same crash can happen when intervals_goal.access_bp is
zero so this should be fixed in stable trees as well.

Link: https://lkml.kernel.org/r/20250702000205.1921-5-honggyu.kim@sk.com
Fixes: f04b0fedbe71 ("mm/damon/core: implement intervals auto-tuning")
Signed-off-by: Honggyu Kim <honggyu.kim@sk.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1427,6 +1427,7 @@ static unsigned long damon_get_intervals
 		}
 	}
 	target_access_events = max_access_events * goal_bp / 10000;
+	target_access_events = target_access_events ? : 1;
 	return access_events * 10000 / target_access_events;
 }
 


