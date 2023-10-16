Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0114B15AE3
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 08:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N/ECLEcz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45C87C433C7;
	Mon, 16 Oct 2023 08:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697446050;
	bh=ylfjCr0YfR0pUW63ms83f37UZY3pNB0WVvsggqwsAUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N/ECLEczu4GCPH9DaULMHtfpwOMHCzsqa215v522rbrJ5ZBXnQuMdVBW3V2WBjEVQ
	 kwPoiKR9fkkjBkik9VIl4CR0u+jfXf/EqBasuo/TX5OQazbU81uhZms67nbp6T4fg/
	 /fEncReeUUWw0aQ6sgGTwl8NRoVJroUg8A1ZAfqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.15 067/102] ceph: fix type promotion bug on 32bit systems
Date: Mon, 16 Oct 2023 10:41:06 +0200
Message-ID: <20231016083955.488097101@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016083953.689300946@linuxfoundation.org>
References: <20231016083953.689300946@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2436,7 +2436,7 @@ static ssize_t __ceph_copy_file_range(st
 		ret = do_splice_direct(src_file, &src_off, dst_file,
 				       &dst_off, src_objlen, flags);
 		/* Abort on short copies or on error */
-		if (ret < src_objlen) {
+		if (ret < (long)src_objlen) {
 			dout("Failed partial copy (%zd)\n", ret);
 			goto out;
 		}


