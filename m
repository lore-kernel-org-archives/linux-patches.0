Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 144EB1CFEA9;
	Tue, 15 Oct 2024 12:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993913; cv=none; b=gSSJ57p/Kw3i3J/S32iq6egRimYxwyiADOjIEIZ10Y+tPsIYyF3Yd4sdFzQhR2bKpSJps/b6XAFNl0aVtUtblItQM5ORulML5Eic8ctel+BfQbe3eCNhwY5BEKK2Jn12gilM0qjqpEXSWcwN5YR85O/w1AkJTj2xLCA16lSjYLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993913; c=relaxed/simple;
	bh=kfVkBZsGYPQtt1Y7IPJER/8mQsNLzzyVgZGgUY3uALc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XrsbjFA6AT9rDQO6HTnos+EQWGA22EPclWSuyETK0jBRx1q2bfv00AUguBq5dT5PMASjq+FpqE9E6AlHuDBCqLn0c4RchMv4UGSuX5tiPuxl1KHXk3R01OjUm1FbHMATMqnbqmFFdioduFoI1s6bDrPCBnjjnUfPHG4ZOrvz0/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zLaMYdb4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zLaMYdb4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78894C4CEC6;
	Tue, 15 Oct 2024 12:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993913;
	bh=kfVkBZsGYPQtt1Y7IPJER/8mQsNLzzyVgZGgUY3uALc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zLaMYdb4EZnA2eTbgCqeYij6oMQwL/ehO615fsclUByuOrikA3hhVy7u7yVcOm6qa
	 +djRyGoB3lVvy2mnIT72rSTQogeR6myvzO8ppwNLUmT8PCrBEsHsqdrzXKAblJPH24
	 pQP/+TjudeAbxrriCGS6lPMODtQW8uGPQdC4KM74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	NeilBrown <neilb@suse.de>,
	Benjamin Coddington <bcodding@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 520/691] nfsd: fix delegation_blocked() to block correctly for at least 30 seconds
Date: Tue, 15 Oct 2024 13:27:48 +0200
Message-ID: <20241015112500.983074035@linuxfoundation.org>
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

From: NeilBrown <neilb@suse.de>

commit 45bb63ed20e02ae146336412889fe5450316a84f upstream.

The pair of bloom filtered used by delegation_blocked() was intended to
block delegations on given filehandles for between 30 and 60 seconds.  A
new filehandle would be recorded in the "new" bit set.  That would then
be switch to the "old" bit set between 0 and 30 seconds later, and it
would remain as the "old" bit set for 30 seconds.

Unfortunately the code intended to clear the old bit set once it reached
30 seconds old, preparing it to be the next new bit set, instead cleared
the *new* bit set before switching it to be the old bit set.  This means
that the "old" bit set is always empty and delegations are blocked
between 0 and 30 seconds.

This patch updates bd->new before clearing the set with that index,
instead of afterwards.

Reported-by: Olga Kornievskaia <okorniev@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 6282cd565553 ("NFSD: Don't hand out delegations for 30 seconds after recalling them.")
Signed-off-by: NeilBrown <neilb@suse.de>
Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1090,7 +1090,8 @@ static void nfs4_free_deleg(struct nfs4_
  * When a delegation is recalled, the filehandle is stored in the "new"
  * filter.
  * Every 30 seconds we swap the filters and clear the "new" one,
- * unless both are empty of course.
+ * unless both are empty of course.  This results in delegations for a
+ * given filehandle being blocked for between 30 and 60 seconds.
  *
  * Each filter is 256 bits.  We hash the filehandle to 32bit and use the
  * low 3 bytes as hash-table indices.
@@ -1119,9 +1120,9 @@ static int delegation_blocked(struct knf
 		if (ktime_get_seconds() - bd->swap_time > 30) {
 			bd->entries -= bd->old_entries;
 			bd->old_entries = bd->entries;
+			bd->new = 1-bd->new;
 			memset(bd->set[bd->new], 0,
 			       sizeof(bd->set[0]));
-			bd->new = 1-bd->new;
 			bd->swap_time = ktime_get_seconds();
 		}
 		spin_unlock(&blocked_delegations_lock);


