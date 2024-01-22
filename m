Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113DE5C5F0;
	Tue, 23 Jan 2024 00:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970160; cv=none; b=eZaS3ceB12Wtisz8zu8M3AsM/bUTUUMcBDMPayGke4i5SthaIjQepm2dqZABWwQ377ZBI0mZdnZqOhCH20KgWmMNR6BL6SOjsmw0+kZT7rYiMeOMpFj1FwN/mtlk8O8jdMoYy/QyHY7FCk2slTSJklWcHAWaWoNjAcP7g7cWQwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970160; c=relaxed/simple;
	bh=nm/NWsphtB32NWl7m6jJhE2I/lpUdQ4fuTtXnQkNG2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UTZC2MPqQ2VeJsHp7s+RAZr9zvOecTJbS1dkFHZFHzDMKvDu53s3230AdkJxF5+T6i65ff0R9lgFl+3T0Eu5ftmyIUBf2eeEDmyGTU3FptHoC4eISjayXqUr5OPv52BqbHS/lCzCChkbCuoLyAfLVyiCV/SvsaTa0bsak/0JYmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kJhAwYc/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kJhAwYc/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E25DC43394;
	Tue, 23 Jan 2024 00:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970159;
	bh=nm/NWsphtB32NWl7m6jJhE2I/lpUdQ4fuTtXnQkNG2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kJhAwYc/K0Tn8XIW3dQKusGsxB2zof+tsWv2ZkRRorwZPAYbJvL4kVJXuJU8/gqwq
	 tVSr3ac05iBaQ8YmZvzTViyQ8t45+g5/vq/FKTwbst2g4xKdZqran/JRxns+ISUpOw
	 nDErVRNswSof3+zqr97R4ZpFU7rxPf6zWeKcb+3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aditi Ghag <aditi.ghag@isovalent.com>,
	Yonghong Song <yonghong.song@linux.dev>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 602/641] bpf: iter_udp: Retry with a larger batch size without going back to the previous bucket
Date: Mon, 22 Jan 2024 15:58:26 -0800
Message-ID: <20240122235837.063695825@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin KaFai Lau <martin.lau@kernel.org>

[ Upstream commit 19ca0823f6eaad01d18f664a00550abe912c034c ]

The current logic is to use a default size 16 to batch the whole bucket.
If it is too small, it will retry with a larger batch size.

The current code accidentally does a state->bucket-- before retrying.
This goes back to retry with the previous bucket which has already
been done. This patch fixed it.

It is hard to create a selftest. I added a WARN_ON(state->bucket < 0),
forced a particular port to be hashed to the first bucket,
created >16 sockets, and observed the for-loop went back
to the "-1" bucket.

Cc: Aditi Ghag <aditi.ghag@isovalent.com>
Fixes: c96dac8d369f ("bpf: udp: Implement batching for sockets iterator")
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Reviewed-by: Aditi Ghag <aditi.ghag@isovalent.com>
Link: https://lore.kernel.org/r/20240112190530.3751661-2-martin.lau@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/udp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 5f742d0b9e07..79050d83e736 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -3213,7 +3213,6 @@ static struct sock *bpf_iter_udp_batch(struct seq_file *seq)
 		/* After allocating a larger batch, retry one more time to grab
 		 * the whole bucket.
 		 */
-		state->bucket--;
 		goto again;
 	}
 done:
-- 
2.43.0



