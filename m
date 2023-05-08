Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F41168C5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:51:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8832C433D2;
	Mon,  8 May 2023 10:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543091;
	bh=451OV9ifogt7wDFt9BzvP2BHmSTuTByjJzj3wIUr2Sk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PJGpD2gpGlP4F9r3wm9ANd5IMQMKsOlK4NXPVbcAByVpuelw/5uh9mU7+EnPjopy/
	 Y3UL/8lxuc9WIvDQdY+SLZg3j5aKN2BiogVs4q3jlUC3Pmz0ikMRBEeEyJLCnLksuU
	 OrrnRcmxY3l3ibYafiuyTK1hfiIe58eoiAzkrMqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 6.2 647/663] dm integrity: call kmem_cache_destroy() in dm_integrity_init() error path
Date: Mon,  8 May 2023 11:47:53 +0200
Message-Id: <20230508094451.061784684@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mike Snitzer <snitzer@kernel.org>

commit 6b79a428c02769f2a11f8ae76bf866226d134887 upstream.

Otherwise the journal_io_cache will leak if dm_register_target() fails.

Cc: stable@vger.kernel.org
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-integrity.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -4646,11 +4646,13 @@ static int __init dm_integrity_init(void
 	}
 
 	r = dm_register_target(&integrity_target);
-
-	if (r < 0)
+	if (r < 0) {
 		DMERR("register failed %d", r);
+		kmem_cache_destroy(journal_io_cache);
+		return r;
+	}
 
-	return r;
+	return 0;
 }
 
 static void __exit dm_integrity_exit(void)


