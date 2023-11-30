Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A1D0495C2;
	Thu, 30 Nov 2023 16:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U1JTvi3d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A3F5C433C9;
	Thu, 30 Nov 2023 16:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361822;
	bh=vMW54CLgi7OaIEkDHVmFo42ZO3awxhFXYQGBOqpgEt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U1JTvi3dgPI2XVGVfFF3uIRsPNgxFTCuSe1WERCWlAd6x6K6GMpfRue0j/v8NRpvI
	 gFyatfu4avr/ODk1uY3sGGlpMIM0v30CqpFMdytSZJVG3r9SJQNMswq2J1cEPMvYCF
	 IZdz0+UjnWuDe8zEAWIUEyRJK1lCO5+ydPXEkwMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Mirabile <cmirabil@redhat.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 61/82] io_uring/fs: consider link->flags when getting path for LINKAT
Date: Thu, 30 Nov 2023 16:22:32 +0000
Message-ID: <20231130162137.911468776@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162135.977485944@linuxfoundation.org>
References: <20231130162135.977485944@linuxfoundation.org>
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

From: Charles Mirabile <cmirabil@redhat.com>

commit 8479063f1fbee201a8739130e816cc331b675838 upstream.

In order for `AT_EMPTY_PATH` to work as expected, the fact
that the user wants that behavior needs to make it to `getname_flags`
or it will return ENOENT.

Fixes: cf30da90bc3a ("io_uring: add support for IORING_OP_LINKAT")
Cc:  <stable@vger.kernel.org>
Link: https://github.com/axboe/liburing/issues/995
Signed-off-by: Charles Mirabile <cmirabil@redhat.com>
Link: https://lore.kernel.org/r/20231120105545.1209530-1-cmirabil@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/fs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/fs.c
+++ b/io_uring/fs.c
@@ -254,7 +254,7 @@ int io_linkat_prep(struct io_kiocb *req,
 	newf = u64_to_user_ptr(READ_ONCE(sqe->addr2));
 	lnk->flags = READ_ONCE(sqe->hardlink_flags);
 
-	lnk->oldpath = getname(oldf);
+	lnk->oldpath = getname_uflags(oldf, lnk->flags);
 	if (IS_ERR(lnk->oldpath))
 		return PTR_ERR(lnk->oldpath);
 


