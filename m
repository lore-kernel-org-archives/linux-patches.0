Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8321826B0A5;
	Thu, 13 Feb 2025 15:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459901; cv=none; b=ui8/REcnQL0BE8pEfkdGehMRRil5IDxasRcnQyOZ99Uajn8rzVv5/CLzHG28gW4QhAvL3sGE3bR1yWMr0jKlLmIyGOkmrRLgHZc5EYkNFRtlkaf1t9u5vCZhPFD4GyO5HBMEKThivjenwl2FoaNwGMbpX3YrXPUsj7LK1+fngQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459901; c=relaxed/simple;
	bh=6M5kfZ8U+gLJFteUYU61T7tmBEVAxmvTUXvsW8O4/V4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gu92+uA/PLh0M/0hKft8xNbWpxXpJ8/ZYNRZsPOc+yLlHJS6hY99eMcaXa8Q0Nm02LFBxpmdHwMMnGvA4RH5rSJtfApZjevfGaPJtBKEJYEib7UlhvgoLxbJPGn/VM9RkTQPdGHemw42InHrhOYpq/dUQG/p40PPRKOScMzFtug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o0ZqRzOs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o0ZqRzOs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0897EC4CEE4;
	Thu, 13 Feb 2025 15:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459901;
	bh=6M5kfZ8U+gLJFteUYU61T7tmBEVAxmvTUXvsW8O4/V4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o0ZqRzOsLCMxZbwbAq27o+kFdDW77kst88nlfKUV9Rw9QB/ch30cUYk2NWMfenANz
	 Wtj76wy+OVBRpY1oQ6UQ3wxC8+b/ZGQp1BetNAg4vUKNUwiczche0/qC3gVF6EoPNN
	 HLSGJ6Ia6nOpruDfgZRp8S1KKRakNMMhCDAdzi5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.13 397/443] selftests: mptcp: connect: -f: no reconnect
Date: Thu, 13 Feb 2025 15:29:22 +0100
Message-ID: <20250213142455.927764513@linuxfoundation.org>
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 5368a67307b3b2c347dc8965ac55b888be665934 upstream.

The '-f' parameter is there to force the kernel to emit MPTCP FASTCLOSE
by closing the connection with unread bytes in the receive queue.

The xdisconnect() helper was used to stop the connection, but it does
more than that: it will shut it down, then wait before reconnecting to
the same address. This causes the mptcp_join's "fastclose test" to fail
all the time.

This failure is due to a recent change, with commit 218cc166321f
("selftests: mptcp: avoid spurious errors on disconnect"), but that went
unnoticed because the test is currently ignored. The recent modification
only shown an existing issue: xdisconnect() doesn't need to be used
here, only the shutdown() part is needed.

Fixes: 6bf41020b72b ("selftests: mptcp: update and extend fastclose test-cases")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250204-net-mptcp-sft-conn-f-v1-1-6b470c72fffa@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_connect.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_connect.c
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.c
@@ -1302,7 +1302,7 @@ again:
 		return ret;
 
 	if (cfg_truncate > 0) {
-		xdisconnect(fd);
+		shutdown(fd, SHUT_WR);
 	} else if (--cfg_repeat > 0) {
 		xdisconnect(fd);
 


