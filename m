Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85803264616;
	Thu, 17 Apr 2025 18:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914851; cv=none; b=sxLPyL3bL7b30RkRewBw7bM8DqBBZvIvIuHAWg4J8c/+W7BNhjNKyakmxpIWeERaxNRmZnB3YHPPRgY0cPCXDIHYdTW8gGcUObWwAT4VNqJsmxIrk5e0jwSEensXGW+BwtSRD5xAVcpXNTe7l/Hg5Cvm91m5skGOZCO5+An4wog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914851; c=relaxed/simple;
	bh=7eFA+rwOjWqEtajrlKJdVj/UtvLGuVdOvAijzjCpCeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CmJevAp6nreZMmL2aCB10uO4QuNFfVhMPCSLz14t0mwSxDlgGlzGzFtYrBzWkoJ1WHyCxyguG+NgnXeVB2f9nZdqdWF4/BUF6KWGri4F7oonplw+y9wqB5EQ3FOUcli20b7DbsUr2EsvyKDV97/l+ZIaVemdiKCdNxytGwkQzfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mHsia32H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mHsia32H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F031AC4CEE4;
	Thu, 17 Apr 2025 18:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914851;
	bh=7eFA+rwOjWqEtajrlKJdVj/UtvLGuVdOvAijzjCpCeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mHsia32HgJJCbhGj0dkL30cyL6rXebn/za4QubzgBB/zxy+18wza+M2KPGYZsfeXa
	 TVTLaRh2/5So0YJsmQJdA/FV5/eZVQbLREAfVr55sg+Bi+uzSTpEEDQ2+57K29YMB+
	 ZMiUpsRbBYGihajikrt38t4hNFbIVrHqA8jJDzcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>
Subject: [PATCH 6.13 352/414] dlm: fix error if active rsb is not hashed
Date: Thu, 17 Apr 2025 19:51:50 +0200
Message-ID: <20250417175125.603188356@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Aring <aahringo@redhat.com>

commit a3672304abf2a847ac0c54c84842c64c5bfba279 upstream.

If an active rsb is not hashed anymore and this could occur because we
releases and acquired locks we need to signal the followed code that
the lookup failed. Since the lookup was successful, but it isn't part of
the rsb hash anymore we need to signal it by setting error to -EBADR as
dlm_search_rsb_tree() does it.

Cc: stable@vger.kernel.org
Fixes: 5be323b0c64d ("dlm: move dlm_search_rsb_tree() out of lock")
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/dlm/lock.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -741,6 +741,7 @@ static int find_rsb_dir(struct dlm_ls *l
 	read_lock_bh(&ls->ls_rsbtbl_lock);
 	if (!rsb_flag(r, RSB_HASHED)) {
 		read_unlock_bh(&ls->ls_rsbtbl_lock);
+		error = -EBADR;
 		goto do_new;
 	}
 	


