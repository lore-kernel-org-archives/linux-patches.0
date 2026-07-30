Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A90AB37C92C;
	Thu, 30 Jul 2026 15:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424781; cv=none; b=dTkjGIBVBBC2Y6dnY4gZqDFQ87g9z5NiP5O92Kk/dY2LJI2MNB3zCsV9r9s6GVcK2FFnYLavkKziLscdmHlxEe5FF4ilvkwGGTwY7M0PwbbihYIxuA4fz4uvm0NAjajMzlqKbDNgVAfqU2hnZJrdWmJzI/Dpd8rFPoRNWp+cELc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424781; c=relaxed/simple;
	bh=DkRpqU+aIAk2hNipVrVBhadSns0W4AIHpfctdnxTD10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QqpRgX06X+NmXGD3UFynAKWEv/9So9vtkEzfqb6ZHLFGg9g6GEt+c2DDgpfXvFDlgzL/vgKE10im6SPOx4M8un2D6JIRu/ATKHVODn0I2Ep3AAnHFEJTjY8EN2T+cXit1+jkHflxmsyLd9KhK+xaNw7JBpn8SBZIQ5ZLUpLxYMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hATVqlvv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hATVqlvv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 084801F000E9;
	Thu, 30 Jul 2026 15:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424780;
	bh=bTCy986NjbdpfZIMSN5ghzU5Uu0wPY/+Io/LD19l+S4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hATVqlvvUIcrK/M7lTIP66uUOq7hsA1MguZvqJOt9FMPMgaNcVK5SJJRFJjXFBeto
	 LejXDv5YBHmEPXAPkJxXquKZ3eJKSvYxCL0hVJOQ47rpid2n1IdQ6msfh3VRpe6MQK
	 qym2HiudaqpH9ajNmQ8Yt7JCIS9AaMzL45aHS42o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.18 515/675] libceph: Fix multiplication overflow in decode_new_up_state_weight()
Date: Thu, 30 Jul 2026 16:14:05 +0200
Message-ID: <20260730141456.080951625@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 


