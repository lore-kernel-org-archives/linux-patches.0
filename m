Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036923;
	b=LyvZevuwUV7WRgLsmSMZ2ukEPnvqo71C2gHjXa/FXm0UiR+KdH/HuYtmlSR/1di5wJ8Q
	 c/G7wVoAm2p8NCLh7wQjsrI5sf/XwSawi6wgF0UhCf7ejDcY+0ZHsYqlnXdsahVYtFKoi
	 s3LeEo7nOiDgWIxgdIfm0Afz1JPrqoHxepp41PfUgj5SLzvppEYY93sV6QnBH585YlyaY
	 rMEeMjjuScufQD8JmDFFPsj7MEhZSysEPq9zjNsXs6QTmmXEE61jr19xQbU5VncF0vQ//
	 +FhC41sadxtSgrOcsggQ7rJfwarqRZkZ//PEO6IrV7mYKE84cm+I5QCbm6gF8d64ypA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036923;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uGO/chLR3h6o3olvhsiGzQtLlJMtHx3i6Wvjh+EsIgk=;
	b=tEKNQVoENCECpE16UQbqndbgVZEiegGSP185oixM5nBtyAllycL8vLepx3GvcThGuQWW
	 35ZUx4QgfbtK/ji8Lj9s/Mp6BAq+nYlkFkkjGH+m9UWgcrFXTiucuE07HrPsCIiTKEcjZ
	 YOTEstd84w3ZYltJ67MkeqcIiOKzSn7liF4Uoy3hzNWcCdsMWtKRjfjHOuvHk8dJIJC3w
	 rdY0KaktWpGB6Iz1tHwZAMjzebuX9k4D9HW9FSY3SfAipi9yTrLBoZ5oycDrq4qLGByth
	 OiQhMfznwnsh0y/L8qLlGT69rhXWTvNaZXxscRA6c3TkC4gTccZFX4J2lHy4v5BFX8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ZKxi8dT/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5496D606A320;
	Wed, 18 Nov 2026 21:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZKxi8dT/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E3401F000C4;
	Wed, 18 Nov 2026 21:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036923;
	bh=uGO/chLR3h6o3olvhsiGzQtLlJMtHx3i6Wvjh+EsIgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZKxi8dT/LWUlOJ+fGy2YXyopipQ5m1nBC9Ml1j0YLa/BvGBdjgin2CzpwokdX92uH
	 RACYgql5HS6FRb/UQrAe4bsbW0GUK8O08bAGRLf0x7KwprjihFPUU0Qee2pphG6OOk
	 3JudJieKfZevIfQHdR707H/2h+nmGBa1GnVgOFEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubo.li@clyso.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1230/3318] libceph: only set read_from_replica on read requests
Date: Wed, 18 Nov 2026 15:30:52 +0100
Message-ID: <20261118150357.091782756@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiubo Li <xiubo.li@clyso.com>

[ Upstream commit d6c7a5fcd08873c45a2dcd645a0690fd1443af50 ]

ceph_osdc_alloc_request() ORs the mount option's read_from_replica
flag into r_flags for every request, writes included.  The flag is
meant for reads: calc_target() skips the replica choice for any
request that has CEPH_OSD_FLAG_WRITE, and the OSDs only know
BALANCE_READS on read ops.  Sending it on writes is at best ignored;
with read_from_replica=balance a buffered write that fell back to
ceph_sync_write() after losing BUFFER to a revoke failed with -EIO,
while the same run without the option works fine.

Gate the flag on CEPH_OSD_FLAG_READ.

Cc: stable@vger.kernel.org
Fixes: 22d2cfdffa5b ("libceph: move away from global osd_req_flags")
Assisted-by: Cursor
Signed-off-by: Xiubo Li <xiubo.li@clyso.com>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ceph/osd_client.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 2b51f951dd67b..9ac562ec3a81c 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -1131,7 +1131,9 @@ struct ceph_osd_request *ceph_osdc_new_request(struct ceph_osd_client *osdc,
 	req->r_base_oloc.pool = layout->pool_id;
 	req->r_base_oloc.pool_ns = ceph_try_get_string(layout->pool_ns);
 	ceph_oid_printf(&req->r_base_oid, "%llx.%08llx", vino.ino, objnum);
-	req->r_flags = flags | osdc->client->options->read_from_replica;
+	req->r_flags = flags;
+	if (flags & CEPH_OSD_FLAG_READ)
+		req->r_flags |= osdc->client->options->read_from_replica;
 
 	req->r_snapid = vino.snap;
 	if (flags & CEPH_OSD_FLAG_WRITE)
-- 
2.53.0



