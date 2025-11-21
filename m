Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C0929B78F;
	Fri, 21 Nov 2025 13:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732453; cv=none; b=W2YrNCvvNSvIbtQRgU+iOltXa3CJTlemN2CZ5mtZlXtz3RN3Is1MdBnyTfsZeZYzBPP/4RccIelPb2FtihG54F53OLe0dbSJb1052FD9smoEA8HDjQGlVxIu385gcR0cuxrsCd3mMMYY0bA7rLMzLek/eFxolKilEsiKnv76Yak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732453; c=relaxed/simple;
	bh=pmAX2kAwrRc7FbPxfoSN0ZCR3dq/YbDPZ3MLb36AVEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d/g4yxUTZlu1BxK/Fu6yqqorLSig5ZAkV+xRFgPtoSwhrxSUCfwDiLv0DkWpuYZP0IcZoqd8FUqfCdwwXOCm9nwBLR+nG//jaGsxLGEi/7+y+LF9PNzy6q2EI88Gr8TUfihEOIoImacFiHOP847hbO0hOthBFMx4+Mmi2+nkGpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iGK1cJRa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iGK1cJRa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEEF9C4CEF1;
	Fri, 21 Nov 2025 13:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732453;
	bh=pmAX2kAwrRc7FbPxfoSN0ZCR3dq/YbDPZ3MLb36AVEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iGK1cJRaKP4k/5yAw1yMsSfekmGgTQNF1Qz0EYcfLrrt0Ax3DGmFesq8fwU1nMHOA
	 7QVAUIv6vuhgXGY4pZic2Fws8ijylPU2pPDVCVAWlMsDXkyX1xF1kpJ6VODdBf/QaO
	 CvfYEIN3Tu9KMwjoB4mwDMbLz+8iVz81jAUXxpZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wake Liu <wakel@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 125/529] selftests/net: Ensure assert() triggers in psock_tpacket.c
Date: Fri, 21 Nov 2025 14:07:04 +0100
Message-ID: <20251121130235.469296304@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



