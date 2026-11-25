Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623438;
	b=rpewWffMB2tkZj+fffO+/tOVmdl/lG3LXTq0PCb+64UUa08PhTdmMrUJG7l1Ph/msnVj
	 +4MGIs+L4OLjIdyYr8GH90ooIeFGPWmcLVlZYo72s5anBz255sLE1Vi0Y1p3TeBHsCQrA
	 LKa5jNmmk1EkL7OZP52Pn1bg1/5zxMY/YJXuDLtkY9d7tvKIY2I+cftw+vpPwNaYSPzOH
	 qo6uO8YNqZ81hJyozFWJTQEhLmr4mUTCebJpZW3yH6YJhFSpssqMeJ0mfPu2ug/bDmzf0
	 l1KTzqXiU4Vykm7IP+TCuZkfZOQlku7cc+EuIqAtgeX0Hozu1Tl+1rxZEqoDyi9B/eA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623438;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=giqOO9BVLADWpX3HBU9ROFiCfD9vlQY59DproNTvw28=;
	b=ihCMq80iFaYWRDL7/CDkOCpmL2ZnKOGGP5WAbAz5u5Cz53HuWc8MtcyYiHDDlSmKBVfx
	 XUxvSFDVzi8f1IThdV23etSK77LpdXaJFzCR+3Q58JH6WGeBSv/lfSazXYIL16Pz1QBrO
	 1ewnWw0Bcw7LCHaLU5CnVqw1kPcCur5jSvGy5q3X4fvWqRu8jon5W5gn/0ApUaYghQ9ff
	 waUsu6zsu2T/Oju0HQ7WWLBJqksadLm79E2btjfYwAQgVCGtJrZPnhxgoY0wj+wQgsrhX
	 RdT6o2f9YKFLR9by8KDqr/hdfOREcmoF4sSfGJ7ce2v+9NApnL6FSw7KCXeErCNQU0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SSJcBOFa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA139606A321;
	Wed, 25 Nov 2026 16:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SSJcBOFa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06D761F000C6;
	Wed, 25 Nov 2026 16:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623438;
	bh=giqOO9BVLADWpX3HBU9ROFiCfD9vlQY59DproNTvw28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SSJcBOFa1tn8jupjLR84QUI3OjWIpSYH97d0xqszOePEYZAJ2QcIsiMkt0v5NZ8ye
	 SgD1biCLkXh4gfCpMfoPZHR+xqbGDTXzb/vJ9DNhVyJEONGBpaORsrdWALgq3CQ6km
	 TabIMGSxeYw8EAUZAIe489KSu8LLpKlZCOMhPrKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Wentao Liang <vulab@iscas.ac.cn>
Subject: [PATCH 6.18 860/990] dm-sysfs: fix misbehavior if kobject_init_and_add fails
Date: Wed, 25 Nov 2026 15:37:07 +0100
Message-ID: <20261125143842.171142740@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 406d576cc457203cf86eac7f17839b2efec81db4 upstream.

If kobject_init_and_add fails, we must call kobject_put (see the comment
at kobject_init_and_add).

Before calling kobject_init_and_add, we must zero the kobject (see
https://lwn.net/Articles/52085/). If the first call to dm_sysfs_init
failed, it may be called again, and that second call would see an
uninitialized kobject.

Cc: stable@vger.kernel.org
Fixes: 784aae735d9b ("dm: add name and uuid to sysfs")
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reported-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-sysfs.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/drivers/md/dm-sysfs.c
+++ b/drivers/md/dm-sysfs.c
@@ -132,9 +132,20 @@ static const struct kobj_type dm_ktype =
  */
 int dm_sysfs_init(struct mapped_device *md)
 {
-	return kobject_init_and_add(dm_kobject(md), &dm_ktype,
-				    &disk_to_dev(dm_disk(md))->kobj,
-				    "%s", "dm");
+	struct kobject *kobj = dm_kobject(md);
+	int r;
+
+	/* The kobject must be zeroed before calling kobject_init */
+	memset(kobj, 0, sizeof(struct kobject));
+	r = kobject_init_and_add(kobj, &dm_ktype,
+				 &disk_to_dev(dm_disk(md))->kobj,
+				 "%s", "dm");
+	if (unlikely(r)) {
+		/* Weird semantics - we must call kobject_put on failure */
+		dm_sysfs_exit(md);
+		return r;
+	}
+	return 0;
 }
 
 /*


