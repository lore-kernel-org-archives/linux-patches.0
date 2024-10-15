Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172451C07FF;
	Tue, 15 Oct 2024 13:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997657; cv=none; b=uqWHa6tVyrTx10W5BhJCd7DFN142rxYyrFkboeUR8NJKBhKtSYpCRxws3aYcDAvJ2lb/NPBwfnIPnQW/MBm3X8NPspWV5d6VfqbHAXpfqHMpcfp1gFu1CrsE7ZYudBUcPY9k2FBbWuqxurcj2qJ8wC3WdB6qQW0lFWjK4UDlIfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997657; c=relaxed/simple;
	bh=Y1g2KlAZrIG9qlQ4rPSOSxumXCg+BhhLr3qbKzx2l7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A9Tb/AT3FjowS36Q30kVWMzefkroIbdMbz2loMb8Wi9jbOGFQHsCWodf0EmBBEEtx+e8wzfmGra1QoEjsgIXMcw5tbVqtHmpCehfGve5j9v0Vp5UoCDXGCG+tzHSV3zjXUabI1A3XMjtep31ec61VP3hCmzAtTWpEvFvSftjDms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g25BS9MA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g25BS9MA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78FFAC4CEC6;
	Tue, 15 Oct 2024 13:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997657;
	bh=Y1g2KlAZrIG9qlQ4rPSOSxumXCg+BhhLr3qbKzx2l7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g25BS9MA9L/qS/RFwdx24zDkLOdUD0W0S4kFRb+2G2kQeGO/FHEqc+UkZvqtqE+dA
	 iLwP3gUIZ4MYpwx1qwxTZ6egxSK5Eo5fcztsqksEiqX6pjMyTu8UZjo3szcYn/d+X9
	 PPQUL5n7OVVwqweoYGPDskzoBBPyNfv7CIUsjfm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Anna Schumaker <anna.schumaker@oracle.com>
Subject: [PATCH 5.10 247/518] nfs: fix memory leak in error path of nfs4_do_reclaim
Date: Tue, 15 Oct 2024 14:42:31 +0200
Message-ID: <20241015123926.524506182@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1948,6 +1948,7 @@ restart:
 				set_bit(ops->owner_flag_bit, &sp->so_flags);
 				nfs4_put_state_owner(sp);
 				status = nfs4_recovery_handle_error(clp, status);
+				nfs4_free_state_owners(&freeme);
 				return (status != 0) ? status : -EAGAIN;
 			}
 


