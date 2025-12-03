Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 561B135BDC9;
	Wed,  3 Dec 2025 16:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779142; cv=none; b=H+tEmXddHtNA1ovnpPZqq1DmS2H0qGMduIZvrQrBDLt30tu/aw4QXC/DebTypZMB1UZNY8vbm0ncDGXhkLFiDWOfCMWNoKwqXPbYo+o8qgExRZjEY+TNipdR70aKMIF5qOMJne/XBqbvi1EEx14YwQL3ASuyOBZWsU9wgO+dzW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779142; c=relaxed/simple;
	bh=iJJZU81qQ4CwFbfwUv104bouXMAi4gWO4nysheOGMMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lNArIh2vY2K4jEIFtYD0YGaRE4AImRSNq2Oia8NWVozwiVucyX5uUpD8nm7HFPOpkM8p+bOY2+E+4pCBpZboIbqnOZUNNu6spV9SM77cFVLEr+AbT7y1W5TnG1p7I5ZvkfBAI6AD9SeVdNzy0ekus6m5wEAhrATgmYtIjuir3dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nqvr4BMP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nqvr4BMP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BABAAC4CEF5;
	Wed,  3 Dec 2025 16:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779142;
	bh=iJJZU81qQ4CwFbfwUv104bouXMAi4gWO4nysheOGMMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nqvr4BMP4H6z32J0YS76MRoC7r03894/bNDqqBIUtmT+xwBW4a37j1k4+J3uS+PN5
	 Nk0yH1djXSo+F56ojvaaPH+A0gofRsmA30pUlFHgbJjkAdikSv319NxLxdmYGfjTXV
	 1U7le4jwg/2S/wZRTVO4Zn40Kj5x3KII04UfFQIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wake Liu <wakel@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 140/568] selftests/net: Ensure assert() triggers in psock_tpacket.c
Date: Wed,  3 Dec 2025 16:22:22 +0100
Message-ID: <20251203152445.854870676@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wake Liu <wakel@google.com>

[ Upstream commit bc4c0a48bdad7f225740b8e750fdc1da6d85e1eb ]

The get_next_frame() function in psock_tpacket.c was missing a return
statement in its default switch case, leading to a compiler warning.

This was caused by a `bug_on(1)` call, which is defined as an
`assert()`, being compiled out because NDEBUG is defined during the
build.

Instead of adding a `return NULL;` which would silently hide the error
and could lead to crashes later, this change restores the original
author's intent. By adding `#undef NDEBUG` before including <assert.h>,
we ensure the assertion is active and will cause the test to abort if
this unreachable code is ever executed.

Signed-off-by: Wake Liu <wakel@google.com>
Link: https://patch.msgid.link/20250809062013.2407822-1-wakel@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/psock_tpacket.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/net/psock_tpacket.c b/tools/testing/selftests/net/psock_tpacket.c
index 93092d13b3c59..ca0d9a5a9e08c 100644
--- a/tools/testing/selftests/net/psock_tpacket.c
+++ b/tools/testing/selftests/net/psock_tpacket.c
@@ -22,6 +22,7 @@
  *   - TPACKET_V3: RX_RING
  */
 
+#undef NDEBUG
 #include <stdio.h>
 #include <stdlib.h>
 #include <sys/types.h>
-- 
2.51.0



