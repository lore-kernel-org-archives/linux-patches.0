Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE6318C2C;
	Mon, 22 Sep 2025 19:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570457; cv=none; b=FmCXW3ZEvwyXyEptTIspS3Xss5wRMoN1a2Uow7uXud9ZB3dltY+9G5VYmzY4On74y424bsen7j76XWo7wZHihxsWlcOrz49fK4fWG+KxsAv/b14H6B0w1ZuZHyAt/Y/sLAbKuZ+3N+OCO6K++dXBFI92XLyEgPrC2Vlmxiz6eqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570457; c=relaxed/simple;
	bh=+QX/Ohg4X3XbiczEi0KCf28I83nRUZM/3NwqhtRLOzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kFAewHELOBJae2Co1JL17VkSm7v2llBUnqLi1iI1M2juYjZAWAfC4bNLtVmdILxOv6A8nScJSEDqpRTkS3/MEv2wjyokLvIkJP5H2XUgt74hLEJHap9f0W6y/6gqVBW1vqvRPrwPIsCjkVj3u9nzOhjCijPDAluy/3XaodzlosU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OwC3qFA2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OwC3qFA2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16B79C4CEF0;
	Mon, 22 Sep 2025 19:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570457;
	bh=+QX/Ohg4X3XbiczEi0KCf28I83nRUZM/3NwqhtRLOzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OwC3qFA2n0DiDF/qEA3UPcXaSA07rGZdR48AkWmoOJX428AZwmCNPImJgkDOMGW7a
	 VFen0AymkJrT9niaOjWBM7V2mIb+WTytkHicCciO3jl5gaZHNDj2jBwqXE0FYhA2Ue
	 q5wjrGK9CbOnCDtcylG4JZV3P5WCWFrSXrkkuCb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 147/149] samples/damon/mtier: avoid starting DAMON before initialization
Date: Mon, 22 Sep 2025 21:30:47 +0200
Message-ID: <20250922192416.573271427@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

[ Upstream commit c62cff40481c037307a13becbda795f7afdcfebd ]

Commit 964314344eab ("samples/damon/mtier: support boot time enable
setup") is somehow incompletely applying the origin patch [1].  It is
missing the part that avoids starting DAMON before module initialization.
Probably a mistake during a merge has happened.  Fix it by applying the
missed part again.

Link: https://lkml.kernel.org/r/20250909022238.2989-4-sj@kernel.org
Link: https://lore.kernel.org/20250706193207.39810-4-sj@kernel.org [1]
Fixes: 964314344eab ("samples/damon/mtier: support boot time enable setup")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 samples/damon/mtier.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/samples/damon/mtier.c
+++ b/samples/damon/mtier.c
@@ -166,6 +166,9 @@ static int damon_sample_mtier_enable_sto
 	if (enabled == is_enabled)
 		return 0;
 
+	if (!init_called)
+		return 0;
+
 	if (enabled) {
 		err = damon_sample_mtier_start();
 		if (err)


