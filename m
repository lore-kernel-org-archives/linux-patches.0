Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8DC335BB3;
	Mon, 18 Aug 2025 13:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523656; cv=none; b=tIZjI+R8s/F0PT1Nb6IJU2J8MBttgkR5EEKGVSIVzxPBfJyhj+tuOeQUQ4SWZUJo4+cl9/QRarIVCD0seVke4UkkWMEbcaIEoZrVN8/2SAFa6E2sLW1F+9VROCnTxw7yk5GQEw8MmIpdHU8TsuKoI0xsKEHa/Tg7XCJZsAjibFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523656; c=relaxed/simple;
	bh=oMYmKYhEot1hVoTsu3SXV+GUSYj7Bxdd51HzZUcKIIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bg/6svR1GfjkebsnZA5Ip52UxnsrLZbkKFYOJ8tpmEI7onq0+hvhRWcTIOIkFE57vFhU+QgxCfD9BqaoHsmzXeQryyaGzPwY8hIhStFUkjUg5LmOd2NF4qdHWqbB6AaUM+S6ARDd91kHD6C7Yi2laqcQdnVApHB85/F4dP0NiQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d18NIQDx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d18NIQDx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88AF0C4CEEB;
	Mon, 18 Aug 2025 13:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523656;
	bh=oMYmKYhEot1hVoTsu3SXV+GUSYj7Bxdd51HzZUcKIIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d18NIQDxS4oMu99OWASjqyILKLLYLNX37svGjTWe6ZLFT/YWMM9JN+XLUHe5bevOn
	 mD+sbDWPsSGBjNruwjMFB62HhTiy5La//rGqV+BdmUrR1xzKV9BrPKzKop1HNUsBH0
	 MdGUaDEbVc2UBz6LSjtWZ41/L7XAcEZuroeG8HqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 239/515] s390/stp: Remove udelay from stp_sync_clock()
Date: Mon, 18 Aug 2025 14:43:45 +0200
Message-ID: <20250818124507.586277842@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

From: Sven Schnelle <svens@linux.ibm.com>

[ Upstream commit b367017cdac21781a74eff4e208d3d38e1f38d3f ]

When an stp sync check is handled on a system with multiple
cpus each cpu gets a machine check but only the first one
actually handles the sync operation. All other CPUs spin
waiting for the first one to finish with a short udelay().
But udelay can't be used here as the first CPU modifies tod_clock_base
before performing the sync op. During this timeframe
get_tod_clock_monotonic() might return a non-monotonic time.

The time spent waiting should be very short and udelay is a busy loop
anyways, therefore simply remove the udelay.

Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/time.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
index fed17d407a44..cb7ed55e24d2 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -580,7 +580,7 @@ static int stp_sync_clock(void *data)
 		atomic_dec(&sync->cpus);
 		/* Wait for in_sync to be set. */
 		while (READ_ONCE(sync->in_sync) == 0)
-			__udelay(1);
+			;
 	}
 	if (sync->in_sync != 1)
 		/* Didn't work. Clear per-cpu in sync bit again. */
-- 
2.39.5



