Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905FF40FDB9;
	Thu, 30 Jul 2026 14:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423004; cv=none; b=Xob0WcpdbebFehjU7j64sg5PpCe+QYxrtsdRi0urRGRllWESLhcd8Ee/sMGu236XR31SAF7a2k+KbDIIGFDtR2JMB9yvRTl2HsLDi6ltxxo36M2sS5PnJZJDc63C1g6Ci6NXKuLS2sD1F1f3vPcNpA/VAsKMcYEvvCkQBGPe+YA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423004; c=relaxed/simple;
	bh=NdoLw7dC5pGhhUa5McO6pb8tHBKBtAcuZL6aWPPuRno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QRs9VPQIxvPEfx5uov6JnpRwfnoTezrl3nF6IEsGd+lQta8YuwF4rOgWpR6WfiLj3fxJuUdkbNt5bBk3wPFLHMDuDv8GVdTCr9CqUanP74k6G5G0Cvo4UI+ktp+pe5OgMBYHRwjYHDvjU/9NMfEInQ6BkoKE8KCD9ChqjLLtD3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OKIyY2tf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OKIyY2tf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB8FB1F000E9;
	Thu, 30 Jul 2026 14:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423003;
	bh=BBWoqQdZoze+RLG4S6xrY5uDwvHLCeIR2MkMpigmWUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OKIyY2tfFhcOAlBkth8nMK9EBFNPmVHiqTQ8z1Fty4z48vUR0e9wxL4qNIXkVbNWH
	 T7Vn0SjyqpEb6vqYgrnmCyxAxcMBt4guzA9ljHinjtJEJuqxwrHkejtMOKeKFsSknC
	 0mx50k8VuMYriPj1Et8HuJFuj5uMDdj9VQSdMbIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 7.1 631/744] libceph: Fix multiplication overflow in decode_new_up_state_weight()
Date: Thu, 30 Jul 2026 16:15:04 +0200
Message-ID: <20260730141457.687899686@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>

commit 98917a499ec7064c14fc56d180a4fd636fc2784c upstream.

If a message of type CEPH_MSG_OSD_MAP contains a (maliciously) corrupted
osdmap, out-of-bounds memory accesses may occur in
decode_new_up_state_weight(). This happens because the bounds check for
the new_state part is based on calculating its length depending on a len
value read from the incoming message. This calculation may overflow
leading to an incorrect bounds check. Subsequently, out-of-bounds reads
may occur when decoding this part.

This patch switches the multiplication to use check_mul_overflow() to
abort processing the osdmap if an overflow occurred. Therefore,
osdmaps/messages containing large values for len that result in a
multiplication overflow are treated as invalid.

[ idryomov: rename new_state_len -> new_state_item_size, formatting ]

Cc: stable@vger.kernel.org
Fixes: 930c53286977 ("libceph: apply new_state before new_up_client on incrementals")
Signed-off-by: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/osdmap.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -1842,6 +1842,8 @@ static int decode_new_up_state_weight(vo
 	void *new_up_client;
 	void *new_state;
 	void *new_weight_end;
+	const u32 new_state_item_size =
+	    sizeof(u32) + (struct_v >= 5 ? sizeof(u32) : sizeof(u8));
 	u32 len;
 	int ret;
 	int i;
@@ -1862,7 +1864,8 @@ static int decode_new_up_state_weight(vo
 
 	new_state = *p;
 	ceph_decode_32_safe(p, end, len, e_inval);
-	len *= sizeof(u32) + (struct_v >= 5 ? sizeof(u32) : sizeof(u8));
+	if (check_mul_overflow(len, new_state_item_size, &len))
+		goto e_inval;
 	ceph_decode_need(p, end, len, e_inval);
 	*p += len;
 


