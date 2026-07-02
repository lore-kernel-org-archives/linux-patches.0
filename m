Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72CAE3A7193;
	Thu,  2 Jul 2026 16:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010649; cv=none; b=aH9CIVz3M43XvnTbo+GZ4QR53/iQNLGyF7mfABQz6IXor2U+GnC3wkW+xvA18xpQ2rnfsgWVqu2L1gI6O2M8Qd0/IJzfEPnOvzIi/Q6J5Ljf5nVkJOiuSJNG6Ujwl7ZdP/lWo2v5/63zFxo/Y/WJq3GwnytyCwyzBJCUod4BVRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010649; c=relaxed/simple;
	bh=aLVpGalc21GG4JO0k4RuIfjb/B0IOvpNUiYVfvo7VJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tYars+UXKrCStC2eVEB527GAj19/I5SPuVofh35Xzw6tba2Q3PLmannf7AWCiHxl4Ff+kWcOHKbIgQW+XiGEL2CA6m+PkDgB/+qI/UHz5cRAb9RlU825k8GH4dJ0XG1fJAxJKiVEsNkCXW0f+fIM/iGpAzXF7jiW9upz3JycwIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G8ytFW11; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G8ytFW11"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 811F11F000E9;
	Thu,  2 Jul 2026 16:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010648;
	bh=x9OCn2NT1ljpSQ6ZeuTM16HXA8V5b74N2AdebxQWg0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G8ytFW11Tpqc38Ry9o9CNXbsDuIF2ooPkFyVvEz7wOF0j4Axe+Uo0SKtrDKmwIbBe
	 X/v5z56X0MIXYEQjHAifgpQJOC+0vO5DnEi3siW5k0pZ57exZC4hpfXLjzl5k58OGq
	 4EV68QXSkCu/zJm5IblIJo2DOgiyyF/QEE7IDPfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.12 188/204] nfsd: avoid leaking pre-allocated openowner on unconfirmed retry race
Date: Thu,  2 Jul 2026 18:20:45 +0200
Message-ID: <20260702155122.600331088@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

commit 57aee7a35bb12753057c5b65d72d1f46c0e95b07 upstream.

When find_or_alloc_open_stateowner() encounters an unconfirmed owner, it
calls release_openowner() and sets oo = NULL. Control then falls through
past the `if (oo)` guard -- which would have freed any pre-allocated
`new` -- and unconditionally executes `new = alloc_stateowner(...)`. If
`new` was already allocated on a prior iteration, the pointer is
silently overwritten and the previous allocation (slab object + owner
name buffer) is leaked.

This requires a race: two NFSv4.0 OPEN threads with the same owner
string, where a concurrent thread inserts a new unconfirmed owner into
the hash between retry iterations. The window is narrow but repeatable
under adversarial conditions.

Fix by adding `goto retry` after `oo = NULL` so the already-allocated
`new` is reused on the next iteration rather than overwritten.

Reported-by: Chris Mason <clm@meta.com>
Fixes: 23df17788c62 ("nfsd: perform all find_openstateowner_str calls in the one place.")
Cc: stable@vger.kernel.org
Assisted-by: kres:claude-opus-4-6
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -4971,6 +4971,7 @@ retry:
 		/* Replace unconfirmed owners without checking for replay. */
 		release_openowner(oo);
 		oo = NULL;
+		goto retry;
 	}
 	if (oo) {
 		if (new)


