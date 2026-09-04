Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD79D415F22;
	Fri,  4 Sep 2026 05:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500633; cv=none; b=KGLlAdow2VmvjZ8GEEnjEVkKZ9fH+7uGLIBEcwDpBycZewHFoJxVE576+GbAIBL0UmULucBHcRgDPA3y+Yp7UokZokprPvUVY+1ZI8HqnFrTq7f3IVb4HBrIzrjvjs5hmwRdDpvFcO/fmssjMxtm7bdolaQ0mMVAq9hYhSd80/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500633; c=relaxed/simple;
	bh=Id41L3Xpa/ULM66svKn8KhaAmIe7yROa2iv96xDF9bs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=axb5/vdHzF94KW+G3vrOICqyu6USFacrSZnuQ6NtaPQiYR0X4MTR1q2I06ykELZ/MSNeZNn7h3H6DzSOgN6qItC6jCqIbgtzLaxxE1iwj7TQnrac3kfAZ6CMpS654An1UHsgtVLT2tY1l1/snCa/ckdmsTPNsHgTxoO35UQlzWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AAL/0hqI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AAL/0hqI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B2731F00A3D;
	Fri,  4 Sep 2026 05:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500631;
	bh=tKjf698iBtW+qkDNPkaXqy45UXRvOwJk0fq9DpQM5Xg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AAL/0hqIIfgqjEbe3bSb+J3Aib0gwV46MpGKZL3Z3gZJ+/19s6I/30aUX8sjLEfYy
	 gJQXkjbdaN/y66AF9ndGDKwvi07XDzoEe6nmY+MjN65Qt3Jz1pN9WHwco9gndJhiKj
	 8JhU08tQsDTJdDcAKw2HlH/RSsWEq8oNIEYtzdJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.18 126/552] nfsd: dont free session slots that are still in use
Date: Fri,  4 Sep 2026 06:54:43 +0200
Message-ID: <20260904045751.085062217@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

commit f5d22e372f4ac3eb287037a488c29691d52a6330 upstream.

nfsd4_sequence() can free the very slot it is currently processing.
When the session shrinker has reduced se_target_maxslots below
se_fchannel.maxreqs, the shrink path checks three conditions before
calling free_session_slots():

  1. se_target_maxslots < maxreqs  (shrink was advertised)
  2. slot->sl_generation == se_slot_gen  (slot is up-to-date)
  3. seq->maxslots <= se_target_maxslots  (client acknowledges)

However, seq->slotid is never checked against se_target_maxslots.
A client using a slot in the range [se_target_maxslots, maxreqs) can
satisfy all three conditions: its slot has the current generation
(set by a prior SEQUENCE), and it sends sa_highest_slotid <=
se_target_maxslots to acknowledge the reduction.

free_session_slots() then kfrees every slot at index >=
se_target_maxslots, including the caller's own slot. The function
continues to write sl_seqid, sl_flags, sl_generation, and stores the
dangling pointer in cstate->slot. Later, nfsd4_store_cache_entry()
copies up to maxresp_cached bytes of the compound reply into the freed
sl_data[] array, corrupting whatever slab object now occupies that
address.

Additionally, a concurrent thread processing SEQUENCE on a different
high-numbered slot can have its slot freed out from under it.
NFSD4_SLOT_INUSE is set under nn->client_lock before the lock is
released, so any concurrent thread past SEQUENCE will have its slot
marked. However, free_session_slots() does not check NFSD4_SLOT_INUSE
before freeing.

Fix both problems by:
 1. Checking that the current request's slotid is below the shrink
    boundary.
 2. Scanning slots in the to-be-freed range for NFSD4_SLOT_INUSE and
    deferring the shrink if any are active.

Fixes: fc8738c68d0b ("nfsd: add support for freeing unused session-DRC slots")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260526-nfsd4_sequence_shrink_uaf_on_loaded_slot-v2-1-74a89db0639e@kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -4396,6 +4396,19 @@ static void nfsd4_construct_sequence_res
 		seq->status_flags |= SEQ4_STATUS_ADMIN_STATE_REVOKED;
 }
 
+static bool nfsd4_slots_inuse(struct nfsd4_session *ses, int from)
+{
+	int i;
+
+	for (i = from; i < ses->se_fchannel.maxreqs; i++) {
+		struct nfsd4_slot *slot = xa_load(&ses->se_slots, i);
+
+		if (slot->sl_flags & NFSD4_SLOT_INUSE)
+			return true;
+	}
+	return false;
+}
+
 __be32
 nfsd4_sequence(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 		union nfsd4_op_u *u)
@@ -4475,7 +4488,9 @@ nfsd4_sequence(struct svc_rqst *rqstp, s
 
 	if (session->se_target_maxslots < session->se_fchannel.maxreqs &&
 	    slot->sl_generation == session->se_slot_gen &&
-	    seq->maxslots <= session->se_target_maxslots)
+	    seq->maxslots <= session->se_target_maxslots &&
+	    seq->slotid < session->se_target_maxslots &&
+	    !nfsd4_slots_inuse(session, session->se_target_maxslots))
 		/* Client acknowledged our reduce maxreqs */
 		free_session_slots(session, session->se_target_maxslots);
 


