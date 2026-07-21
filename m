Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE7D1471268;
	Tue, 21 Jul 2026 20:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664644; cv=none; b=mDClI3UgALZ8II46lDxPX6rYqFW+VeSD9lWzo8fWfGkYSSY4R/+fuLmy7M251k7XND2wG/sZf4hctEna6FjHhO+v2bGTT8oNnCkeBDoawSzfWWNLRPBSrf+P15qd8vtdDHkBZENAEWI/Wk9U+xuILZIAh+MgvzUbdqOxlDNdmcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664644; c=relaxed/simple;
	bh=xXE4E9JkMpbvZ/e5aFAg0HK2KcHz1KiRnwEQcrIFOeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SMJYw3vE+hOf7lCK4WKi87uH6i3HgxWWBoVsj4tnlWIYa5gP7JFeAD4S0BVD5BZ6kLX8WhPzYViM2rcNp+7p6413Hx1FuDVfeBVDhFa2/bB0KntSBhCVdh8BG7I9oEcj/AfdbfqQ19LhL5On3wS77h5wlY+PR2EkpK8ML3A8P1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aEPMka2k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aEPMka2k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E62821F000E9;
	Tue, 21 Jul 2026 20:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664643;
	bh=kGfellh3JPp89lJmf7VVw1rKFEcLfemkQ6+MBHz39vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aEPMka2ktVOr/lLxFFf0398xSuo9ALT2znkMk9aUjHGFgUkJgT2oN/4K2XIxZGdLP
	 c6nfQN3zUpkm5mmT1TgkB7E36Ed+Z7awQKxzZX9TATCPMCprDX9ousTE1FFqsC9BiN
	 tnabwhnzlj/TNul71IVOzKYcllC8MKMOApjrI5Cg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Federico Kirschbaum <federico.kirschbaum@xbow.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Baul Lee <baul.lee@xbow.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 1248/1276] dibs: loopback: validate offset and size in move_data()
Date: Tue, 21 Jul 2026 17:28:11 +0200
Message-ID: <20260721152514.025785580@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
[backport for smc_loopback instead of dibs_loopback]
Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/smc/smc_loopback.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/smc/smc_loopback.c
+++ b/net/smc/smc_loopback.c
@@ -245,6 +245,11 @@ static int smc_lo_move_data(struct smcd_
 		read_unlock_bh(&ldev->dmb_ht_lock);
 		return -EINVAL;
 	}
+	if ((u64)offset + size > rmb_node->len) {
+		read_unlock_bh(&ldev->dmb_ht_lock);
+		return -EINVAL;
+	}
+
 	memcpy((char *)rmb_node->cpu_addr + offset, data, size);
 	read_unlock_bh(&ldev->dmb_ht_lock);
 


