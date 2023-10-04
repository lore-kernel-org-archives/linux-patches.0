Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2001D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hjUJStY5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F04DC433C7;
	Wed,  4 Oct 2023 18:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443443;
	bh=H1unXUn0bkpMpUIdaGpz8I7cGoNkuoAAwuCahVcbMy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hjUJStY5iwtLhffgQuimqpoqCPR5OzAnnh5XYt45LavegUn0LtOKPaIdDhV6Wp7fd
	 PIefdaPgIWzKB8unFjQkZMnjAjQxXW7vOoH/pE80oYwL/F0zs0XUTNlwIMbZFmhohW
	 6dLat9WGWRu7J62eAlb795ouw2zScLosvbRP3pGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Chris Zankel <chris@zankel.net>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 130/259] xtensa: umulsidi3: fix conditional expression
Date: Wed,  4 Oct 2023 19:55:03 +0200
Message-ID: <20231004175223.341673751@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 9aecda97ec3deecbfa7670877c8ddfd3d0fc87c4 ]

Even when a variant has one or more of these defines set to 1, the
multiplier code paths are not used. Change the expression so that the
correct code paths are used.

arch/xtensa/lib/umulsidi3.S:44:38: warning: "XCHAL_NO_MUL" is not defined, evaluates to 0 [-Wundef]
   44 | #if defined(__XTENSA_CALL0_ABI__) && XCHAL_NO_MUL
arch/xtensa/lib/umulsidi3.S:145:38: warning: "XCHAL_NO_MUL" is not defined, evaluates to 0 [-Wundef]
  145 | #if defined(__XTENSA_CALL0_ABI__) && XCHAL_NO_MUL
arch/xtensa/lib/umulsidi3.S:159:5: warning: "XCHAL_NO_MUL" is not defined, evaluates to 0 [-Wundef]
  159 | #if XCHAL_NO_MUL

Fixes: 8939c58d68f9 ("xtensa: add __umulsidi3 helper")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Message-Id: <20230920052139.10570-16-rdunlap@infradead.org>
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/xtensa/lib/umulsidi3.S | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/xtensa/lib/umulsidi3.S b/arch/xtensa/lib/umulsidi3.S
index 1360816479427..4d9ba2387de0f 100644
--- a/arch/xtensa/lib/umulsidi3.S
+++ b/arch/xtensa/lib/umulsidi3.S
@@ -3,7 +3,9 @@
 #include <asm/asmmacro.h>
 #include <asm/core.h>
 
-#if !XCHAL_HAVE_MUL16 && !XCHAL_HAVE_MUL32 && !XCHAL_HAVE_MAC16
+#if XCHAL_HAVE_MUL16 || XCHAL_HAVE_MUL32 || XCHAL_HAVE_MAC16
+#define XCHAL_NO_MUL 0
+#else
 #define XCHAL_NO_MUL 1
 #endif
 
-- 
2.40.1



