Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063707;
	b=t2t2BWafuY/DfbhZ2TG+quS98mKB+Hr4/RBg5jDYBky3dBKpNH77qNBz8sHWOfrhtzFG
	 unAmU/zuQW+Yg8uEjZ7I64GNN/ac/ZG69UnoV3xaaGvjKKsAc+HRMbAGOpvTE6YjEVCEs
	 vRAOqBkgx+q1FnBIrNxwQIY4lGYJMv0bosn1kRDcVX/wM0cq6FMOcq1+zWtgZ5wOyXC8r
	 x66sRxlCPskVlZSt4Z674Nr1NRY4Gn0/3Ddu6jzrKdK75Ecv7hORCbMzaZ2R0QKY5xxDy
	 ytD2jtyO1Lu2zLd9Ed00EkBKka8/EVvSAl9tNfBgHrpcnlgcFUeY3SWDzwp8F+r6wxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063707;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0BlabbZCxxwBNfPtptYqnhdBXML/uYNxrB+xv1Kt00g=;
	b=QsCMajLS8X6fs5N/S8/9Iwfc2NevqYqF0Vr3Ja8lCez+rp+9Cfo48qSTGYbFYkp6GDJJ
	 raVSUgNuqcGFR0Kqvlf6s7AuU+ccotGtlmQUnHT607mvFtw077pkGwNRVDw/VciT6s1de
	 Psrm96GBsNIslWCYOlbfQKLhNSHRsKam+uFkqEf+aLpGNRyFG0mu75alYW4eOTOEi5xiw
	 jcQ3gMnrhfYzcH1FVSCwWsR+U06YQFwrNAGQ0KEltA0Uye4VZlZSYiBo4uR6sUuQswoyf
	 hlnxvb4b1eGkARdZ+ztjGt86T561szUxBA1mR7WFj0nRqRLgxmXu/ECUBQtyJjmh+uw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X7LZALg3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA2F4606B8AF;
	Sat,  7 Nov 2026 15:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X7LZALg3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5942C1F0089F;
	Sat,  7 Nov 2026 15:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063706;
	bh=0BlabbZCxxwBNfPtptYqnhdBXML/uYNxrB+xv1Kt00g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X7LZALg3lN627UuEoxUOrkC+sJrg6IbCwrYPU2J0abKkpDMpKPnSIs7PlG3YL7rPG
	 D259eaO07NlNtkSn744IYPD+XdV0yuzxG+Nydji6iaJcnWqe+erPaE5akNiWNV9vWo
	 6CBM0BGTEYxicCCzZCn4DXz83/KNeDjS9ScJfOYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubo.li@clyso.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 770/869] libceph: only set read_from_replica on read requests
Date: Sat,  7 Nov 2026 08:57:32 -0500
Message-ID: <20261107134918.820788207@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index 46b2c2ae77784..92d76df2701ef 100644
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



