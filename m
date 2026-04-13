Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 343F324DCF6;
	Mon, 13 Apr 2026 16:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096344; cv=none; b=nR/d5BQs5zSrh63R+JBhU07IYRJLe9JyysfdtrQZ6aQHKKRI4yD7FIYY40EeXzombqzhQslYELaTsUBoTakOgblmZ8R6VuBAd+kobNhP43sY3W1hAZewwFvGqaMbFNRzVtRVpqYVveMbo6huR5p1XHS6yMgwdbwTK3wRRKvIWCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096344; c=relaxed/simple;
	bh=BUjDVny4N5nfXZJwZiY7/g1kGxUMEDMH/jqnE6ECPx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Piqwyvp4svlcgq/gngsb7DQt2elkR/PFnXZUVj4yfeW8YAhs8iWGa/NezulNbYr6r6I9uqc2LOdslJxy4trLdcA8HcJT1Gvnj5ORWxrFGtEt0tazkNbDEiRsRWvUHAqSw5A10mVyspIiKGG1jW9bqAY6GH4P1QKwgV6ImhcWAIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mXAl/5H/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mXAl/5H/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B50B5C2BCAF;
	Mon, 13 Apr 2026 16:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096344;
	bh=BUjDVny4N5nfXZJwZiY7/g1kGxUMEDMH/jqnE6ECPx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mXAl/5H/J8lgiQHP4nzY7BpYI59diAPxGXEgkv1BGT1YegrP8WIO1XRQCzNYeDB/T
	 mNz3jt/U5ty/rpuc8Y58mEjx/kjns19S+YlpeXixaydjRubXuw1ORG0pm6dbXuUQkB
	 vVi45HLZ2jG01fXzMXzA2CgqIhk+6zAk+q6FgAHE=
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
Subject: [PATCH 6.19 60/86] idpf: improve locking around idpf_vc_xn_push_free()
Date: Mon, 13 Apr 2026 18:00:07 +0200
Message-ID: <20260413155733.803128712@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.568515178@linuxfoundation.org>
References: <20260413155731.568515178@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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


