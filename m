Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047385;
	b=owRMg56ihMhxXrhoGGIR5ku6hWDlPCJY9QhQV/dbqIw6xz6rEd/0U0r/j52/ktikbf/Y
	 WtNwk0umh12h3nAxiVU6tJ09gj1tMW0ra/ppfQtu2xW3PQVJtthQ1yXiGI+9j3BvKlUdf
	 ohNjwTGLBj4AcUZm2k2GcW654SMoaM02vCQV61mfbJzvSYHKvqmJTfl09mKmNpiWNkNlH
	 Ky7lZOuyfUbYDOX/ycLgozwuBiQEbsSG2ggAjJhN/QMpFvZiqcD+efOByFfb4XrF97CtT
	 b1u3aLf10vb5kvA+IqtMtFx810UZ8SmlVxEZqcQOon7iBX5voV4FGdHyxrc8r2GBFbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047385;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wT1sk/rocS/09X5GtzmsQgerD7KqhugCLCLM7jOEUtU=;
	b=wXEyjpcFxE83Am5WwzCkr8vNfekeXq1LMeZ8g9XQ+6Jlf3XoGYWQcBiQxoA+L2rTHW2b
	 AmkwG7f/oOvVal9Ki3M107S/EyDba54XF22maoGwE/01WZCEmXwB7ByI5PUuo9TBxpuaN
	 JicqDclXkfXBiN8L/Jyezg68sr2fr3nmbkcU/y+jzMygvKECX1ntuQbYkZ/M6MIVzh1Uq
	 fgBe/zf31C6qwQo7hi1UCGa7EtmPCG0YyLNqneJZu74PXMM0u2lHbHRrNUXljb9yPNwKW
	 bzhlEMz58yYxumvwuvz6epPRUKMcBR1eO958pS+5SeNKDamt2Ejmj10jSKMbSZuuUZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y5fjro6A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0A0606A320;
	Thu, 19 Nov 2026 00:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y5fjro6A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EB011F000C4;
	Thu, 19 Nov 2026 00:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047385;
	bh=wT1sk/rocS/09X5GtzmsQgerD7KqhugCLCLM7jOEUtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y5fjro6Aj47dEVYQvqs39CLx767uwqnEvVaoIGYrVyrCLpz/g1zf8ZQoVtXRdInov
	 voTg2fvWHTpIp39wHQYdaC9a9DSdFOlBiptGkoEW6AIFKKLvpnk8+U1/p7p1weaJLF
	 LiPPQsVzy1OOPQfvlqa+rNEz8EsmLvTLxpxNkOWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	guolingxing <guolingxing@tju.edu.cn>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1620/2857] btrfs: prevent deleting the wrong subvolume by ID
Date: Wed, 18 Nov 2026 15:44:14 +0100
Message-ID: <20261118150259.677011114@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: guolingxing <guolingxing@tju.edu.cn>

[ Upstream commit 1960146913b31b288ed2cd607d103ee3b41681d4 ]

When deleting a subvolume by ID, btrfs_ioctl_snap_destroy() first
resolves the requested ID to a name, then looks up that name again
under the parent directory lock.

A concurrent rename can change which subvolume is associated with
the name between these operations. Since the deletion path does not
verify the ID of the resolved subvolume, it can delete a different
subvolume while leaving the requested one intact.

This was reproduced by repeatedly exchanging the names of two
subvolumes using renameat2(RENAME_EXCHANGE) while deleting one of
them by ID. The wrong subvolume was deleted in 9 out of 14 independent
tests.

Fix this by checking that the resolved subvolume ID matches the
requested ID while holding the parent directory lock. Return -EAGAIN
on a mismatch so that userspace can retry the operation instead of
being told that the requested subvolume does not exist.

Fixes: 949964c92843 ("btrfs: add new BTRFS_IOC_SNAP_DESTROY_V2 ioctl")
CC: stable@vger.kernel.org
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: guolingxing <guolingxing@tju.edu.cn>
Signed-off-by: David Sterba <dsterba@suse.com>
[ sashal: Adapted the error path to use err instead of ret and out_dput instead of out_end_removing. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ioctl.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 760da6706f4f9..1b0dd3228aa1e 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3446,6 +3446,17 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 
 	inode = d_inode(dentry);
 	dest = BTRFS_I(inode)->root;
+
+	/*
+	 * A concurrent rename may have changed which subvolume the name
+	 * refers to. Verify that the resolved ID still matches the requested ID.
+	 */
+	if (destroy_v2 && (vol_args2->flags & BTRFS_SUBVOL_SPEC_BY_ID) &&
+	    btrfs_root_id(dest) != vol_args2->subvolid) {
+		err = -EAGAIN;
+		goto out_dput;
+	}
+
 	if (!capable(CAP_SYS_ADMIN)) {
 		/*
 		 * Regular user.  Only allow this with a special mount
-- 
2.53.0



