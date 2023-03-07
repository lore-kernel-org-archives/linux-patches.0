Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58FC7BA4F
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 19:04:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B448DC433B0;
	Tue,  7 Mar 2023 19:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678215882;
	bh=WdzyvuOz1PQVuQqGVUeX2cO93sXIDXw6MWmUv1vHO4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NMKyhe3xMoQaMr1XcIsos6oqBoSi850Ah0OGFBBiF1gpz8NDRIagLcinPhkaRVCpK
	 F8FQx+uI2y77fxjEMeqysycOvUy+GB2yCNbdn9aBml/D48awKCUlx40RVCQBccqB8N
	 cKQKzyVRIK/5+BB2p0g9o/ER9aMP3bOelmZ5msLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 397/567] time/debug: Fix memory leak with using debugfs_lookup()
Date: Tue,  7 Mar 2023 18:02:13 +0100
Message-Id: <20230307165923.059006653@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 5b268d8abaec6cbd4bd70d062e769098d96670aa ]

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To make things simpler, just
call debugfs_lookup_and_remove() instead which handles all of the logic at
once.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20230202151214.2306822-1-gregkh@linuxfoundation.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/test_udelay.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/test_udelay.c b/kernel/time/test_udelay.c
index 13b11eb62685e..20d5df631570e 100644
--- a/kernel/time/test_udelay.c
+++ b/kernel/time/test_udelay.c
@@ -149,7 +149,7 @@ module_init(udelay_test_init);
 static void __exit udelay_test_exit(void)
 {
 	mutex_lock(&udelay_test_lock);
-	debugfs_remove(debugfs_lookup(DEBUGFS_FILENAME, NULL));
+	debugfs_lookup_and_remove(DEBUGFS_FILENAME, NULL);
 	mutex_unlock(&udelay_test_lock);
 }
 
-- 
2.39.2



