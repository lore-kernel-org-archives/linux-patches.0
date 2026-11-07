Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061903;
	b=jmNFBkpckSoFYmQZukdDP13py10lDUJCZdmQ6cGEet0GrLsAXZ2am5sLE4vwCiBoh3AU
	 7Ez0JdG0kdSRrYyOml2J6Qf+VSHjgr9neWMrnvfYlyVlRKNj8nKTuTBQ5r+e4ZUnFz1Y2
	 tyUZdyQCyrfmP3X0ZQaqR8vgYeQiQKEZ4qw3Rw/sYFn3dIP4e08btMwYzOAmFOSCKsGL8
	 36SnxE8QDE7R4yRkvVtZVAhYqZ4151Gd8NSpZ3VQ5x5dyyC7Bia8bLLtuwPfN+5f8mPZK
	 VjP6l4PI2KpEq409+dnf0Hzyt/jnHcZXiCB/F5p88K9Eoi/cMWM2a8BLYv67KUK9cJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061903;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NXKzebfEOQ95amzEunpbjX3hwg04TDIbJF12GtGJrlI=;
	b=sn7oNDDGeWjEJUT000sl48kl2IgBY3B79gqd691Vhl7UnJzSbBDftenH+D89kLiZZcI6
	 OxST7QwB+7j4WewCxMzYS5iUO8M22Sp74kxWZ9+t3Kb1zabV9BmHIWcov6AOpr65M5Lr2
	 Tp0ahdW0nFYJyRs4OWGyN8BFOjyx4to8dAD680LzP+Wl8uAqFME0YdvhlXqozcb4jAzl+
	 EWfef12BebGxf14FMhHrFV3Oq3QQiBr3XRaKUBYfPuls7aYe382Hg/hWzksiE7/mFqHqk
	 eTgp8UbNpVHoAEz0QU77/efGdOn+G8cFNEDdG7dz9luObfiJCHyOptoDA/NxLBkILdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="gEgtw/Be";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF187606A32C;
	Sat,  7 Nov 2026 14:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gEgtw/Be
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EF511F0089F;
	Sat,  7 Nov 2026 14:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061902;
	bh=NXKzebfEOQ95amzEunpbjX3hwg04TDIbJF12GtGJrlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gEgtw/BeYv7/29n1qQXcyYIoLLNhuQ2VQAniuFOZE6jDIa1ZrW/aJs/9vWhIz9CWL
	 tmRnGpXRSVCIr8dsKFZRII4YYdrapWhmuby53T62bE5t6Y6/e6760tqO9YJ9l2PQdq
	 8dKLC1V68e9ZT1HPJ/4Z1r493O7PgOzebwaOqOgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Metzmacher <metze@samba.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 6.12 0864/1536] smb: smbdirect: fix buffer length underflow in RDMA transfers
Date: Sat,  7 Nov 2026 08:48:00 -0500
Message-ID: <20261107135021.816968530@linuxfoundation.org>
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

From: Stefan Metzmacher <metze@samba.org>

[ Upstream commit 7193241a49c958782ba4b8df06da3734d1e317d2 ]

When a remote buffer descriptor is larger than the remaining local
buffer, smbdirect_connection_rdma_xmit() clamps its length and sets
buf_len to zero. The common accounting code then subtracts the clamped
length from buf_len, causing it to underflow. If another descriptor
follows, the loop processes it with a wrapped remaining length and
includes memory beyond the local buffer in the RDMA transfer.

A client can trigger an out-of-bounds kernel write with an SMB WRITE
request, or an out-of-bounds kernel read with an SMB READ request, by
supplying multiple RDMA buffer descriptors with an oversized descriptor
before the last one.

Remove the premature assignment to buf_len. Subtracting the clamped length
already consumes the remaining buffer, so the next iteration stops and
only descriptors within the local buffer are used to build work requests.

Fixes: e628bf939aaf ("ksmbd: reduce descriptor size if remaining bytes is less than request size")
Cc: stable@vger.kernel.org
Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-33549
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
[ metze: in 6.12 the code is smb_direct_rdma_xmit() in
  fs/smb/server/transport_rdma.c ]
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/transport_rdma.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 585617595727b..be26c2e569e57 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -1388,7 +1388,6 @@ static int smb_direct_rdma_xmit(struct smb_direct_transport *t,
 		if (desc_buf_len > buf_len) {
 			desc_buf_len = buf_len;
 			desc[i].length = cpu_to_le32(desc_buf_len);
-			buf_len = 0;
 		}
 
 		credits_needed += calc_rw_credits(t, desc_buf, desc_buf_len);
-- 
2.53.0



