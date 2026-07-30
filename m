Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3DB2DB791;
	Thu, 30 Jul 2026 15:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426364; cv=none; b=LHuH8HuP1hGRW38+E86KGXbXJaUIuzwbIGweHFZ4EL0RFCc9p9/RQuba0IOWK7CjUM+WRPBPiueiPCmgaYtfQ3WQ7fqofFXJXWa/MieBAtxbGzde6KueSCKSsy+punO43a92nxc5WGyaz33dCVhK/2iPOasd9vAOtpUOftlbCbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426364; c=relaxed/simple;
	bh=mqSMq92iGB1N+aJt+pskmogGkq1e9EXIcTpYA7JMyIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=llinbHSdmiUmgjs+bnjBqNYogmXULpSDhCaVRx6SsnQ6ErdywGqjEJH9VWxSkgqGE8PGXrNboVMOO8dsuorfr00kNbxxJaGgPlAKqI24VI/Cr0UWZrz5YrxdktZOcHJyqV+SInlIvsjEcl66qLMzDggHE+RRyFCHxijC1MPpMaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g9551Jhy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g9551Jhy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3B3A1F000E9;
	Thu, 30 Jul 2026 15:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426363;
	bh=x8eflYQfQAtas6FwEEoPmH0iETvwuOsiF6VA95K6g80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g9551JhyXLv6fKmiU2Xzlsk9NsqgIL5tBJHF5ami+Kf1n/VQBU1G+eqnwcChNaR9A
	 fecA/FCqU2WK7lUAjVI32xSIMgDw5s+pfcrWSV/FpZVV/Pr6XXIiKl9pq9oiq9i21W
	 vSl8bN2zqUqJX+Y8Ti4RKZ9qvDLq8jYr16MEPiBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.12 393/602] libceph: Fix multiplication overflow in decode_new_up_state_weight()
Date: Thu, 30 Jul 2026 16:13:05 +0200
Message-ID: <20260730141444.217042023@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


