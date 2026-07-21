Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03FA73264FF;
	Tue, 21 Jul 2026 18:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659273; cv=none; b=pQlM7s8Sz7KaVNNZD3eZlhV0T+B/zstuM6Nc/QVG5GJ5QWhMqy2Oj8QIpBcOv9MBsEYQ+b5KnwgWuhftM9B3yviimwLCqO1psqxEEbhVcNpaKYESxmMc/NAh5iyDfheAhhrlw9vkurHCq7llCbeHE6fLInttmctqRwRO7hd+qPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659273; c=relaxed/simple;
	bh=PONMa2t8BS3Xx2ettbVp9eAidZJPU7pg170H/25yxFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wz+jFn0I5OZer0FM0oPVsZXJ4/Q2Fhxnz5Lk0lx9KghGnwJVJJDhSh1WO+dyJNYYHzGlXkZ2ub5YyAqJARDKkn+Iw4CE7f1inXkQsZLOrSi2ti1mVjmPi3LMKPS5RjMvecUBrfxSuLRpIMVUgkkTRHmpG175w3MRTjJKDewJfyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=njdIAGRU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="njdIAGRU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 646BB1F000E9;
	Tue, 21 Jul 2026 18:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659271;
	bh=N5GAVE1l2YASYNy8xIlTlgeOF5OWk9JmhV10tdfeWOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=njdIAGRU92SBJ4cHhOAa4dTFR+mpBuXP6uMjwrMAx414Qj/Cxouk934e9OWom+crj
	 6Fyz6Tl6jR9a+szxnphmXEEDwFIPIZZCH0UCXDjy2Cb/3gYTHbdm2iwDLFD2PVV6yP
	 nkNIBaAWxANCebNp9/YXF19/4ck/2ZdFDhx5rM20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Federico Kirschbaum <federico.kirschbaum@xbow.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Baul Lee <baul.lee@xbow.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.18 1458/1611] dibs: loopback: validate offset and size in move_data()
Date: Tue, 21 Jul 2026 17:26:14 +0200
Message-ID: <20260721152548.241240419@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Dust Li <dust.li@linux.alibaba.com>

commit 78237e3c0720fcc6eb9b87e90fd70f63eeca886f upstream.

The loopback move_data() performs a memcpy into the registered DMB
without checking whether offset + size exceeds the DMB length.  Unlike
real ISM hardware, which enforces memory region bounds natively, the
software loopback has no such protection.

A peer-supplied out-of-bounds offset or oversized write would result in
an OOB write past the allocated kernel buffer.  Add an explicit bounds
check before the memcpy to reject such requests with -EINVAL.

Fixes: f7a22071dbf3 ("net/smc: implement DMB-related operations of loopback-ism")
Cc: stable@vger.kernel.org
Reported-by: Federico Kirschbaum <federico.kirschbaum@xbow.com>
Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
Reported-by: Baul Lee <baul.lee@xbow.com>
Link: https://patch.msgid.link/20260707074318.1448662-1-dust.li@linux.alibaba.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dibs/dibs_loopback.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/dibs/dibs_loopback.c
+++ b/drivers/dibs/dibs_loopback.c
@@ -254,6 +254,11 @@ static int dibs_lo_move_data(struct dibs
 		read_unlock_bh(&ldev->dmb_ht_lock);
 		return -EINVAL;
 	}
+	if ((u64)offset + size > rmb_node->len) {
+		read_unlock_bh(&ldev->dmb_ht_lock);
+		return -EINVAL;
+	}
+
 	memcpy((char *)rmb_node->cpu_addr + offset, data, size);
 	sba_idx = rmb_node->sba_idx;
 	read_unlock_bh(&ldev->dmb_ht_lock);


