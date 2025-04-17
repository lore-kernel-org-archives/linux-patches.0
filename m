Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600CF1A3178;
	Thu, 17 Apr 2025 18:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913355; cv=none; b=egdldNpek/DcjkwzQq6x5I7GXI/hjl77tVbVMhn2reL5geMl4LNa3IUhJyds+2iS811RA7bD+xDGnxShfaQlFkKxeAAArveTjpxjrQO1W7x1OZoIaYKHTBGUD/Hwb+nM01GI4iFGJLJ326fL8qpnH7CpcNXFjjJ19zUrCW597Mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913355; c=relaxed/simple;
	bh=+NlI1i5qYkHFsiD2rC5ds823KnUBPYhARA/F9qhvhpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bypm3dfdhNMRnlk/Wz+LckqgDQMurrB/hkHGvA7J9DkFBohgv13Ud1Mkgnt7ovzm9oqtrJR150giaOsXmsCztX1ogsQzXCvLv1WDPCGXTswoC41KQGVQyCkO0d280kxvxIJ7LltWT/2qkt4QJV1o76YLsegahd1ME0Ox1mbJy3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sgN6yoVw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sgN6yoVw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCB94C4CEE4;
	Thu, 17 Apr 2025 18:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913355;
	bh=+NlI1i5qYkHFsiD2rC5ds823KnUBPYhARA/F9qhvhpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sgN6yoVwdQhuVmFzc5yzU4H87OKH3s0uaNqvVYbAmGj6PKRkA9VuVfgP5Q57NHAAF
	 Zr3HckvrDzosyLNRhna/9TMhQ1nfRHB3T8Shag9IpNCXEgtwuMHYWjmlKSFQys1Vy7
	 ArmY7TrkrC0wGDJ9C+SvJcljl2Hwpkpuh2eaG1E0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Olga Kornievskaia <okorniev@redhat.com>
Subject: [PATCH 6.14 312/449] svcrdma: do not unregister device for listeners
Date: Thu, 17 Apr 2025 19:50:00 +0200
Message-ID: <20250417175130.669264701@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olga Kornievskaia <okorniev@redhat.com>

commit 750037aa0a9f28d84df3dcf319a28423d69092fd upstream.

On an rdma-capable machine, a start/stop/start and then on a stop of
a knfsd server would lead kref underflow warning because svc_rdma_free
would indiscriminately unregister the rdma device but a listening
transport never calls the rdma_rn_register() thus leading to kref
going down to 0 on the 1st stop of the server and on the 2nd stop
it leads to a problem.

Suggested-by: Chuck Lever <chuck.lever@oracle.com>
Fixes: c4de97f7c454 ("svcrdma: Handle device removal outside of the CM event handler")
Signed-off-by: Olga Kornievskaia <okorniev@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/xprtrdma/svc_rdma_transport.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -621,7 +621,8 @@ static void __svc_rdma_free(struct work_
 	/* Destroy the CM ID */
 	rdma_destroy_id(rdma->sc_cm_id);
 
-	rpcrdma_rn_unregister(device, &rdma->sc_rn);
+	if (!test_bit(XPT_LISTENER, &rdma->sc_xprt.xpt_flags))
+		rpcrdma_rn_unregister(device, &rdma->sc_rn);
 	kfree(rdma);
 }
 


