Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A0032031A
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vPUIvzqy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3DD1C433C8;
	Tue, 31 Oct 2023 17:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698771902;
	bh=8n5xm8iNuIueYWIjab0fgGLfA5Vh/DT8EsYZnPMiePg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vPUIvzqyalVSUDacFuLetgocNfL/wTlzBBaq6upm1Yu87XlV+pXw19He4J9K1f778
	 vTgWBjMyyL0qnKKiabkoUIzel8WkO0/umx2FVnImB2zj2/RLeiL0hPdtNEA2dKsazH
	 wn8Y2nJdPoPvMWm/0HaqMn65kgeve0De9rFIj2W0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Khazhismel Kumykov <khazhy@google.com>,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 57/86] blk-throttle: check for overflow in calculate_bytes_allowed
Date: Tue, 31 Oct 2023 18:01:22 +0100
Message-ID: <20231031165920.350400001@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231031165918.608547597@linuxfoundation.org>
References: <20231031165918.608547597@linuxfoundation.org>
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

From: Khazhismel Kumykov <khazhy@chromium.org>

commit 2dd710d476f2f1f6eaca884f625f69ef4389ed40 upstream.

Inexact, we may reject some not-overflowing values incorrectly, but
they'll be on the order of exabytes allowed anyways.

This fixes divide error crash on x86 if bps_limit is not configured or
is set too high in the rare case that jiffy_elapsed is greater than HZ.

Fixes: e8368b57c006 ("blk-throttle: use calculate_io/bytes_allowed() for throtl_trim_slice()")
Fixes: 8d6bbaada2e0 ("blk-throttle: prevent overflow while calculating wait time")
Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/20231020223617.2739774-1-khazhy@google.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-throttle.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -723,6 +723,12 @@ static unsigned int calculate_io_allowed
 
 static u64 calculate_bytes_allowed(u64 bps_limit, unsigned long jiffy_elapsed)
 {
+	/*
+	 * Can result be wider than 64 bits?
+	 * We check against 62, not 64, due to ilog2 truncation.
+	 */
+	if (ilog2(bps_limit) + ilog2(jiffy_elapsed) - ilog2(HZ) > 62)
+		return U64_MAX;
 	return mul_u64_u64_div_u64(bps_limit, (u64)jiffy_elapsed, (u64)HZ);
 }
 


