Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2FEC1448F2;
	Thu, 13 Jun 2024 12:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280171; cv=none; b=DkVLuJ+/+7lOpO1icpHk7zQ2xPKIAa9B2tJ3sYz+WE38THM+MnkCMlPPMv2k4Etaev8tQtdQZhQQTl7puZ4L1U66pduK5dajPw9EpJr8WGNU/u4KRUwWZ6nPJWT5a4FaxI/2HnHy3cq+PaaBm6kZhOESE6UeWAQsuINYAfvIn7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280171; c=relaxed/simple;
	bh=wHUcXKw3kUPuWRYCS9w9HlVE6ZGDyQoV2AbtkxZK49Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hh+McvG45zvcKUDL7ZJ9ofNBXdFioVUzfBqwgZXzgWNxMYaeCEg2x5mP+6BNnwtiMQEkjjlYS5sdC84OBprRO7waLdsBw4KdiSjlba2Pai990DMXsSGoH0xoz4t3NJmVaqpmW85MHj5kZQYCBbY6SuaRUx58Fn4750C3H+VBXdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=askQuq0T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="askQuq0T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A162C2BBFC;
	Thu, 13 Jun 2024 12:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280171;
	bh=wHUcXKw3kUPuWRYCS9w9HlVE6ZGDyQoV2AbtkxZK49Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=askQuq0TWoKABnGBy3YAPvOvmeKSy4sBqEp4l5JbouY2BYwQSb+G3uGyDG8BdBeiT
	 9HGPwa4x1iw+e4VHbLctOxDymf8CV3G7W3+EAyHja5tPhxNDNGZyG1xZ9kN5GjnJRp
	 VFug0Y+t40TWFAHLDRq43QfOW4VwzACFraqlsXGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 5.4 167/202] io_uring: fail NOP if non-zero op flags is passed in
Date: Thu, 13 Jun 2024 13:34:25 +0200
Message-ID: <20240613113234.190482535@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

commit 3d8f874bd620ce03f75a5512847586828ab86544 upstream.

The NOP op flags should have been checked from beginning like any other
opcode, otherwise NOP may not be extended with the op flags.

Given both liburing and Rust io-uring crate always zeros SQE op flags, just
ignore users which play raw NOP uring interface without zeroing SQE, because
NOP is just for test purpose. Then we can save one NOP2 opcode.

Suggested-by: Jens Axboe <axboe@kernel.dk>
Fixes: 2b188cc1bb85 ("Add io_uring IO interface")
Cc: stable@vger.kernel.org
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20240510035031.78874-2-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2112,6 +2112,8 @@ static int __io_submit_sqe(struct io_rin
 
 	switch (req->submit.opcode) {
 	case IORING_OP_NOP:
+		if (READ_ONCE(s->sqe->rw_flags))
+			return -EINVAL;
 		ret = io_nop(req, req->user_data);
 		break;
 	case IORING_OP_READV:


