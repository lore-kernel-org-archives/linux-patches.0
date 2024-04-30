Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D968512C462;
	Tue, 30 Apr 2024 11:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475107; cv=none; b=cnfNMQTgMubH1grkTDLPfcyWAv5dOy/xZ4jvU9vYJ2ejbQ0I73+HMUqYJrrAsscaULHbMLIJmb+7ABMjteXbARNDn79dvBYQjW4s2yRa9wvOB2a3afqNPJGpxEWohZzOBX8NEy2M0NUuy5osMjvt4Lm3grUjVwPAx/mXxeq/Pfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475107; c=relaxed/simple;
	bh=JlwYfqTSsq9qajWu8mrfCgrXvdBpsARa3t1Jr8SnmXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tA0PRGOnBjT6wkXRZSpU/STTZat1bSLn95nRr+3wV7R8dBwmeEU4J/NBBm3TEwZroRmdTPC+yrYoIYO++IX2F+8SKDrdWeEqG2BorTlqcEdIIiTNhxtsOw7Y+tWCX1fZ+bqA39BE4WPruQG9w9d5OviyLh0jQxAAMMMALt+AtH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p21Bd2nR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p21Bd2nR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 601BFC2BBFC;
	Tue, 30 Apr 2024 11:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475107;
	bh=JlwYfqTSsq9qajWu8mrfCgrXvdBpsARa3t1Jr8SnmXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p21Bd2nR2dh9wB9kZof2puBqoYEFPcJRnt3GKBFXpwcIx1IOZXzZ+/o4ucdNwGPw+
	 UMj6ADaElERUTtZMIBkT9S5Asng0bGNvD2CpG/MstCw3ekAL22g5UXBqa4VI7oJLX2
	 YwNbPbAeXl1jlytC5SUnuwtwKo8yI80LzjPRHDnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=D0=9C=D0=B8=D1=85=D0=B0=D0=B8=D0=BB=20=D0=9D=D0=BE=D0=B2=D0=BE=D1=81=D0=B5=D0=BB=D0=BE=D0=B2?= <m.novosyolov@rosalinux.ru>,
	=?UTF-8?q?=D0=98=D0=BB=D1=8C=D1=84=D0=B0=D1=82=20=D0=93=D0=B0=D0=BF=D1=82=D1=80=D0=B0=D1=85=D0=BC=D0=B0=D0=BD=D0=BE=D0=B2?= <i.gaptrakhmanov@rosalinux.ru>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Rik van Riel <riel@surriel.com>,
	Mel Gorman <mgorman@techsingularity.net>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 135/138] bounds: Use the right number of bits for power-of-two CONFIG_NR_CPUS
Date: Tue, 30 Apr 2024 12:40:20 +0200
Message-ID: <20240430103053.375934213@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

commit 5af385f5f4cddf908f663974847a4083b2ff2c79 upstream.

bits_per() rounds up to the next power of two when passed a power of
two.  This causes crashes on some machines and configurations.

Reported-by: Михаил Новоселов <m.novosyolov@rosalinux.ru>
Tested-by: Ильфат Гаптрахманов <i.gaptrakhmanov@rosalinux.ru>
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/3347
Link: https://lore.kernel.org/all/1c978cf1-2934-4e66-e4b3-e81b04cb3571@rosalinux.ru/
Fixes: f2d5dcb48f7b (bounds: support non-power-of-two CONFIG_NR_CPUS)
Cc:  <stable@vger.kernel.org>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bounds.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/bounds.c
+++ b/kernel/bounds.c
@@ -19,7 +19,7 @@ int main(void)
 	DEFINE(NR_PAGEFLAGS, __NR_PAGEFLAGS);
 	DEFINE(MAX_NR_ZONES, __MAX_NR_ZONES);
 #ifdef CONFIG_SMP
-	DEFINE(NR_CPUS_BITS, bits_per(CONFIG_NR_CPUS));
+	DEFINE(NR_CPUS_BITS, order_base_2(CONFIG_NR_CPUS));
 #endif
 	DEFINE(SPINLOCK_SIZE, sizeof(spinlock_t));
 	/* End of constants */


