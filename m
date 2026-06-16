Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DAC63CE4BA;
	Tue, 16 Jun 2026 18:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633019; cv=none; b=RBo8KrvMwQVc9+Jg37HohdYdFu/BJVe7Z63DqzIxVgyYR55Xl2ocECpF/XMSZR2Mt+e/UPnxJ5x+o4RdXAK6ZOQtwYiHmE/CpM3E9Rz4gPlIejqnk/sMOhZ1CAzG7T9RVs3thY8RYFRUiKXRR38INei7TtNG4BdpVUMaEbpFsKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633019; c=relaxed/simple;
	bh=QnOjdhaYH9AinWLDnVXJ1vkN8W2jv5jqVLPLV3h8KXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eo9D5pIIkikAq8pEiEaB2PZXut2bTPuv3gjm7vIPHZ2mwRkz3JlaTRunEqygf53+4YDuvtngdFMpMIiEZVwpqNbMDhZUwE/HJac9tEjTYpQbMB0ROzKBsIBXAqP7XrkpNzRX44f6EzOL7GKisMMcR6CyZokA4esfsU1cMSi5MY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X7jw4Jgf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X7jw4Jgf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D9771F000E9;
	Tue, 16 Jun 2026 18:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633018;
	bh=LOLnL+PxyjH5gq0zC9QilhxKAqc0KtAC+ZopHc8lyCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X7jw4JgfMo+wlHzwPN5uMgCJmttUgtg+DhMZpx73H8XT7VpJzTRQ8qbMfa1CoraGp
	 SyGAtv9baaR23TUn5ekpwJqJJ2Oug3X97uPF4foTUz4kbbT0AX0l5ipOegnWjnPIxh
	 NNr8kAnAitfebXGkuPxnS196zBCHXLB4/skj245c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Hutchings <benh@debian.org>
Subject: [PATCH 6.1 521/522] apparmor: validate default DFA states are in bounds
Date: Tue, 16 Jun 2026 20:31:08 +0530
Message-ID: <20260616145150.082886843@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <benh@debian.org>

Some backports of commit 9063d7e2615f ("apparmor: validate DFA start
states are in bounds in unpack_pdb") limited the bounds checks on DFA
start states to the case where the start state was explicit in the
policy.  However, the default DFA start state (DFA_START = 1) could
also be out-of-bounds.

Move these checks out of the else-branches so that they are applied
regardless of how the start state was initialised.

Fixes: 5443c027ec16 ("apparmor: validate DFA start states are in bounds in unpack_pdb")
Signed-off-by: Ben Hutchings <benh@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/apparmor/policy_unpack.c |   27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

--- a/security/apparmor/policy_unpack.c
+++ b/security/apparmor/policy_unpack.c
@@ -829,6 +829,8 @@ static struct aa_profile *unpack_profile
 	}
 
 	if (aa_unpack_nameX(e, AA_STRUCT, "policydb")) {
+		size_t state_count;
+
 		/* generic policy dfa - optional and may be NULL */
 		info = "failed to unpack policydb";
 		profile->policy.dfa = unpack_dfa(e);
@@ -843,13 +845,12 @@ static struct aa_profile *unpack_profile
 		if (!aa_unpack_u32(e, &profile->policy.start[0], "start")) {
 			/* default start state */
 			profile->policy.start[0] = DFA_START;
-		} else {
-			size_t state_count = profile->policy.dfa->tables[YYTD_ID_BASE]->td_lolen;
+		}
 
-			if (profile->policy.start[0] >= state_count) {
-				info = "invalid dfa start state";
-				goto fail;
-			}
+		state_count = profile->policy.dfa->tables[YYTD_ID_BASE]->td_lolen;
+		if (profile->policy.start[0] >= state_count) {
+			info = "invalid dfa start state";
+			goto fail;
 		}
 
 		/* setup class index */
@@ -872,16 +873,18 @@ static struct aa_profile *unpack_profile
 		info = "failed to unpack profile file rules";
 		goto fail;
 	} else if (profile->file.dfa) {
+		size_t state_count;
+
 		if (!aa_unpack_u32(e, &profile->file.start, "dfa_start")) {
 			/* default start state */
 			profile->file.start = DFA_START;
-		} else {
-			size_t state_count = profile->file.dfa->tables[YYTD_ID_BASE]->td_lolen;
+		}
+
+		state_count = profile->file.dfa->tables[YYTD_ID_BASE]->td_lolen;
 
-			if (profile->file.start >= state_count) {
-				info = "invalid dfa start state";
-				goto fail;
-			}
+		if (profile->file.start >= state_count) {
+			info = "invalid dfa start state";
+			goto fail;
 		}
 	} else if (profile->policy.dfa &&
 		   profile->policy.start[AA_CLASS_FILE]) {


