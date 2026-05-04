Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B51F3CEB89;
	Mon,  4 May 2026 14:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903341; cv=none; b=hxlrXa6E3a2aei/U4D2s/mtIk7x9iPIWwn3LJ/cBJHHuwdFlcm8MJGm5FfugkHaILAzzQeTncXzb6caQ4sLUt9Z81vfn8hwcyyCU5Mo7yyDnBpg8x/Gewt2VC0hN204DxRE4AN03aRVYLHADEfvbk1j3cZKaRNHFoZMHgrSqkfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903341; c=relaxed/simple;
	bh=hTNcjmVuj6RGduSeXtYAfPKyZwl+T4UyfQwiedrEqcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ONLgAl6Mu6JJco4sUMMoMCrQXniea7h34+tAl3QXnsO7QTlRNfXXj8HzUrpBJX7XEXgpcZBf9M85NdInPrTDVSbVNVJVoaBOTFVPeH2796QJpE7ok0/UmfVBM4xTwLxXhx70w91PNW7KVJ+weNsl4gSmmTAWstHyZX3zvwvdRTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Zh+u6bJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Zh+u6bJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32A40C2BCB8;
	Mon,  4 May 2026 14:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903341;
	bh=hTNcjmVuj6RGduSeXtYAfPKyZwl+T4UyfQwiedrEqcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Zh+u6bJAn6xj/oMcJ/GAjm3Azn/WR3OKZOTJDv+77PSrtN6isv+aN21p8TXjmKzJ
	 GXVvvexn4MkZL1SZE0xmEChmkJD0wVh6G5MzL+fURq/20NhYgZ7tlNtGP6eJpWjXO0
	 ZwRPoqxdQheW704fSWO3XMfrGbGv5gVdWUqv3LTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.0 196/307] mm/damon/core: use time_in_range_open() for damos quota window start
Date: Mon,  4 May 2026 15:51:21 +0200
Message-ID: <20260504135150.257038701@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit 049a57421dd67a28c45ae7e92c36df758033e5fa upstream.

damos_adjust_quota() uses time_after_eq() to show if it is time to start a
new quota charge window, comparing the current jiffies and the scheduled
next charge window start time.  If it is, the next charge window start
time is updated and the new charge window starts.

The time check and next window start time update is skipped while the
scheme is deactivated by the watermarks.  Let's suppose the deactivation
is kept more than LONG_MAX jiffies (assuming CONFIG_HZ of 250, more than
99 days in 32 bit systems and more than one billion years in 64 bit
systems), resulting in having the jiffies larger than the next charge
window start time + LONG_MAX.  Then, the time_after_eq() call can return
false until another LONG_MAX jiffies are passed.

This means the scheme can continue working after being reactivated by the
watermarks.  But, soon, the quota will be exceeded and the scheme will
again effectively stop working until the next charge window starts.
Because the current charge window is extended to up to LONG_MAX jiffies,
however, it will look like it stopped unexpectedly and indefinitely, from
the user's perspective.

Fix this by using !time_in_range_open() instead.

The issue was discovered [1] by sashiko.

Link: https://lore.kernel.org/20260329152306.45796-1-sj@kernel.org
Link: https://lore.kernel.org/20260324040722.57944-1-sj@kernel.org [1]
Fixes: ee801b7dd782 ("mm/damon/schemes: activate schemes based on a watermarks mechanism")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 5.16.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2291,7 +2291,8 @@ static void damos_adjust_quota(struct da
 	}
 
 	/* New charge window starts */
-	if (time_after_eq(jiffies, quota->charged_from +
+	if (!time_in_range_open(jiffies, quota->charged_from,
+				quota->charged_from +
 				msecs_to_jiffies(quota->reset_interval))) {
 		if (quota->esz && quota->charged_sz >= quota->esz)
 			s->stat.qt_exceeds++;


