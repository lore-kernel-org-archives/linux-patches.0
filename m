Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09117E56C
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:44:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66884C433D2;
	Mon, 15 May 2023 16:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169070;
	bh=QyMNYWwG1mxWYiW0Lp8gAnx0aH/Mcv/IVxT8csGWOmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AZ8DO5X3OZDsiMcdxyKwsJUFTFYpyO3iWsghctE3FU5vWGsT3g2R31XQnTedxTvgV
	 Jpkcqt3pqMDXkxyQVa2mWXuTLmaT5iqomCvFZHTI/qtG9weSYGiK71IOEMOnKmi6g+
	 Bh+07B4/s8gclFhx3ddiksFORUWkxkCMcTdyDX14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 4.19 133/191] dm integrity: call kmem_cache_destroy() in dm_integrity_init() error path
Date: Mon, 15 May 2023 18:26:10 +0200
Message-Id: <20230515161712.205421570@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161707.203549282@linuxfoundation.org>
References: <20230515161707.203549282@linuxfoundation.org>
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
@@ -3689,11 +3689,13 @@ int __init dm_integrity_init(void)
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
 
 void dm_integrity_exit(void)


