Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AFF524DCF6;
	Mon, 13 Apr 2026 16:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096555; cv=none; b=j8BLNga1fGtvp4Ep75mWKOipKncuqzEOInQKhz8mJs2LXC2ydC5j226j4CEMm98iaYBWxaWvetMAJNOoiEoS4KDMN9SZuCXi/dHDqY3wpJzaiMQNYsAvrLQO5fPd+hW+mpm+tia1jxkRnWUm6Oh+9Uh3kbKnuuV7RAZH9OYqGnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096555; c=relaxed/simple;
	bh=7Fxi3v2dpNMPP+C781lTCJP0EA4OnGJ5p9MbZpVCKA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tRNiTYwhAa4OFmvMvpzY9DL7eJSSq00Cj1Tk5MyOVZ1iAbHHp/2ZcJJdc1HZyoB55Xp9BqfpZiFfiLK9wuyzv2z9lXuMD5DtyWo2HF6GpmDMLLwjxHrQoa6h/s/CnouwIWwCFsU4SM9B9cHm2cit5Qn899Ieh7EjlCTy9hNAWiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eLXOxDHo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eLXOxDHo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF24C2BCB0;
	Mon, 13 Apr 2026 16:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096555;
	bh=7Fxi3v2dpNMPP+C781lTCJP0EA4OnGJ5p9MbZpVCKA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eLXOxDHop5fo58BGYkF0FFGMfVvNeMm+8IzeACU0RS/lK0hgGYLU/fHlfWheFbYJC
	 pVG1941EZdbyhHJBKbIC2How5Vn/fZtM+lAjktk3Q4jt7mMw8GmaMIeHH/r/hrCcmL
	 51sMIM2IXNazFWGO3PfgtsxpVE0avgR0o3Ab1/xY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ray Zhang <sgzhang@google.com>,
	Emil Tantilov <emil.s.tantilov@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Samuel Salin <Samuel.salin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 6.18 57/83] idpf: improve locking around idpf_vc_xn_push_free()
Date: Mon, 13 Apr 2026 18:00:25 +0200
Message-ID: <20260413155733.143004839@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.019638460@linuxfoundation.org>
References: <20260413155731.019638460@linuxfoundation.org>
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

From: Emil Tantilov <emil.s.tantilov@intel.com>

commit d086fae65006368618104ba4c57779440eab2217 upstream.

Protect the set_bit() operation for the free_xn bitmask in
idpf_vc_xn_push_free(), to make the locking consistent with rest of the
code and avoid potential races in that logic.

Fixes: 34c21fa894a1 ("idpf: implement virtchnl transaction manager")
Cc: stable@vger.kernel.org
Reported-by: Ray Zhang <sgzhang@google.com>
Signed-off-by: Emil Tantilov <emil.s.tantilov@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Tested-by: Samuel Salin <Samuel.salin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/idpf/idpf_virtchnl.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
@@ -399,7 +399,9 @@ static void idpf_vc_xn_push_free(struct
 				 struct idpf_vc_xn *xn)
 {
 	idpf_vc_xn_release_bufs(xn);
+	spin_lock_bh(&vcxn_mngr->xn_bm_lock);
 	set_bit(xn->idx, vcxn_mngr->free_xn_bm);
+	spin_unlock_bh(&vcxn_mngr->xn_bm_lock);
 }
 
 /**


