Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55BBB3D349F;
	Mon, 17 Aug 2026 15:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979509; cv=none; b=YjmZSiR6XZbPl3szQkhoNMxnBF8GT9B7yq6VE8LVnf99cpiqjWvR+f0ZzDkHbiTi7NUX1yPI0+kJWQf8EmLcoknN16wSWY8NXWEYbZY0YhaKVA3XIKAQbZV6+BMJ+mfNcShdAo3a6hmx8QeQi2Vm3VXhJb1XbL2HltViKDyga5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979509; c=relaxed/simple;
	bh=2drcToBUZ7zfOqjl+iYWnBLTS94JBfzrGyDoHRaQwRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nh7RTheSZ2jMGMTqnv+KfjOSuHi1tZyr+IrGUApiP5wCcICGMUlgbiSl0mE6+YIhzDh2N6RTzRb3Bwct5/kwGR9jhqzXm/YT5llDtFhInpjMQmsEbK3xpb5rfortSuPX+kEWhc5XEm7kvhJKle+hEXsypzDPp80TgTnyuTr04hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pavxHT+z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pavxHT+z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0FDA1F000E9;
	Mon, 17 Aug 2026 15:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979508;
	bh=jp9qxoPLh+stHrS6vXyadIIhROUeXF3khpIj5evRWtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pavxHT+zUN42kJiScNBXRTbF25P9Ht4N/vZtljkb4PHaC2JRmGE8ZCUa8yH4XCzoy
	 IBx296tze4wAYanb5MNSEnptPqxAKgpPA7ZCBRcADX9NE1lluM5tLHotozGA6ogPCw
	 FM2RMIbXV+XNHLDpvDGWjSdThkfmCQP6apgWaBd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.1 251/609] libceph: Fix multiplication overflow in decode_new_up_state_weight()
Date: Mon, 17 Aug 2026 15:29:07 +0200
Message-ID: <20260817132552.492031584@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1844,6 +1844,8 @@ static int decode_new_up_state_weight(vo
 	void *new_up_client;
 	void *new_state;
 	void *new_weight_end;
+	const u32 new_state_item_size =
+	    sizeof(u32) + (struct_v >= 5 ? sizeof(u32) : sizeof(u8));
 	u32 len;
 	int ret;
 	int i;
@@ -1864,7 +1866,8 @@ static int decode_new_up_state_weight(vo
 
 	new_state = *p;
 	ceph_decode_32_safe(p, end, len, e_inval);
-	len *= sizeof(u32) + (struct_v >= 5 ? sizeof(u32) : sizeof(u8));
+	if (check_mul_overflow(len, new_state_item_size, &len))
+		goto e_inval;
 	ceph_decode_need(p, end, len, e_inval);
 	*p += len;
 


