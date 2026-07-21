Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECCA046A61E;
	Tue, 21 Jul 2026 17:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655165; cv=none; b=rH9Y+j1oejc1NFK5/nLVB6J2HSYfI4tn3TpPTnybxL0W16WR3P8D1fugLHG4ARTU8a4VObk9685v9Ed1H41imsDSH/SL0fZxsFS+6MGodgZCpBHUxu3RH9NFHxxHybjVHJLqqow06f0+HJ9PLpOH9UmXykJ5J6qM0RCe1DYL0kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655165; c=relaxed/simple;
	bh=69tkjuNKh8OkgP9Hv+5YUs9FE7JEnpiIC+OKsBONN/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E0xSgIRJmAx1x70lxIf0KCn1cJXxjxy6LJNI0cRBQOk+6Ljtd76Ebjfxfzv+zCKwZSeVOo8ZcXXS1cKODGYdscaLfIVmucoG8nHQLxW7cZmR8qsCvdyKO7MuJWvXaTRzGStJJXcmXHZnhor8HvJJW71zwLCn1eZ6Xzlm1cQNCyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E5rdqAIh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E5rdqAIh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F8671F000E9;
	Tue, 21 Jul 2026 17:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655163;
	bh=qfarVPbzMDR0tfy7MW6BKqnyoxlPyu6OkL5YgHBhE+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E5rdqAIh5TcVnhNDHZRIuQvlyGu9l7D39xu2ioInvIlQE9FnJ0qroB/QR1kKyFuMk
	 PoAmvtvEFbMfxQaSymIIHnoJ6+8a8ii4aoIf6IRrqOpJ1FR2kXYphuKSD+mXeZI1u7
	 1w0qE1g2jB5slL50D+NEnaCGbN4zFUaw9Tc+CzsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Federico Kirschbaum <federico.kirschbaum@xbow.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Baul Lee <baul.lee@xbow.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 7.1 1978/2077] dibs: loopback: validate offset and size in move_data()
Date: Tue, 21 Jul 2026 17:27:31 +0200
Message-ID: <20260721152639.362860915@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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


