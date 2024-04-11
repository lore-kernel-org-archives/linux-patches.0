Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 575C1134CC2;
	Thu, 11 Apr 2024 10:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832007; cv=none; b=SwweN1QOqKoe+ikz+n2hU4yAUfJvmZX62rjEwtBw7BC2II7vbX3XFtN+vlzcFerVfTSvP7E6xo4l0ApRCLQSIhtK4nW8sOba/SBf4EJY8ZxdDl7lhso3biBjOlb7sB7AloeYUwjECD9IxJkJ/Ry1Rf1Ba1/x9QlolwGRK4lyJa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832007; c=relaxed/simple;
	bh=yhyM52jrUwn8QUQ7Ptt4FT13a3jFqCtx76TuLO+wlM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CfORxe9T4T7T/xAE3f3m2Ib/tSSzkuNTMKDIlJRbaW0CkjjN1ECA6SYFNC30LthImRatxe82JPfK3hhbLEkpTX/y23WLRyfr38q0/J0JrZm/CWOHQKrHk//kOF1Kd1Qk7+iK2D46f4/EnVb9ew68VqjvTwclKeZRKZdLWhQ1/hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AYI+YzUt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AYI+YzUt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2EF8C433C7;
	Thu, 11 Apr 2024 10:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832007;
	bh=yhyM52jrUwn8QUQ7Ptt4FT13a3jFqCtx76TuLO+wlM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AYI+YzUtop22awpkfdq/DPYt/y/qoNZL45Ssmxen3exmJDWozgEPUu1NJSLXdPBpT
	 DxCeaabjPwnnsV5y99QNpaepuRVUZuSu72bz4IXdAAQHvlNKVsYDuM0supAwfIsbfb
	 N3gnSv39bau71zYC7QKlItsufp/fDTea70pj9F8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 201/294] io_uring: ensure 0 is returned on file registration success
Date: Thu, 11 Apr 2024 11:56:04 +0200
Message-ID: <20240411095441.656667498@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

A previous backport mistakenly removed code that cleared 'ret' to zero,
as the SCM logging was performed. Fix up the return value so we don't
return an errant error on fixed file registration.

Fixes: a6771f343af9 ("io_uring: drop any code related to SCM_RIGHTS")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -8247,7 +8247,7 @@ static int io_sqe_files_register(struct
 	}
 
 	io_rsrc_node_switch(ctx, NULL);
-	return ret;
+	return 0;
 out_fput:
 	for (i = 0; i < ctx->nr_user_files; i++) {
 		file = io_file_from_index(ctx, i);


