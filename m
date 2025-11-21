Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6EFA3F9D2;
	Fri, 21 Nov 2025 13:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732865; cv=none; b=G+4cfUckTAT09Il+50OrBQ7xB/M+5V3YRY/v5i5vvusvAMImOKbJv9xbC15mbj8TXs5m0K1/VvQ6LsHjNxR9vD19CcIQiEu08h73ZxdfIOcl0LWdriseN8HvCVj1XXG23oNnn8AUjgwPxVneOsP0NVrD62Bo5BbJ5brFJbmNyqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732865; c=relaxed/simple;
	bh=jltXjxztMhURTdOpnPmmyF8wTdsn/C4dmB4gfgauDiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rsVYaZtkwqWJB9B1m7yrM5IgAvqsUUG2oya8FIFah4WvkPWP+Xxqo3XQ7A7LyyvTQKWoVHI1cC8sUbV0jykkSmTGSQb+nv2C5tubDhcktczTknKU4inU4etS4PXgya5FkXXmoV7m+cXxi+Eb1ksTGn5iMGSvH9vo0hN/BCpR50g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XycY7hjr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XycY7hjr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B1E4C4CEF1;
	Fri, 21 Nov 2025 13:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732865;
	bh=jltXjxztMhURTdOpnPmmyF8wTdsn/C4dmB4gfgauDiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XycY7hjrR7hv91nalLNWWEgdJl5jrqcpZmWJNvYkTcvQ5Ed8L7OFFsJB5osqVOFPy
	 tIPl02ZkDhk4C1wH3FfHw/KfyG/nvridM/mx81BtWkZptZOaKg4Oc7B9NbnPDP6ooc
	 3ZttRx+l4o79HzHjiHye2h+bnw1JGoxIBGAr963E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 269/529] NFSv4: handle ERR_GRACE on delegation recalls
Date: Fri, 21 Nov 2025 14:09:28 +0100
Message-ID: <20251121130240.593229403@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olga Kornievskaia <okorniev@redhat.com>

[ Upstream commit be390f95242785adbf37d7b8a5101dd2f2ba891b ]

RFC7530 states that clients should be prepared for the return of
NFS4ERR_GRACE errors for non-reclaim lock and I/O requests.

Signed-off-by: Olga Kornievskaia <okorniev@redhat.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 94a1caf326699..cfeef23ac9412 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -7658,10 +7658,10 @@ int nfs4_lock_delegation_recall(struct file_lock *fl, struct nfs4_state *state,
 		return err;
 	do {
 		err = _nfs4_do_setlk(state, F_SETLK, fl, NFS_LOCK_NEW);
-		if (err != -NFS4ERR_DELAY)
+		if (err != -NFS4ERR_DELAY && err != -NFS4ERR_GRACE)
 			break;
 		ssleep(1);
-	} while (err == -NFS4ERR_DELAY);
+	} while (err == -NFS4ERR_DELAY || err == -NFSERR_GRACE);
 	return nfs4_handle_delegation_recall_error(server, state, stateid, fl, err);
 }
 
-- 
2.51.0



