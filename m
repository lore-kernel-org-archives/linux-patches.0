Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FDBF25178E;
	Thu, 17 Apr 2025 18:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744916056; cv=none; b=rvWX6QdZJ3dhcErqbGDS5fNYX1EVNBSXumwUB2pTFYF3525ccyTij4K83u6fELN/dPzFEaV56bShgnOgjPsuz+b+ccv1uc89sw8Twep0kNNDAvX0DX2XH97tNUlJeFBkPyboZJ57/enQ2uYLSrRYoCxB5mI+jByIkW8pMeInIkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744916056; c=relaxed/simple;
	bh=9VOGXkIDsn46C8ckpzyfQ3GMTruhjFdKyQs1WcyIsXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TxBPA1hZXRlW8MBnHnR3qv599hicsmORyfuy4z+gW3RB3crCfmOf72fhcIllGJFqFMROPtSEqj+20HO7ydq9OhNXR3dPFSpD/AMXxXvQZxQYOY3mLB0MXzN5JKURFSjjrAT48MfEnwNrQnQeEEEcy0d7FIOYnQCgAJi5efCIb9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ujpwQ9V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ujpwQ9V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AD70C4CEE4;
	Thu, 17 Apr 2025 18:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744916056;
	bh=9VOGXkIDsn46C8ckpzyfQ3GMTruhjFdKyQs1WcyIsXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0ujpwQ9V9anF1cl0EwvNAfNgBRM8yx99o6NPVpaoFBCdhpXdUCQTy3TlAhUeJaKeq
	 A5Sgz1+F8+zQRLO1KIGeUZ02TKgDLddWulx56rQ6//cTZpv7ViFGslO06LijgiPXNE
	 gAU0MxpecZwJjfKpunJvJyzMZit7DHrJcLyHs3FY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>
Subject: [PATCH 6.12 329/393] dlm: fix error if inactive rsb is not hashed
Date: Thu, 17 Apr 2025 19:52:18 +0200
Message-ID: <20250417175120.841784208@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Alexander Aring <aahringo@redhat.com>

commit 94e6e889a786dd16542fc8f2a45405fa13e3bbb5 upstream.

If an inactive rsb is not hashed anymore and this could occur because we
releases and acquired locks we need to signal the followed code that the
lookup failed. Since the lookup was successful, but it isn't part of the
rsb hash anymore we need to signal it by setting error to -EBADR as
dlm_search_rsb_tree() does it.

Cc: stable@vger.kernel.org
Fixes: 01fdeca1cc2d ("dlm: use rcu to avoid an extra rsb struct lookup")
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/dlm/lock.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -784,6 +784,7 @@ static int find_rsb_dir(struct dlm_ls *l
 		}
 	} else {
 		write_unlock_bh(&ls->ls_rsbtbl_lock);
+		error = -EBADR;
 		goto do_new;
 	}
 


