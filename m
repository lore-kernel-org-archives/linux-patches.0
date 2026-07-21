Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C24B046D2A4;
	Tue, 21 Jul 2026 17:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654042; cv=none; b=kC6hPW18S4yh0/vGTfq4ysxgpvHluEtttepiIzApVRB4lqd39BIJFWAhzzuoZ2Aiu+giIVH3yJCWEyA4a6WgOjjPVWenJ75miDc561cEfLnuxA/A0XBsEfrMEm7kGzinHptSCFn49HWipJ+M3+VkIYeBehBemjUkm8z+pVtYrFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654042; c=relaxed/simple;
	bh=zu6HOVWMHopMYj8aSaHGIZ6IdNZQ142Vj72H3N2RHXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iIAgorPOrIBsLN/yL4B726biBOpK64yZFp0DXHJZS92ZEp0KcmVRPd+cIUmJrrj06MWPRqkkO2+HfseqvD8Glx4QR2jRvSJwWzkSkS5C5y1BTkXdBk4hDOwbiTG8FPBsdEdHKbL0E3mdEQKTDyu+DQiPfIxc41sSN7pPD/48Kfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QKZqEHqI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QKZqEHqI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 336CB1F00A3A;
	Tue, 21 Jul 2026 17:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654041;
	bh=HRb7mmFqiKDE+bQWx59jmTyX+CSJoF6QmroJG7Jb0eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QKZqEHqIOp4OCEWNZ5LolNUVT5j9VW9jg/kYZbM71AsgWm872YirQJxkfAcDZUYg3
	 oeMTHXwivSe4uoFV/jg9IFeiO9XzecvxX3lIGLrbSM4njWgHNH2hCE4DhmgjlKLQEU
	 UvylqW5VQ5XymMQoNJFSj+hcmwJZ1Ppi0ih4+lFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH 7.1 1554/2077] KVM: s390: Silence potential warnings in _gmap_crstep_xchg_atomic()
Date: Tue, 21 Jul 2026 17:20:27 +0200
Message-ID: <20260721152629.429338826@linuxfoundation.org>
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

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

commit f79413b2dde10829a1b526543e725dd5c1847e9a upstream.

While dat_crstep_xchg_atomic() is marked as __must_check, in this
particular case the return value should be ignored.

Silence potential compiler warnings with a pointless check, and add a
comment to explain the situation.

Fixes: d1adc098ce08 ("KVM: s390: Fix _gmap_crstep_xchg_atomic()")
CC: stable@vger.kernel.org # 7.1
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20260611104850.110313-2-imbrenda@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kvm/gmap.h | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kvm/gmap.h b/arch/s390/kvm/gmap.h
index 5374f21aaf8d..20881e3ce9d8 100644
--- a/arch/s390/kvm/gmap.h
+++ b/arch/s390/kvm/gmap.h
@@ -279,7 +279,16 @@ static inline bool __must_check _gmap_crstep_xchg_atomic(struct gmap *gmap, unio
 			gmap_handle_vsie_unshadow_event(gmap, gfn);
 		else
 			_gmap_handle_vsie_unshadow_event(gmap, gfn);
-		dat_crstep_xchg_atomic(crstep, oldcrste, newcrste, gfn, gmap->asce);
+		if (!dat_crstep_xchg_atomic(crstep, oldcrste, newcrste, gfn, gmap->asce))
+			return false;
+		/*
+		 * Return false even if the swap was successful, as it only
+		 * indicates that the best effort clearing of the vsie_notif
+		 * bit was successful. The caller will have to try again
+		 * regardless, since the desired value has not been set.
+		 * This pointless check is needed to silence a potential
+		 * __must_check warning.
+		 */
 		return false;
 	}
 	if (!oldcrste.s.fc1.d && newcrste.s.fc1.d && !newcrste.s.fc1.s)
-- 
2.55.0



