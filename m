Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C37D18F5B
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:26:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48449C433C7;
	Sun, 16 Jul 2023 20:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539181;
	bh=p8Jd3e4FFowg8tlM84/UtAS1uuLCDN5sL4XtCbVdwj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ew0R7zVjU+JbuO8Dh3lK2DfaehXPduabHeEtRCmWTF//EJduKkwahYXBQraUjuyud
	 rF0yWX366IqJ4050u7pSh4PWc3Xvl3M7uF+IvlktpkeJP/lcxC34o7LcywLxPsoUNl
	 pcIKNofphqIggiISmPRbiyZ41CX6m8yfDqgfL+I0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 716/800] lib: dhry: fix sleeping allocations inside non-preemptable section
Date: Sun, 16 Jul 2023 21:49:29 +0200
Message-ID: <20230716195005.749034577@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 8ba388c06bc8056935ec1814b2689bfb42f3b89a ]

The Smatch static checker reports the following warnings:

    lib/dhry_run.c:38 dhry_benchmark() warn: sleeping in atomic context
    lib/dhry_run.c:43 dhry_benchmark() warn: sleeping in atomic context

Indeed, dhry() does sleeping allocations inside the non-preemptable
section delimited by get_cpu()/put_cpu().

Fix this by using atomic allocations instead.
Add error handling, as atomic these allocations may fail.

Link: https://lkml.kernel.org/r/bac6d517818a7cd8efe217c1ad649fffab9cc371.1688568764.git.geert+renesas@glider.be
Fixes: 13684e966d46283e ("lib: dhry: fix unstable smp_processor_id(_) usage")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/0469eb3a-02eb-4b41-b189-de20b931fa56@moroto.mountain
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/dhry_1.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/lib/dhry_1.c b/lib/dhry_1.c
index 83247106824cc..08edbbb19f573 100644
--- a/lib/dhry_1.c
+++ b/lib/dhry_1.c
@@ -139,8 +139,15 @@ int dhry(int n)
 
 	/* Initializations */
 
-	Next_Ptr_Glob = (Rec_Pointer)kzalloc(sizeof(Rec_Type), GFP_KERNEL);
-	Ptr_Glob = (Rec_Pointer)kzalloc(sizeof(Rec_Type), GFP_KERNEL);
+	Next_Ptr_Glob = (Rec_Pointer)kzalloc(sizeof(Rec_Type), GFP_ATOMIC);
+	if (!Next_Ptr_Glob)
+		return -ENOMEM;
+
+	Ptr_Glob = (Rec_Pointer)kzalloc(sizeof(Rec_Type), GFP_ATOMIC);
+	if (!Ptr_Glob) {
+		kfree(Next_Ptr_Glob);
+		return -ENOMEM;
+	}
 
 	Ptr_Glob->Ptr_Comp = Next_Ptr_Glob;
 	Ptr_Glob->Discr = Ident_1;
-- 
2.39.2



