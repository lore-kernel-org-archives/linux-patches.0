Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78C811AA1F4;
	Fri,  4 Sep 2026 05:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498875; cv=none; b=tt1WnTjkYV99L6MyEHK03DwvaAIEvRFVOpAdRzVBCHDMfiQa0Plwrz+nWc8bRdDfhSj5hKJjta7x9MGBZtSb4+yz+SADk4PzeX5R1tyFfd2WrTa67r7m28YB8wFChM8w24uKrc3VkDWJLGnD8XBtNL0R00912JkgHhqxiJ600+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498875; c=relaxed/simple;
	bh=ctykvAojFwi99HMluwWgcDST/YeOpqQ4b2w6/m3rf3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a0pzp4cHwruRqFGrUG4CjCwi3WZ5Li+FcITYnh+wNVScIWZPIyWwyQ4x2N/CfCaM1IJSeWeabrgUIRdhudQIQBjU7wfsi1RI/P/1sYkQZSqMUyDc3P6TMMbmYE0g4ezupK6c0Y7IjCpJ4UAao+UJKiw81f9DcLOtkFkCwuB3jfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=spZDWB+m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="spZDWB+m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D55741F00A3D;
	Fri,  4 Sep 2026 05:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498874;
	bh=dReGcjMFGG0YQerDw5HvR8iRC63Kpa450kqYRI739zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=spZDWB+mkOj4vfiYcjAnB+T0RlhZJkeT5jiAgCRbXVWSymIOHtqMrCI026LUEFokR
	 En9Tx4sq++2s58d1ykFT4LbwadXF05NqqWnmyES/9LsRc2VvOejnc9GkjyHeWGUGJO
	 MIk+BQxwuJUcoQL5eAR4LcVB6V1QHDFpmPmpWB2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.2 174/713] nfsd: drop the stateid, not the stateowner, on seqid_op replay retry
Date: Fri,  4 Sep 2026 06:52:22 +0200
Message-ID: <20260904045807.719013779@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

commit 5e4627d3513e60accfce9d5f4c7fa95251ef93d6 upstream.

In nfs4_preprocess_seqid_op() the stateid is obtained from
nfsd4_lookup_stateid(), which holds a reference on the nfs4_stid
(sc_count) but takes no reference on the stateowner. openlockstateid()
merely casts that stid and likewise takes no reference.

When nfsd4_cstate_assign_replay() returns -EAGAIN (the replay owner is
being torn down, RP_UNHASHED) it has not taken a stateowner reference on
that path. The error handling nevertheless called
nfs4_put_stateowner(stp->st_stateowner), dropping an so_count reference
the function never acquired -- risking a stateowner refcount underflow and
use-after-free -- while leaking the sc_count reference held on the stid.
The leaked stid reference can also stall a concurrent
nfsd4_close_open_stateid() waiting for sc_count to drop.

Drop the reference actually held -- the stid -- before retrying. The
stateowner stays alive through the reference held by the stid. This mirrors
the open path in nfsd4_process_open1(), where the put balances a reference
that path explicitly holds on the stateowner.

Fixes: eec762080008 ("nfsd: replace rp_mutex to avoid deadlock in move_to_close_lru()")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260611-nfsd-testing-v2-21-5b90e276f2d9@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -7840,7 +7840,7 @@ retry:
 		return status;
 	stp = openlockstateid(s);
 	if (nfsd4_cstate_assign_replay(cstate, stp->st_stateowner) == -EAGAIN) {
-		nfs4_put_stateowner(stp->st_stateowner);
+		nfs4_put_stid(&stp->st_stid);
 		goto retry;
 	}
 


