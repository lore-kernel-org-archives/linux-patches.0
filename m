Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4ED121171A;
	Thu, 12 Dec 2024 15:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016396; cv=none; b=VIFzIIYlI6XOxKx6wfXCADmjJkQUpMFUrb42l0UwfrezclpMERswfomHjpO7H/YMZnb+GptyfDgfviIOYsON928ErfWRIl6Bcw8c+LlJ8DFYbcINGTg45beWiAuA4kRCzUYGpiSwDY3j0NszZUeenoh/wyXIIKMNRqX5RR4gq5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016396; c=relaxed/simple;
	bh=cKE8iliZiavBbSnLsu/3HY7BWv2u+jER0+62JZFkBrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CCHPzMk6I+z4mjG9G+03TpxbSQGRJ+8Znaj3K7Ui+eA+zoYtPLBTBc1nN0IT5jFggVRFp3ZTPbx4dGOd6QMSgtHvQTwe9h3vD8MiqLNuV7Kj6LrWHoTV/BE/KCne0i1a4R81XVT5s0dR2p6tBXdzWHc8NP22vqbD0H1c6Anm3KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BF1eifLm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BF1eifLm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40D78C4CED0;
	Thu, 12 Dec 2024 15:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016396;
	bh=cKE8iliZiavBbSnLsu/3HY7BWv2u+jER0+62JZFkBrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BF1eifLm+m2wI9NmcW6PwKzC6iY1EDamDqT1ZYffB3I1mwVQQc1ql7xypu0xZElvd
	 lTutgrMPCgQGZLgUHSolV/ZDVe8Pfml+R8Q6L5BuqReeuLSMydIQJwdUb13pv8vs36
	 WEnCbX435dkPOHMsQsIzVV72HDDdsWJEevdck7P0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kanchan Joshi <joshi.k@samsung.com>,
	Li Zetao <lizetao1@huawei.com>,
	Bernd Schubert <bschubert@ddn.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 160/466] io_uring: Change res2 parameter type in io_uring_cmd_done
Date: Thu, 12 Dec 2024 15:55:29 +0100
Message-ID: <20241212144313.115425486@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernd Schubert <bschubert@ddn.com>

commit a07d2d7930c75e6bf88683b376d09ab1f3fed2aa upstream.

Change the type of the res2 parameter in io_uring_cmd_done from ssize_t
to u64. This aligns the parameter type with io_req_set_cqe32_extra,
which expects u64 arguments.
The change eliminates potential issues on 32-bit architectures where
ssize_t might be 32-bit.

Only user of passing res2 is drivers/nvme/host/ioctl.c and it actually
passes u64.

Fixes: ee692a21e9bf ("fs,io_uring: add infrastructure for uring-cmd")
Cc: stable@vger.kernel.org
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Tested-by: Li Zetao <lizetao1@huawei.com>
Reviewed-by: Li Zetao <lizetao1@huawei.com>
Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Link: https://lore.kernel.org/r/20241203-io_uring_cmd_done-res2-as-u64-v2-1-5e59ae617151@ddn.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/io_uring/cmd.h |    4 ++--
 io_uring/uring_cmd.c         |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -43,7 +43,7 @@ int io_uring_cmd_import_fixed(u64 ubuf,
  * Note: the caller should never hard code @issue_flags and is only allowed
  * to pass the mask provided by the core io_uring code.
  */
-void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret, ssize_t res2,
+void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret, u64 res2,
 			unsigned issue_flags);
 
 void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
@@ -67,7 +67,7 @@ static inline int io_uring_cmd_import_fi
 	return -EOPNOTSUPP;
 }
 static inline void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret,
-		ssize_t ret2, unsigned issue_flags)
+		u64 ret2, unsigned issue_flags)
 {
 }
 static inline void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -147,7 +147,7 @@ static inline void io_req_set_cqe32_extr
  * Called by consumers of io_uring_cmd, if they originally returned
  * -EIOCBQUEUED upon receiving the command.
  */
-void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2,
+void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, u64 res2,
 		       unsigned issue_flags)
 {
 	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);


