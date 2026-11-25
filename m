Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626008;
	b=NFXiM289MmJCqyvoj7PCctM7ZyCdIeLoA78rV7KsaOdlfxK86QkDhuduRGVyqjQY08Tq
	 AYXys/b+cTR738DshbSubMoLn5guxX4vSmjZnpvlcHe74ODIF+gGFzDtZOtaZxYM8A9Jn
	 gQQDPc8b49ZauKheg2oza2DsmAePV/wq6G3jwpAN1sksW+Nh/BXDhIsZ9Ma7AQ0Ul+6bx
	 9P3Slnj+lwNJCkbKbLlIbILk2KgIuVOm5dqChbxjxCNq4T4ZsS+iSHEIyi59PNh0G3MZH
	 /WrZt1njjweC/gcpn7+lBomLLxAQQj/2HffDH19qJ5928LtQBkkSbMRA6MkIqBo8SFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626008;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FYjHXWcr/l735xkM5wbT/y01k75BiiIA9HEE46rdHmw=;
	b=3l+OWhjqh/7+SFjb+DMwAIRwifkV+QE0/eOyfd/t/Frdp6LGqU9oCNXKldJ36ryqc25k
	 B/MYip+FdCMu8AarXq/UUQCd5aF6C4Om/wg7cj6zQGPOo2k39s7Rz7lQi0/e9IK9ru7b3
	 GhG269IryPkItgtd+Qn9KnrBfzAAk+EtiCryNcT2GQ7V1rkxHM0EZOn3Uh8CE0eDAcLbQ
	 pbhY81K8b8pAJzModJXt1M6PVRQCmCm2LNSdNi8f6y8XANXrGVWulL6CyJrpCfIygoDGf
	 xL+xETUWYBVj4hLbDmHXlFh1p3xkfUVh9nepWsmlTFj8YWdadnU/h0t4rL7sQzycpRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vG2sCq4n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC462606A323;
	Wed, 25 Nov 2026 17:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vG2sCq4n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF401F000CF;
	Wed, 25 Nov 2026 17:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626008;
	bh=FYjHXWcr/l735xkM5wbT/y01k75BiiIA9HEE46rdHmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vG2sCq4njCe89NonXCwzTcXlJl1HFfpNvnju4hnts5qt3DlOy18ZqM14QDRVXBeNO
	 K9QWtJFAFr3aVx6ChWiLrPEpsV+4YjDanEaKs1EVbHbK9gXRgVKAuLOoJreobJeTiz
	 GbXv1n5CAIVMTgrgYesMQhw5wPrvONRo0UmzYVGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Wentao Liang <vulab@iscas.ac.cn>
Subject: [PATCH 6.12 699/816] dm-sysfs: fix misbehavior if kobject_init_and_add fails
Date: Wed, 25 Nov 2026 15:37:27 +0100
Message-ID: <20261125143905.362993394@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


