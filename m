Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684EF266B7
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="myiiFeoo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D739EC433C8;
	Mon, 16 Oct 2023 14:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697468171;
	bh=yCO5UdVJ9CSQh+9SwbRcF4cDUbS7g6J3yhe+PeMeFWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=myiiFeoovifJQqMwSnkkcldezqukwqTJ1qUskvjXoooSychssBq54T9vxVbTzLfba
	 nDZuVxIMhGT8D3fHc8PJrxAKyNG7KP8a4ABS8VxJMIfZeOtKPbv/Y0JRipU5aGqYdI
	 X8+/nIrp+zXikdqc7jTuObr6zOKEiz461sphW8sE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.5 148/191] ceph: fix type promotion bug on 32bit systems
Date: Mon, 16 Oct 2023 10:42:13 +0200
Message-ID: <20231016084018.836670801@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 07bb00ef00ace88dd6f695fadbba76565756e55c upstream.

In this code "ret" is type long and "src_objlen" is unsigned int.  The
problem is that on 32bit systems, when we do the comparison signed longs
are type promoted to unsigned int.  So negative error codes from
do_splice_direct() are treated as success instead of failure.

Cc: stable@vger.kernel.org
Fixes: 1b0c3b9f91f0 ("ceph: re-org copy_file_range and fix some error paths")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -2559,7 +2559,7 @@ static ssize_t __ceph_copy_file_range(st
 		ret = do_splice_direct(src_file, &src_off, dst_file,
 				       &dst_off, src_objlen, flags);
 		/* Abort on short copies or on error */
-		if (ret < src_objlen) {
+		if (ret < (long)src_objlen) {
 			dout("Failed partial copy (%zd)\n", ret);
 			goto out;
 		}


