Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99AAC1D07B5;
	Wed,  2 Oct 2024 14:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880486; cv=none; b=EbSNgohYYDm03xAAJ6yn3Y6Oem3U3uwI5Epr+i7Cl0WiesrY3bQ/iYB0EAfDJr6ticCk9ziCH4UUf0jhdaNSuV00kboaHBuO0U6lSDNeZorMtsfvzaawxwlDNYfJ6jh6Qk2BbnC5GDX82K+rNrWaTrqggijxce73NYaMihUXWx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880486; c=relaxed/simple;
	bh=yACnrhl5vCM/T/p0jpQQXg+5thdqUxm/zz8u7BlqfbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OutItWb4CR+fIhnWf6aiO4b7+rbeuEUWw06Ja9FFY7RlLtpBo4hScI3auVGuLRSGxt8taSp8x23/GEmh4jDj4OjeUuCb86Y+RE/7+r6e+MXkoZoj0TNY7nzPnOVujzKPRVeBaV+T/0a6zKQSXmECoGqUm7nXIwVKupRBVN5LGCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pj1VHr83; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pj1VHr83"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17821C4CEC2;
	Wed,  2 Oct 2024 14:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880486;
	bh=yACnrhl5vCM/T/p0jpQQXg+5thdqUxm/zz8u7BlqfbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pj1VHr83DfU94J64viJU5e7c5ki9+YBzLfoSUrPe4kHF8rO4bA0M5QTqorLt8fzJ1
	 ILzH3CWJmrFjxuvYVQDBHn2lS6D/bx0/Y9wThsNTAUA3DG2KeCHEEWcRgHexWXOsHH
	 Isaovfbgb/y8j9B88VFOXaUDQedGHdDwWWNXCmVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Anna Schumaker <anna.schumaker@oracle.com>
Subject: [PATCH 6.6 476/538] nfs: fix memory leak in error path of nfs4_do_reclaim
Date: Wed,  2 Oct 2024 15:01:55 +0200
Message-ID: <20241002125811.232940422@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1957,6 +1957,7 @@ restart:
 				set_bit(ops->owner_flag_bit, &sp->so_flags);
 				nfs4_put_state_owner(sp);
 				status = nfs4_recovery_handle_error(clp, status);
+				nfs4_free_state_owners(&freeme);
 				return (status != 0) ? status : -EAGAIN;
 			}
 


