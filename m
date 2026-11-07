Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062575;
	b=c2xAhPyaOOKMllE3e6ToFs09S0Ah9Dt+poiUrViQrkcs9UY884K5ILQ9cZN3hpRjTdWO
	 Y48N4HRlH8huWNHcJO2nVSK+yRQKVhbmZY3dBQpUtLMjtN9hnBTnmNdVoZyCK+Iwu/IXc
	 WT9lY+/Xq1UoGZM291H9g3kKdE+WW/mfbPjQ+QhNvWEKHHKh91dHk+V9HXvD20Y97fytk
	 IOrL1zsgIgYiPWxOrBX710QdQeConFZbCa3U5Sy1CPsZexF1fPXxMKGVstkOgQTN6Ees1
	 jJ7MewoyZ82SnCag6DeZ68yiGKyHivrLIbLKUS7IGNkQq3zjOVqfLc86L8mVNOw/b1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062575;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JqBO2GPdg75+LNrkSUvOKfjEKlBl759tgIT5xxAs9d8=;
	b=wUFmX+pUye0J6nRputg5hpGB7jB3zpu782xCXIvva1IYK6R5VR0XApfMXfylB85wY23o
	 3dFwZQTnn5KN8ORpDfc8oyx5N3dXeCSwCJONyeAjABpWBdvmPab+lr/j71FSeTxpiIUH4
	 v1iWQEgeGWxRRcdGcWCthF5Mcy7cktsytYDObTRYqWMPRCe8SluwmDvB+nwnTrNzh+4ws
	 qTBiQ1Ap9W2hyvGBEGm7NFFzI+aKdpo6B63veHWzDlUj8yhTOG/H40FgDkpKGyBJE7d74
	 W4uQwUriiF+PJpBfNB7XV3sr3JvURU0kkITH1b/pN4qJhipXo2IfwKawg8mIU6YIfDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FXlxGl+C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 796A1606A32D;
	Sat,  7 Nov 2026 14:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FXlxGl+C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EF231F0089F;
	Sat,  7 Nov 2026 14:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062574;
	bh=JqBO2GPdg75+LNrkSUvOKfjEKlBl759tgIT5xxAs9d8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FXlxGl+CwbkBtk/6w16Zvc49LAf7TJQnx1IWYQ5+ypxFh6H3RGf+9vaa2yT/BwBeH
	 PMb0bMLOWcLWzY0rJgY9p9nhsa8BhTtS6s65zhnheLmPnBN+bRtIWjdhFhrssyADny
	 FKHNzj7bxtHBGDPDoe2MfFLvkxvTCqbXNwTTKDo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubo.li@clyso.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1457/1536] libceph: only set read_from_replica on read requests
Date: Sat,  7 Nov 2026 08:57:53 -0500
Message-ID: <20261107135038.762335943@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 07793b87709de..c27c8858b1652 100644
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



