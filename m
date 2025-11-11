Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A84F73090CB;
	Tue, 11 Nov 2025 01:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823320; cv=none; b=pWgb5DKrLqMaW6YJtm2PylT6yjwFHTppPCHghPGe2kbYUyu58JPE9CvRbsKYUYkHGiLERBLpZF98pyJxUWVTq2Dkr/uzjpbSaIuIqCJDRqoGrnfrmw0vcV3oqKnBGcvxzyDpSPvwfsOgAJ8/hsGCxdUUpXmxDhBaDAKZI7sIzRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823320; c=relaxed/simple;
	bh=ui+JZ0eQLLbLvLDByRJGqL0ng5QbGX+IEaJdWc03lKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L03u7KaEL6k0Hf9OGtWv2SteNli9Xq9ZOMujj1/WjS+tB8mufPTm4NOeAeV21sGFXAyfRpxIEq5hbYRpabZoq6LN6Cfl0ikFstmTZhjX0LbKWWsAotE+lJkNI11VfV1aRTi2hE9AOfwM1jFuovI6DMejKPntuZkE1ir4SfxlWfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ga4mQbEc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ga4mQbEc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A631C4CEFB;
	Tue, 11 Nov 2025 01:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823320;
	bh=ui+JZ0eQLLbLvLDByRJGqL0ng5QbGX+IEaJdWc03lKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ga4mQbEcPJtXst51uy79kXe6jIrWR5cohONxLO4I1ayXKhEbrAEcnJkf528EZsmis
	 Igu7fXEc5HH9j2jmwGBlU9BlqKFGB53W9YvPnkPqoOK/n2p8V3vD+QQyYkEzQVgBoB
	 5lXVbpqfY/Rya+Vi5yiqRLaLHxIf4wqmaBRofTyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wake Liu <wakel@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 275/849] selftests/net: Ensure assert() triggers in psock_tpacket.c
Date: Tue, 11 Nov 2025 09:37:25 +0900
Message-ID: <20251111004543.075605548@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 0dd909e325d93..2938045c5cf97 100644
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



