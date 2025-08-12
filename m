Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308112FE593;
	Tue, 12 Aug 2025 18:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024768; cv=none; b=ljAC0gN+92fkmv0O36xwqIRq5U0NYLT7bgRS1EcFDoF9C96Z0HRajumdqYRED+XieXG7ITRAlfB4XCFxv82cH1gE2pGFC1ptFi1TlMwUZ8p2a9AUo5erOQqwpV5okGox+wx6g+5kRSf4tiCLn768Wd5PuTAbmYCIH3Xv+eCgR+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024768; c=relaxed/simple;
	bh=/8l2bYbaNL1JHtVSLB9cF4ijCDRorN+Pno8vh2KC41o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YQH0u1JEHMR/mMNaWDy6K6FXBx4ODkIpyj+hWI7Vt+5iPcFkQALTmd3YApv/xvC7TE7OQP63BwmfjYRzEMxCubZ5FhpN1WpWajpHKY3VexqCQYNfJtD/i0+DJaDuh2UM2+CCSDgMawoCcQX4W0dUSdz8i8GrVEByj3iXGurMaKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=15RrHuTW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="15RrHuTW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F64AC4CEF0;
	Tue, 12 Aug 2025 18:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024768;
	bh=/8l2bYbaNL1JHtVSLB9cF4ijCDRorN+Pno8vh2KC41o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=15RrHuTWojXDueWGrKzY4aH0fxpKbBoPa1dPz89i4+8eJGC1isUtSBv4z8D4svDUt
	 2gmjCojQs34l/Y0HAYKhflQBDXmIQePZjXLuMXhsW+pAAdexUw0/GDrtar04jMu/aP
	 NOmDl3CXsVOf8p6GUXqyW9cwGioYxdPLVzXz5qzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Lee <ryan.lee@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 454/627] apparmor: fix loop detection used in conflicting attachment resolution
Date: Tue, 12 Aug 2025 19:32:29 +0200
Message-ID: <20250812173437.841392492@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryan Lee <ryan.lee@canonical.com>

[ Upstream commit a88db916b8c77552f49f7d9f8744095ea01a268f ]

Conflicting attachment resolution is based on the number of states
traversed to reach an accepting state in the attachment DFA, accounting
for DFA loops traversed during the matching process. However, the loop
counting logic had multiple bugs:

 - The inc_wb_pos macro increments both position and length, but length
   is supposed to saturate upon hitting buffer capacity, instead of
   wrapping around.
 - If no revisited state is found when traversing the history, is_loop
   would still return true, as if there was a loop found the length of
   the history buffer, instead of returning false and signalling that
   no loop was found. As a result, the adjustment step of
   aa_dfa_leftmatch would sometimes produce negative counts with loop-
   free DFAs that traversed enough states.
 - The iteration in the is_loop for loop is supposed to stop before
   i = wb->len, so the conditional should be < instead of <=.

This patch fixes the above bugs as well as the following nits:
 - The count and size fields in struct match_workbuf were not used,
   so they can be removed.
 - The history buffer in match_workbuf semantically stores aa_state_t
   and not unsigned ints, even if aa_state_t is currently unsigned int.
 - The local variables in is_loop are counters, and thus should be
   unsigned ints instead of aa_state_t's.

Fixes: 21f606610502 ("apparmor: improve overlapping domain attachment resolution")

Signed-off-by: Ryan Lee <ryan.lee@canonical.com>
Co-developed-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/include/match.h |  5 +----
 security/apparmor/match.c         | 22 +++++++++++-----------
 2 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/security/apparmor/include/match.h b/security/apparmor/include/match.h
index b45fc39fa837..27cf23b0396b 100644
--- a/security/apparmor/include/match.h
+++ b/security/apparmor/include/match.h
@@ -140,15 +140,12 @@ void aa_dfa_free_kref(struct kref *kref);
 /* This needs to be a power of 2 */
 #define WB_HISTORY_SIZE 32
 struct match_workbuf {
-	unsigned int count;
 	unsigned int pos;
 	unsigned int len;
-	unsigned int size;	/* power of 2, same as history size */
-	unsigned int history[WB_HISTORY_SIZE];
+	aa_state_t history[WB_HISTORY_SIZE];
 };
 #define DEFINE_MATCH_WB(N)		\
 struct match_workbuf N = {		\
-	.count = 0,			\
 	.pos = 0,			\
 	.len = 0,			\
 }
diff --git a/security/apparmor/match.c b/security/apparmor/match.c
index 1ceabde550f2..c5a91600842a 100644
--- a/security/apparmor/match.c
+++ b/security/apparmor/match.c
@@ -679,35 +679,35 @@ aa_state_t aa_dfa_matchn_until(struct aa_dfa *dfa, aa_state_t start,
 	return state;
 }
 
-#define inc_wb_pos(wb)						\
-do {								\
+#define inc_wb_pos(wb)							\
+do {									\
 	BUILD_BUG_ON_NOT_POWER_OF_2(WB_HISTORY_SIZE);			\
 	wb->pos = (wb->pos + 1) & (WB_HISTORY_SIZE - 1);		\
-	wb->len = (wb->len + 1) & (WB_HISTORY_SIZE - 1);		\
+	wb->len = (wb->len + 1) > WB_HISTORY_SIZE ? WB_HISTORY_SIZE :	\
+				wb->len + 1;				\
 } while (0)
 
 /* For DFAs that don't support extended tagging of states */
+/* adjust is only set if is_loop returns true */
 static bool is_loop(struct match_workbuf *wb, aa_state_t state,
 		    unsigned int *adjust)
 {
-	aa_state_t pos = wb->pos;
-	aa_state_t i;
+	int pos = wb->pos;
+	int i;
 
 	if (wb->history[pos] < state)
 		return false;
 
-	for (i = 0; i <= wb->len; i++) {
+	for (i = 0; i < wb->len; i++) {
 		if (wb->history[pos] == state) {
 			*adjust = i;
 			return true;
 		}
-		if (pos == 0)
-			pos = WB_HISTORY_SIZE;
-		pos--;
+		/* -1 wraps to WB_HISTORY_SIZE - 1 */
+		pos = (pos - 1) & (WB_HISTORY_SIZE - 1);
 	}
 
-	*adjust = i;
-	return true;
+	return false;
 }
 
 static aa_state_t leftmatch_fb(struct aa_dfa *dfa, aa_state_t start,
-- 
2.39.5



