Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7161D0492;
	Tue, 15 Oct 2024 11:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993247; cv=none; b=TswLKwb87kHJ/rqHXwprAYSVZAH71VW6nKs39G4ARhLqImCkVSlSh3JhH4DL01+Ij3yejOJGMWYExge9cs/D+IlnIr+UG9RiolpDQ+4HcuIN84ZSkIaIL881f4D8y2qpR/5PGeCTdclRNhJUWOJ6E+S/p9LnCV/2PkylwfhL1QU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993247; c=relaxed/simple;
	bh=MDvWyOZJ0tjn9eLjMsMpTADLOF76yRPSiXalDXLe3FY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GSPC25rO0u3wO7+pnmJcadbYGyYZALu2FUg2AF74HiY6pawIvAPbkD8YF8zGaJJBJS8ewZwmDdNTdsO1LrbyoYhLCl6E2SfF4Ucm8A1oWbti9WHbGIRVKEoc+P8j4BvoyCpQCPVK4VbwqN5pMr5yPkEbn1vcOpDAufCQ5iKJZYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BRfrAagP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BRfrAagP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42A5EC4CEC6;
	Tue, 15 Oct 2024 11:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993246;
	bh=MDvWyOZJ0tjn9eLjMsMpTADLOF76yRPSiXalDXLe3FY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BRfrAagPq/nrUn0TAgZfLsrv58FuGtPt3DY5AgvL3/Ch2pZ7UNTGZm6dY3LgQsfBc
	 U9Llg9USU88c0vVWu61gQdHCIdWpPLMXnk2yLkfXEHYOchE4Wp/8WufGDGZ+MPEWuF
	 VUrPU+hbyQaRlBCYJG0yiLR/aAmkMxBVV/21+bag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Anna Schumaker <anna.schumaker@oracle.com>
Subject: [PATCH 5.15 347/691] nfs: fix memory leak in error path of nfs4_do_reclaim
Date: Tue, 15 Oct 2024 13:24:55 +0200
Message-ID: <20241015112454.111793153@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Lingfeng <lilingfeng3@huawei.com>

commit 8f6a7c9467eaf39da4c14e5474e46190ab3fb529 upstream.

Commit c77e22834ae9 ("NFSv4: Fix a potential sleep while atomic in
nfs4_do_reclaim()") separate out the freeing of the state owners from
nfs4_purge_state_owners() and finish it outside the rcu lock.
However, the error path is omitted. As a result, the state owners in
"freeme" will not be released.
Fix it by adding freeing in the error path.

Fixes: c77e22834ae9 ("NFSv4: Fix a potential sleep while atomic in nfs4_do_reclaim()")
Signed-off-by: Li Lingfeng <lilingfeng3@huawei.com>
Cc: stable@vger.kernel.org # v5.3+
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/nfs4state.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -1949,6 +1949,7 @@ restart:
 				set_bit(ops->owner_flag_bit, &sp->so_flags);
 				nfs4_put_state_owner(sp);
 				status = nfs4_recovery_handle_error(clp, status);
+				nfs4_free_state_owners(&freeme);
 				return (status != 0) ? status : -EAGAIN;
 			}
 


