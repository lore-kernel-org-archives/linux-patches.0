Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F427E595;
	Tue, 23 Jan 2024 02:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975779; cv=none; b=Khnx8J8gQeGZ660mh+Y7AMvBWaDaRclaz2YaA9/jgmLsm1tCe1orlLqcak9UeYU0EtjiQKDwhRkVKqRYatOvvHhYOaCQtWTWpnwCDLq8+M82v516qJxZ9Zygxq6tnY7JDmMKCkvuoGkTEEqN3dpqap0JJyi8jVevQg605rTJdZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975779; c=relaxed/simple;
	bh=8QH6o8OweQlRdvpkEUaKek3+h8AbVSgcg0mZGt7jHa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W0kGHn8BySeqgIlXqgAzHeJDkp5eMohjr0oNMUSF+b1/Jv/9Owd6n09e16WttgMe29RCctMlqRQ3rFsX560rl5E7DtXK7bDh9irYl+PLp9iES9xDa7eRS/HBN4WN2PN0ygQM2MyPl/hs1AIZ0yIM8wW5dT07WHjCFU0XCQy+N58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b5o9bALM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b5o9bALM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB268C43390;
	Tue, 23 Jan 2024 02:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975778;
	bh=8QH6o8OweQlRdvpkEUaKek3+h8AbVSgcg0mZGt7jHa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b5o9bALMmuJRmJXxuwXYYTsPajG9TvcWNqk9n1MfFKCE4K8vm02f8y0qOIRfbnGlx
	 14vMLC4YcxraQSROI5lEQad+96uZpouxLm9spVJeKl5AUxDV7X5EMm41MJqnL5buDM
	 O/0c3p+CaFL+cWNv8lwvv849tm6gdhYKU47O/F7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aditi Ghag <aditi.ghag@isovalent.com>,
	Yonghong Song <yonghong.song@linux.dev>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 544/583] bpf: iter_udp: Retry with a larger batch size without going back to the previous bucket
Date: Mon, 22 Jan 2024 15:59:55 -0800
Message-ID: <20240122235828.777066961@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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
index bd12a7658213..a4857c85a020 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -3192,7 +3192,6 @@ static struct sock *bpf_iter_udp_batch(struct seq_file *seq)
 		/* After allocating a larger batch, retry one more time to grab
 		 * the whole bucket.
 		 */
-		state->bucket--;
 		goto again;
 	}
 done:
-- 
2.43.0



