Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704668;
	b=VvFc2+JXmxigucAFyF41QVs8YW+7e4BdTFNkpzr05np4tP9QX+N9tAMguK3mCDnDKfdD
	 l4E+Nzr+RDiHmGqDmL1EFIQT1kx8Cly6eyEoPsooB+D6sVRVpC88kvGrzPghhxZ8N44cz
	 nCc+8g8nlZwlUua6A44YImM6l5maQFrzsfSkcyDoxgBFmO1nNMTjt47V/kogrpP7YaXM3
	 Oxya0emuuu7xjUJ3BjD7tf5oRll/zMvFQOxIvEowx/KmR28J4tvQlFoOGfsIjWbXV1RLe
	 opf3czpbnoXs3Pn9C29XYe4gVdhKSX5hMQNcWSZZkS4CVaCcGr1D+NxzDJcGkFKO/dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704668;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TLT8szEwQ2cV/PV1MKxJcwc4vG2dI9e76HRiJAjpcdE=;
	b=lllcpwe88qPrcSOueQxbVrrqJcd3joq2ifRdcKmm3m2JSFflcMNdOQBvUGTYvPJWprYY
	 Vyl+0nIr37nYTLKb7UKICB0NkWGtNn8FR/d3rYpO1UK38ab4VdSQALR5tqz36MtPl4NHo
	 7nnGdD9wATmvRad28DaF+LGTTvLq+4LD0jSFdhwVpGSlKmbwWfRhDKzp8QQ+QGCZlhA06
	 7x3F2lucqvQbI3b5NaC+U+pNNmj8yCBcRhkExNapvVlsr+xXkIfD6j1QJ04PtcMQSu4n1
	 F9NV8tZV8kvo77m7F+XeB6QD+emgKQW/hQiR8Xv6VeckDW50FXLN1lPKOUT6Wk5Bbug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wPm7b0wh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0889606A31C;
	Thu, 26 Nov 2026 14:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wPm7b0wh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C08741F000C4;
	Thu, 26 Nov 2026 14:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704667;
	bh=TLT8szEwQ2cV/PV1MKxJcwc4vG2dI9e76HRiJAjpcdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wPm7b0whSW0OFibYJaacW8G+QgdUaGQne6QtJJiR3DZNEO8jcqiv/Wdo3qFA8hrTT
	 m/OK7MajF0bULRiTi+DUNX3ppSf5h3wTHxR97cqvxdES9oT8j9MsHTfxl/QIgH7MmZ
	 gBfLmN+CNyQDjWVbS7dn/PAE75JWoAgt/R1kbuD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Wentao Liang <vulab@iscas.ac.cn>
Subject: [PATCH 5.10 204/265] dm-sysfs: fix misbehavior if kobject_init_and_add fails
Date: Thu, 26 Nov 2026 15:38:54 +0100
Message-ID: <20261126143619.475618976@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


