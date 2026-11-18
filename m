Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035645;
	b=qyZimubv8uid29pAU75R4shrYjNgyKJqiSo5RfmEoZwDC6EHtpCUm4tHR9vGc/xiafpi
	 XxeN7ElTrvG8/qExxI/l61Ko85ZztJvQina45ZcuKWP754/k7BElR3n39ag1/oPxMBFrT
	 8gnJeSuxyQPbmVvbGTmcNuX0zwbzjI5mg+jKufqdBoRMgr1PwgvD2jVD2AfoKtkXUBoEt
	 zccKnznbAy4ilDpTliS4S0LYlEUwMpuec0HVyI/EEiYkVwIMHtbuDmGYSfi8LkQZoL1Vt
	 g1NhMN/MRZXKRuvk650bJRteTIBvS5wCvCLF0TLu16IAvcFcLUJoPi3nkusrBLP67GQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035645;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B3S6nAi7o0DQg36ns4xjkxos+7qpw8ZHpXRxURWH6YA=;
	b=bWGcuLdf6zzVEMGg0RHbgjwLyx6hoEpIL+EHylyqHClXIwyDrV0faA1t65dnYPksoHxs
	 4UI0aFJBFuFJNe+oD+FOp2F6c3m2IiVJF7ZufIqin2/67KtFgK00IBx7vZQq6dlx3+fiL
	 PZLUERpnyOTW3UfVfQqgAh4vp/quCo9o7VhEMUTz+PcHF8pGBB3+tnPwEP+aZAX4DdbMV
	 hSpkuvzheHkAzxUPMekTo+mp1hC7VjV7UVp4Ica2P7d11cm/ZJT/3q4FZ+P97XqW98UBh
	 DHYYvvFlTvPh2NczF+Ozc5/7b3FmJ+D/YhLxh5b7bRGebgja1ctBVg92t1jjEnkPp2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gGncOmRZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523A4606A31C;
	Wed, 18 Nov 2026 21:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gGncOmRZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0DEA1F000C7;
	Wed, 18 Nov 2026 21:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035645;
	bh=B3S6nAi7o0DQg36ns4xjkxos+7qpw8ZHpXRxURWH6YA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gGncOmRZA3QYSRkEsVAmZHabevwXV/CLRg1oYk1kp4ctuYcU2BNt09Gm3e1bcFXY/
	 QRrvXoP4TVJfNLtUAxadD75woI2+UatcTvlUhAQYqLH2/0NBxJt3pHENR4HFakLdzp
	 sFdfBWU1bQA1wWaitSJkUz9icX18pwvexORVwOjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Metzmacher <metze@samba.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 6.6 0776/3318] smb: smbdirect: fix buffer length underflow in RDMA transfers
Date: Wed, 18 Nov 2026 15:23:18 +0100
Message-ID: <20261118150342.072246987@linuxfoundation.org>
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
[ metze: in 6.6 the code is smb_direct_rdma_xmit() in
  fs/smb/server/transport_rdma.c ]
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/transport_rdma.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 8987b1167a38c..5178c7443ebb7 100644
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



