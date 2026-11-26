Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705249;
	b=AWpoD3w5qVdYl32i3Syo+Rrqh56F4rEf2Wj6nR9WFj4774s2rHFB5rHihC12Myaop3KA
	 eCodDQ9591onKON7iA5eWPGDji41QFvifTjqaTNqjTLjp5bAy/UrVdb0Wh6RK70ZUT769
	 8srazS/sgZ4DnwtKUgvdx1J3jlHou4Nrrnep3/cjkzN+bJU/HVu5o+UeASRO0UQa68mDp
	 9oskB7ykD9ENafXMOCnqyRSDNCBTR3h7GEPiwwh/3KUm3xyaW2EbbJZ4YlcwiOCWpy1Iu
	 0nHo3EgEXVEkd86vl3hyiyT1bJH8bxDvfP2VzBx2lum1/ScywlQk0w0BgVDYOlw192w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705249;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cKzH43BmDQ7vQeIla6YvtPV9QcGzrtewiBQH4XvPYeo=;
	b=cr/YbedryJkisj2xTDx8MgDKl577sQkj/1iDCATkHKjzP9CoVmDJ6jh7/F2nMGs2B5MW
	 rPMV5NRs0MKe/sRx/zs2MuoAX2VXjH07UjH8+So3VH7laA+8ag2/8YDw5ZVCFBJ5Pp/P/
	 q/99sTAIobKm5O5onqENcu3UCy0jNUCMWCn4DueYUW2lOOdtdZtHcR10HSpX4pj9P3yv6
	 lvtLUS97GWAdsMyaZnlxzFams1Pn/wFmMyxGA+gD9s9TuaciPgko5bFfr5hNN8nzLHTGq
	 9wlWtz5GORBb7C6mYajn2gV2RDsCd0vaPHj/mnjpCb7EalIHYOhv/rBHlVCgfiBFU3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K6qa2xdS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF70C606A31E;
	Thu, 26 Nov 2026 15:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K6qa2xdS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A76851F000C4;
	Thu, 26 Nov 2026 15:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705249;
	bh=cKzH43BmDQ7vQeIla6YvtPV9QcGzrtewiBQH4XvPYeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K6qa2xdSWa9YuAyoUdvt2+22ilbEFbEIYy4IGlc7sn+pwRXjCBV/skeqXoso/fWa7
	 n4rrcgqXkpiBbRxMVDjqTVpjO9J1Rehxh+peXdfT/8SGMKpaMMv21ZSibBeWG7g2d+
	 bJB2/c+VL/oZoyN7RW5Etf46+JrPYR4zKJsgUtck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 136/319] NFSv4.1: retain MDS I/O until both thresholds are met
Date: Thu, 26 Nov 2026 15:38:24 +0100
Message-ID: <20261126144009.815984386@linuxfoundation.org>
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

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit eab627dcd18a18a44a2cbee47df3058d3637ba0d ]

When both size and I/O thresholds are configured,
pnfs_within_mdsthreshold() uses size && io to decide whether to
keep I/O on the MDS. Both variables indicate an unmet threshold,
so reaching only one threshold returns false and may trigger
pNFS layout acquisition while the other threshold remains unmet.

Use logical OR instead of AND to stay with MDS I/O until both
thresholds are met, as recommended by RFC 8881 Section 5.12.6.
The new RFC contains the same threshold selection rule as RFC
5661 which is referenced in function comment.

Fixes: d23d61c8d351 ("NFSv4.1 test the mdsthreshold hint parameters")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/pnfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index 6d53fe9eb9a69..9866ae5366ee7 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -1900,7 +1900,7 @@ static bool pnfs_within_mdsthreshold(struct nfs_open_context *ctx,
 		break;
 	}
 	if (size_set && io_set) {
-		if (size && io)
+		if (size || io)
 			ret = true;
 	} else if (size || io)
 		ret = true;
-- 
2.53.0



