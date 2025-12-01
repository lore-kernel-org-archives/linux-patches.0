Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8122561AB;
	Mon,  1 Dec 2025 11:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588540; cv=none; b=pTRCz6L7fZVqQmNlS9xcCmOIh8KmgzCRIKf2gogV1HW4m+N7XdRMGBgwvcs8dWLyM5VFoOmAhq4xY5aMU4rbN81qglYnrLt2SQKq5LYj2pi8jHSkHpje2pcOAmpntFDxJDjrEGdUx/yGdgfx9upg2qbBfdM28X4f9mnGDW7vzcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588540; c=relaxed/simple;
	bh=biyyzbUhZkbkS3F1uNkveiQ2PXyrUOkWtNmbkhBcqYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lw7dyAVUAkiD2tqfBCztN4oidyQPzt6XltMVOHsmyQbcmMf7cCz88gFRyILhml9rrNHBiqHWycaHvngKobVY0FDK2+8O5mEP1zXIzvMI/OopB585eMFuR7n9nbUAz3Tq474JCKRqwTITuXZXg1DfJ/Q3i4Ii4m/PX750+YD0zOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l2mVIf2v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l2mVIf2v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40FAAC4CEF1;
	Mon,  1 Dec 2025 11:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588540;
	bh=biyyzbUhZkbkS3F1uNkveiQ2PXyrUOkWtNmbkhBcqYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l2mVIf2vOYjrf8xusiM3GFivwn+90Z2K4kQcJkyxDRj90Ar+QmnCvTMHL6NLJoIfA
	 6AjelyL9Z7l2ph3fNNzYAvNKyeAMTwPn5dX4PaAFv0xrhk74fgRDVt5gUDheZDieXp
	 suMoXEKALQUX/H/Q/ukkQZf+xO+k4a1JirNvl5YM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wake Liu <wakel@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 051/187] selftests/net: Ensure assert() triggers in psock_tpacket.c
Date: Mon,  1 Dec 2025 12:22:39 +0100
Message-ID: <20251201112243.089489519@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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



