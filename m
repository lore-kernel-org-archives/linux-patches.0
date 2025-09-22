Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5BE18C2C;
	Mon, 22 Sep 2025 19:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570452; cv=none; b=YmApfgD70IW/A906X3dhzRmQsGXmcxPQJQLGBt+1eau1Q1KmbvT23uzirPVF1+jM5qrEeRpdr9yuMbGIIP5ugo/241T7KdIFgwBE6T1H520BdtFjngAHca8vQqfH3RZWRm2D01Wo/FQWpoXeEerLGVuKSVBWJ6iOcWr63JAtH5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570452; c=relaxed/simple;
	bh=/9AD4ftddu+/BjLW5TN6m0HxyzC5gwitff3VsvHnaFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fBtaO/191pBEvybHg3Tg4TETVg1Kn0ZrxE5Evk5Ju8Dc+C1rfNkPOh3Dmrd3jLs8qBKduXxPgNwTkVXjoEQsSfOpCJeA9VRuKypd2OVxjL4eT6r8hHsY4g3GUPQmSTdrSuFnvupL3kt+cx24A7HFOxN1gLsBixNAtjpH9H/8dV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ipyPwnJC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ipyPwnJC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 165D1C4CEF0;
	Mon, 22 Sep 2025 19:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570452;
	bh=/9AD4ftddu+/BjLW5TN6m0HxyzC5gwitff3VsvHnaFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ipyPwnJCqmhMFC2EhRTtbL38RqQMXe5XS5t53/1ySAak3vTJPlare+3pF5xaOZYTf
	 CM0x0i1aGamiuBOkjA/OyuyEsjzOo7t60Nc9dvRZzosI/LPDtQ8vf+dmcpIv7IrRrX
	 v2CwK13MvE1YEle2L3FPHdb3kZ/3UMopFsRM6/a8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 145/149] samples/damon/prcl: fix boot time enable crash
Date: Mon, 22 Sep 2025 21:30:45 +0200
Message-ID: <20250922192416.522466581@linuxfoundation.org>
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

[ Upstream commit 2780505ec2b42c07853b34640bc63279ac2bb53b ]

If 'enable' parameter of the 'prcl' DAMON sample module is set at boot
time via the kernel command line, memory allocation is tried before the
slab is initialized.  As a result kernel NULL pointer dereference BUG can
happen.  Fix it by checking the initialization status.

Link: https://lkml.kernel.org/r/20250706193207.39810-3-sj@kernel.org
Fixes: 2aca254620a8 ("samples/damon: introduce a skeleton of a smaple DAMON module for proactive reclamation")
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: c62cff40481c ("samples/damon/mtier: avoid starting DAMON before initialization")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 samples/damon/prcl.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/samples/damon/prcl.c
+++ b/samples/damon/prcl.c
@@ -109,6 +109,8 @@ static void damon_sample_prcl_stop(void)
 		put_pid(target_pidp);
 }
 
+static bool init_called;
+
 static int damon_sample_prcl_enable_store(
 		const char *val, const struct kernel_param *kp)
 {
@@ -134,6 +136,14 @@ static int damon_sample_prcl_enable_stor
 
 static int __init damon_sample_prcl_init(void)
 {
+	int err = 0;
+
+	init_called = true;
+	if (enable) {
+		err = damon_sample_prcl_start();
+		if (err)
+			enable = false;
+	}
 	return 0;
 }
 


