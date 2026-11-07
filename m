Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065398;
	b=3Ow/vZayi+BkEDJ+4BaRL5DHJxsrqaAs2DvzcMVUXAne7aSdLwm8jDZb3v+Px/lkTeNp
	 Q2B7m9wWJ/IdmZMJ8pXYpP2YDH7lPL5/cchVaGTSdTPdhu3hw9rNEMuxF/JHzCzxzUTWX
	 4p9FQ4liePmV1hpl7/jIBRU9USAMgkCNKlOrAPSm/UX6dvev+17AAlm35PRhQJphULNmz
	 hc2lX/goijrZn0bU9GQMKrkwXpKUkjKCnXVPqKuwHsaUPxxykcZ3eooku3p+FayyY3GNx
	 h3cweM7ha+anNQXd20sIpu+GUjptjwZUmZtdVAXZ6wYk2UJeyxYE+jsCglygNydnQzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065398;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XZqO2VxQjw1MZu9ix+Zh19+ys2t31/LRKNBgaSRj9ag=;
	b=q3hDNl1JL3TOZxOAbhYoHqj1Qsv9URtcsQ3Hz/UjhtoYQLlVe8ZoRdQlfL4uKMOOVb+R
	 E0sbRuMhDZlDg3x35aPveXyAEAqPhNOWxUlKBYvJMDhdy74GR0obTuJxYIVEmINnx25uC
	 7ehk3VBEnHm3EwglDFnpz6afy/yZCqutMJWrxTW0JPuznlRqnY5OncMI/KxD8vlH/GJya
	 BtMCcp9s0DEtbVFC1xdobMNGxKBEiN10CupyHHdwAtY5yN885ODMn7+iJBpJXgOWEpsdG
	 BbWosYbbmlgyUpr4aoa9cBLCnlJqNrT8gItN4hHogmCwccdNUUBbwJ/qzMeUw0dv3hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YQ0WqX0x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE74606A330;
	Sat,  7 Nov 2026 15:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YQ0WqX0x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2CE61F0089F;
	Sat,  7 Nov 2026 15:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065398;
	bh=XZqO2VxQjw1MZu9ix+Zh19+ys2t31/LRKNBgaSRj9ag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YQ0WqX0x5DhaHZHRJW3MeOhOAUIe18Fpo0Vyt3xoGozFnil07CJrNsoyfwX3zdF6D
	 4IutsZCh8EWDR7scG83JYMrEKFGYkEbO2hFFVVp3GDBRY75mUMe/L8iGOXor/xy/61
	 Ex+6ADcbIBWsqrcSD4DDfWceejYqhFp9DARJEQ6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubo.li@clyso.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1119/1257] libceph: only set read_from_replica on read requests
Date: Sat,  7 Nov 2026 08:56:55 -0500
Message-ID: <20261107135010.145121058@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index f36ce5ae75680..8c2b89e2004ba 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -1108,7 +1108,9 @@ struct ceph_osd_request *ceph_osdc_new_request(struct ceph_osd_client *osdc,
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



