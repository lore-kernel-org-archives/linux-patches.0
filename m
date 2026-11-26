Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705582;
	b=EJZZReEN6ZgdlYnVpDdx6xeaI9uCBzvDj6CB7U4EmjeLJIWPxnk1fCCzHxYQlo94mnTl
	 yp2QyhDNglbLsemRzJs0SBK3Fm6GTBDFtZ0vvHol/LRtTfF3mFnYKs1WGlqVZBlH+J8gN
	 eYvlYjhyRnYHjsMEw6Pa+LiANLBUupDyD+cHWpZVqRWwR7BzrE1zkxZFmQbRn1EkpGXu5
	 11hVWJglZhjy5j2eO9zINiMk0iD8iioQ5+Zj8uzo9c0sOER3Mmt5AltnJ8ia/ZNy3P3V7
	 6nSuOw7+V8xGC1q5Bjk9HI0tTPuM4uDtp9GoQOjf5mK0AcF8O6SrnsJHlFclkA5Hiig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705582;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Epy8aYYZ4+ateLwZNJz0h7rf6EPGrdihkNQNEpbZTbw=;
	b=bKCr4Y63lOyQgjSzvL414j2tzVMuDLjkvnOjC9q5E0SdPJ+D8knHGearplHTEIUUANfk
	 WB+YlxuEo+kSUXNI3R361RxjfZa6g2RR4cwlGRVyuYEfObtyKDu15E6fU3R8d1nVJeMd0
	 Yis+9EiRiK4Wl/TMWFx+8CEENolbCe8M+nlzJxYbTvHhBgGJ7FYUfKoTWjqIzgW8rPJcf
	 wqn/ZR4hCfubeetyqecpf1bOTXDReoBs+BUA+OwZnyG25qAvWORhzL1cV2QaraGQSQcpY
	 c2x4Be7yu2xoFk+hIpZ/fxs6LmU51Gb7Fy24Uza+kMm+f3jotYRHNyAobAEtQDrCmdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GsQJDoMJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23AE606A323;
	Thu, 26 Nov 2026 15:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GsQJDoMJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 282231F000C6;
	Thu, 26 Nov 2026 15:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705581;
	bh=Epy8aYYZ4+ateLwZNJz0h7rf6EPGrdihkNQNEpbZTbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GsQJDoMJrKefmwkEnQWPqvvTHhVPEYYIjjc1wysHJn4P+fy4q0wCygrWeqf8571gc
	 ehagnOhlQok9sWiTFSxDjAsXM7jt+EwzhAlp8PI8Nsr2fdacx3urMzXdqw7f5cTXdP
	 MCuO4w3qnsaHQIVvvbq4H4+VtynRTjgUAECLG4wg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Wentao Liang <vulab@iscas.ac.cn>
Subject: [PATCH 5.15 246/319] dm-sysfs: fix misbehavior if kobject_init_and_add fails
Date: Thu, 26 Nov 2026 15:40:14 +0100
Message-ID: <20261126144012.296583862@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -130,9 +130,20 @@ static struct kobj_type dm_ktype = {
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


