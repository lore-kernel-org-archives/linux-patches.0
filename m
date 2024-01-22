Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BECE27456;
	Tue, 23 Jan 2024 00:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968699; cv=none; b=MSGQ7mq6DuM4a0ZE8Njr26lWna3ozT7Ff74D15GjOISQ+GkxpNUaAM0sJfnQCvVk3ZC6MYXmOVR2g5ms5yQc8p1x7/yFzNTTUBG+yZcpWV1ZMEHm7QxVSBxPlKLZLgI2DDSfQnuJhfJpxd0JY1m1fgIFKcaKghQKIISFf5nkIYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968699; c=relaxed/simple;
	bh=idw9WfoLTV3OIkXyHE729vXzSOAIauu9BvKa6k92JhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DVTUA5hqBUHKkdXVTNsrmyZ3HhzxqGzn2syrsCTJzDnddD/e9d/gMdvn5MNK4It7wURGZPPGW8fr9TiGKUexnPy6ADFMJQhLYdClEeXsR81B2oGrpikFmOFEfd0ZuH/jWQKAIqk9KoCMhZ5OiTy143HNvEWMdB1p+FMVJXsyvcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cjZSqHdD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cjZSqHdD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE53C43390;
	Tue, 23 Jan 2024 00:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968698;
	bh=idw9WfoLTV3OIkXyHE729vXzSOAIauu9BvKa6k92JhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cjZSqHdDoRO9K1ov7d5qPy3+gQwwgqPRuntgOWrD/3cTYiUAr2nr4qW7ROgYtB8CX
	 mlY7NrCrGlavJqh4UYaKYAZ5nxsoOBlQcdOZwLZok1DnAhd7DawZngw6NC5QQ17GXM
	 ZVC2GJvOIp320gWnJmnES8rvl4erwLgLM8GkcuQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Neil Brown <neilb@suse.de>,
	Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 4.19 147/148] Revert "NFSD: Fix possible sleep during nfsd4_release_lockowner()"
Date: Mon, 22 Jan 2024 15:58:23 -0800
Message-ID: <20240122235718.570230333@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit ef481b262bba4f454351eec43f024fec942c2d4c which is
commit ce3c4ad7f4ce5db7b4f08a1e237d8dd94b39180b upstream.

The maintainers ask it to be removed in this branch.

Cc: Dai Ngo <dai.ngo@oracle.com>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Jeff Layton <jlayton@kernel.org>
Link: https://lore.kernel.org/linux-nfs/3162C5BC-8E7C-4A9A-815C-09297B56FA17@oracle.com/T/#t
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -6392,12 +6392,16 @@ nfsd4_release_lockowner(struct svc_rqst
 		if (sop->so_is_open_owner || !same_owner_str(sop, owner))
 			continue;
 
-		if (atomic_read(&sop->so_count) != 1) {
-			spin_unlock(&clp->cl_lock);
-			return nfserr_locks_held;
+		/* see if there are still any locks associated with it */
+		lo = lockowner(sop);
+		list_for_each_entry(stp, &sop->so_stateids, st_perstateowner) {
+			if (check_for_locks(stp->st_stid.sc_file, lo)) {
+				status = nfserr_locks_held;
+				spin_unlock(&clp->cl_lock);
+				return status;
+			}
 		}
 
-		lo = lockowner(sop);
 		nfs4_get_stateowner(sop);
 		break;
 	}


