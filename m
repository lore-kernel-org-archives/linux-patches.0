Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C32C2A1D1;
	Thu, 13 Feb 2025 15:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458957; cv=none; b=fSJmtcwEgFj1eDGzXVTkuFjURAXzUylEjIq6rEJSw03WNnFSEYom/SEeAlKaQWIzQs1gTWodEE3vw372FIw0Y3Gbjkoh7i05CviBA0wN35zx8fnvSYX4xVYTKBUmFIAbStTKrXjiGaRwVppVD9BUO+ykUd+GKv1r+WpIhwC3ebA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458957; c=relaxed/simple;
	bh=9AGGOlJhwNgIy/z7NAe/S5bkYVhPJEZCWvssKg/OKL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oHK0EPHNcU2kXvg0o2bDkCvPFS+Jn5EXkMW1H7vQujaaPO9xyy+PwY6kpMptBUi2rNkhjoDHttBfa5do+1zwk5O7cRI3/QtHYxfloWJg9nx6QqRV3UT+Eu+R1QIE+3mpdIgmeZQNMTSCHwHovch2OId42aAVKDFFWsmaqQ7Lqd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vvLhTk92; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vvLhTk92"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D1D5C4CED1;
	Thu, 13 Feb 2025 15:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458957;
	bh=9AGGOlJhwNgIy/z7NAe/S5bkYVhPJEZCWvssKg/OKL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vvLhTk92a333HGPqT+Ilubk9ghtWGZoM8Ntf+AcJAd++SMS5LgLGZw/ZrmgPc2GjG
	 yDYh98mni2mqtOXLxcVpljs6ksPTFYP9SC+cD4JgOXxPenw6CIfZZbjKMXB2wCBmJk
	 MSBUcwfXQnV0RmSfayPMaapL9htY8gXPa9piylBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <jdamato@fastly.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 126/443] selftests: drv-net: rss_ctx: add missing cleanup in queue reconfigure
Date: Thu, 13 Feb 2025 15:24:51 +0100
Message-ID: <20250213142445.472268970@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit de379dfd9ada2995699052f4a1ecebe5d8f8d70f ]

Commit under Fixes adds ntuple rules but never deletes them.

Fixes: 29a4bc1fe961 ("selftest: extend test_rss_context_queue_reconfigure for action addition")
Reviewed-by: Joe Damato <jdamato@fastly.com>
Link: https://patch.msgid.link/20250201013040.725123-4-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/drivers/net/hw/rss_ctx.py | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/hw/rss_ctx.py b/tools/testing/selftests/drivers/net/hw/rss_ctx.py
index ca8a7edff3dda..27e24e20749ff 100755
--- a/tools/testing/selftests/drivers/net/hw/rss_ctx.py
+++ b/tools/testing/selftests/drivers/net/hw/rss_ctx.py
@@ -252,6 +252,7 @@ def test_rss_queue_reconfigure(cfg, main_ctx=True):
         try:
             # this targets queue 4, which doesn't exist
             ntuple2 = ethtool_create(cfg, "-N", flow)
+            defer(ethtool, f"-N {cfg.ifname} delete {ntuple2}")
         except CmdExitFailure:
             pass
         else:
@@ -260,6 +261,7 @@ def test_rss_queue_reconfigure(cfg, main_ctx=True):
         ethtool(f"-X {cfg.ifname} {ctx_ref} weight 1 0 1 0")
         # ntuple rule therefore targets queues 1 and 3
         ntuple2 = ethtool_create(cfg, "-N", flow)
+        defer(ethtool, f"-N {cfg.ifname} delete {ntuple2}")
         # should replace existing filter
         ksft_eq(ntuple, ntuple2)
         _send_traffic_check(cfg, port, ctx_ref, { 'target': (1, 3),
-- 
2.39.5



