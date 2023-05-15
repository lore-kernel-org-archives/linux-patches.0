Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD4B107B2
	for <patches@lists.linux.dev>; Mon, 15 May 2023 18:04:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C8C1C433EF;
	Mon, 15 May 2023 18:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173878;
	bh=Cd4eGKbEC6w3b7AyxXC7nFJ9oPxOZbY3+/Kkp9cPs8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E9X4oD20Ym1rd5SdPFGQvPM7UmfNDOjeP+TK2F592gH94zooTIMfXzvevj5WBAZka
	 A3FGKryMqlj8GPMAyGBTlBAtCpoOBI/RBoB8OjtGwhQ66B95vwcf3V8jb1tTjg4dSx
	 goqwYaKkM1xdGwO9HI2GlJxyMfPFYMKvlP1H7oi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 5.4 204/282] dm integrity: call kmem_cache_destroy() in dm_integrity_init() error path
Date: Mon, 15 May 2023 18:29:42 +0200
Message-Id: <20230515161728.365540462@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.146344674@linuxfoundation.org>
References: <20230515161722.146344674@linuxfoundation.org>
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
@@ -4288,11 +4288,13 @@ static int __init dm_integrity_init(void
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


