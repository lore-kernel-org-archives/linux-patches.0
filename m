Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 310B7183CA6;
	Mon, 12 Aug 2024 16:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480388; cv=none; b=Eycw2l8ANNfRhQxRvB9yp+02aUBMq/5EOJgoKtw8p2dM40/aptZ+DSeEIW+I/MLSi01uufjyA2JAoBu6/9O3M+1T1HErG415nG+DD/LgdCf2q0Y/fEq+0uV1GAdGWdYadHVn5Ueo6Osmgqy8Ufhs3ON3wrf0VM/FxZ9dYiwCu5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480388; c=relaxed/simple;
	bh=4OseameZuHtBWPxRPRVQOm0Yifzkn0DyaiXFvr03cA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pgfIFTSIdCbPgmrpI9iakrlIiDYaS820JvpoN5GSzmvxynuYNY4va4oWg44tltwaKboAFeaWR40hjuiPBFoC9v9nn53FKG+bhL+wz96UAATPioEa9Wi/i7TKesu8ndGS1VcPU9aKdBXdxwt3DkfIuthl20CTdqcX07BngtS1Ha0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d8c5y4Zi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d8c5y4Zi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93A7EC32782;
	Mon, 12 Aug 2024 16:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480388;
	bh=4OseameZuHtBWPxRPRVQOm0Yifzkn0DyaiXFvr03cA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d8c5y4Zi0uHkLbOI6QhjS9sOJ+lBiBaIICy/Y0hCOweZPJ+gp5qzvacfTyJDYcNvB
	 5h6TpnJEP9t2hjffHMenyKCH7M1Y4gPNBCy3MFXcjHxQFtq0CudwcCV5yfh5hbiLRk
	 Rq50HVhP9XOy8usD++VSupZWrBhOHN2lR6Q5vpwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.10 179/263] io_uring/net: ensure expanded bundle recv gets marked for cleanup
Date: Mon, 12 Aug 2024 18:03:00 +0200
Message-ID: <20240812160153.401548579@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit 11893e144ed75be55d99349760513ca104781fc0 upstream.

If the iovec inside the kmsg isn't already allocated AND one gets
expanded beyond the fixed size, then the request may not already have
been marked for cleanup. Ensure that it is.

Cc: stable@vger.kernel.org
Fixes: 2f9c9515bdfd ("io_uring/net: support bundles for recv")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |    1 +
 1 file changed, 1 insertion(+)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1084,6 +1084,7 @@ static int io_recv_buf_select(struct io_
 		if (arg.iovs != &kmsg->fast_iov && arg.iovs != kmsg->free_iov) {
 			kmsg->free_iov_nr = ret;
 			kmsg->free_iov = arg.iovs;
+			req->flags |= REQ_F_NEED_CLEANUP;
 		}
 	} else {
 		void __user *buf;


