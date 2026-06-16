Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C5A34751B;
	Tue, 16 Jun 2026 19:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636977; cv=none; b=pdd3Dd5X96xLgFnhcGelkY9QAXjuw2ICA3DXaiQhEN43l6tWbb7z1plfdv56RcJJRrGN5p5LUF7UvkWCvqMKoJuTzFJbf9Qchl+a0Eb2ZXboaeWuN96D9+9qpawyE+MW9+p1i0m4erG1w5/IwV2Y+ca9Xrsh+OeGLN1jAaimrs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636977; c=relaxed/simple;
	bh=syrUqKpnCvz/2RYK0a3HaAefvnJE/Lj77Ls5EGa8sqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H3gPH6G2ukoNdqvf+vbb7ix+Ugst8UXT5DXf1Vcs9ChLT35acufVVRUH8//ejYT7oP55xFTt0Xqqjz0iKlIO2hbbEblj2XfZU8xejcH+JqHCJ1isipnRrWJ5YbY+KL5EMzJAq6W+M1XDfDneQG/Fyeje7ap3fR0ci9rYOTqgmCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bwnoOexg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bwnoOexg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 338E81F00A3A;
	Tue, 16 Jun 2026 19:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636976;
	bh=3EsCN9PWGHQtJkn18oLg2U6Xk+8rkIbWLb64brnwXj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bwnoOexg0b46seLr2aL6E/Nj9JfW6dfgJvSLLZNVYMzHR3X10wIUgNgVDRKUENYjT
	 j7BX7n6IshPmXrifaAY+mN0XRyChUlSuIGOGXHC9dnrO3dXkCPAOWqnBMSVylJRHM6
	 76rj4TeiwohGi1t3oO/Mv3F9GcchAUysUCH+tVwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Hutchings <benh@debian.org>
Subject: [PATCH 5.10 341/342] apparmor: validate default DFA states are in bounds
Date: Tue, 16 Jun 2026 20:30:37 +0530
Message-ID: <20260616145104.536833369@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <benh@debian.org>

Some backports of commit 9063d7e2615f ("apparmor: validate DFA start
states are in bounds in unpack_pdb") limited the bounds checks on DFA
start states to the case where the start state was explicit in the
policy.  However, the default DFA start state (DFA_START = 1) could
also be out-of-bounds.

Move these checks out of the else-branches so that they are applied
regardless of how the start state was initialised.

Fixes: f43eea8ae010 ("apparmor: validate DFA start states are in bounds in unpack_pdb")
Signed-off-by: Ben Hutchings <benh@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/apparmor/policy_unpack.c |   27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

--- a/security/apparmor/policy_unpack.c
+++ b/security/apparmor/policy_unpack.c
@@ -846,6 +846,8 @@ static struct aa_profile *unpack_profile
 	}
 
 	if (unpack_nameX(e, AA_STRUCT, "policydb")) {
+		size_t state_count;
+
 		/* generic policy dfa - optional and may be NULL */
 		info = "failed to unpack policydb";
 		profile->policy.dfa = unpack_dfa(e);
@@ -860,13 +862,12 @@ static struct aa_profile *unpack_profile
 		if (!unpack_u32(e, &profile->policy.start[0], "start")) {
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
@@ -889,16 +890,18 @@ static struct aa_profile *unpack_profile
 		info = "failed to unpack profile file rules";
 		goto fail;
 	} else if (profile->file.dfa) {
+		size_t state_count;
+
 		if (!unpack_u32(e, &profile->file.start, "dfa_start")) {
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


