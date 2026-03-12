Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE0F318EE1;
	Thu, 12 Mar 2026 20:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773347336; cv=none; b=drY32AEVWe6wf2cZoPBliCI4jMW6bTIiNgj2grPIr8AVXy3jjCfyLdVwoPFa59RyaTqcNNZpBSS0Jk9A52nTGdgM9NHFcmwxrr1+4myTvMgWgrZNP0Sy7eppgLHxaEH7BC6W5GS/sDWd/nn082UgD4L+Enmx+6yWeejXc5tb6Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773347336; c=relaxed/simple;
	bh=rqKN2hX/U97QJhWFWXWN9p03ab551zyXpEZ4Iv891N8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eBSS6Z7rGfs4s7VkuQPEVPBg15T7oIcVqlLKzWJM9umy30hyug1vSsokLWg1uctrxM0WpDK/7MY752RSq6HU0hWkIf0QtUWN9M5GY8nF5qF965ar5ybPh+29W7y7uKBuP9EBqUnKvrlLfNYfd5RGuE4NdXGL+W3Z6c2RBX7XEWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GiPq8rJM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GiPq8rJM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AC2DC4CEF7;
	Thu, 12 Mar 2026 20:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773347335;
	bh=rqKN2hX/U97QJhWFWXWN9p03ab551zyXpEZ4Iv891N8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GiPq8rJMZh+Q9Dm6UaC4WdfSv9I1jGVo0ABYxA4NGkQ5O46kZlq3jahN+xGVuoiwe
	 w+hRpBMdFmGbKlH20qrNkbb/Glvbr465CbME+YEGwCA6vAgIWDad5SguiwmalDV7Nl
	 BYo9m/1XSQwZ1Q9glbK285O8/nB20L0FWPWNpirc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qualys Security Advisory <qsa@qualys.com>,
	Salvatore Bonaccorso <carnil@debian.org>,
	Georgia Garcia <georgia.garcia@canonical.com>,
	Cengiz Can <cengiz.can@canonical.com>,
	John Johansen <john.johansen@canonical.com>
Subject: [PATCH 6.12 258/265] apparmor: fix differential encoding verification
Date: Thu, 12 Mar 2026 21:10:45 +0100
Message-ID: <20260312201027.667959110@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Johansen <john.johansen@canonical.com>

commit 39440b137546a3aa383cfdabc605fb73811b6093 upstream.

Differential encoding allows loops to be created if it is abused. To
prevent this the unpack should verify that a diff-encode chain
terminates.

Unfortunately the differential encode verification had two bugs.

1. it conflated states that had gone through check and already been
   marked, with states that were currently being checked and marked.
   This means that loops in the current chain being verified are treated
   as a chain that has already been verified.

2. the order bailout on already checked states compared current chain
   check iterators j,k instead of using the outer loop iterator i.
   Meaning a step backwards in states in the current chain verification
   was being mistaken for moving to an already verified state.

Move to a double mark scheme where already verified states get a
different mark, than the current chain being kept. This enables us
to also drop the backwards verification check that was the cause of
the second error as any already verified state is already marked.

Fixes: 031dcc8f4e84 ("apparmor: dfa add support for state differential encoding")
Reported-by: Qualys Security Advisory <qsa@qualys.com>
Tested-by: Salvatore Bonaccorso <carnil@debian.org>
Reviewed-by: Georgia Garcia <georgia.garcia@canonical.com>
Reviewed-by: Cengiz Can <cengiz.can@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/apparmor/include/match.h |    1 +
 security/apparmor/match.c         |   23 +++++++++++++++++++----
 2 files changed, 20 insertions(+), 4 deletions(-)

--- a/security/apparmor/include/match.h
+++ b/security/apparmor/include/match.h
@@ -183,6 +183,7 @@ static inline void aa_put_dfa(struct aa_
 #define MATCH_FLAG_DIFF_ENCODE 0x80000000
 #define MARK_DIFF_ENCODE 0x40000000
 #define MATCH_FLAG_OOB_TRANSITION 0x20000000
+#define MARK_DIFF_ENCODE_VERIFIED 0x10000000
 #define MATCH_FLAGS_MASK 0xff000000
 #define MATCH_FLAGS_VALID (MATCH_FLAG_DIFF_ENCODE | MATCH_FLAG_OOB_TRANSITION)
 #define MATCH_FLAGS_INVALID (MATCH_FLAGS_MASK & ~MATCH_FLAGS_VALID)
--- a/security/apparmor/match.c
+++ b/security/apparmor/match.c
@@ -202,16 +202,31 @@ static int verify_dfa(struct aa_dfa *dfa
 		size_t j, k;
 
 		for (j = i;
-		     (BASE_TABLE(dfa)[j] & MATCH_FLAG_DIFF_ENCODE) &&
-		     !(BASE_TABLE(dfa)[j] & MARK_DIFF_ENCODE);
+		     ((BASE_TABLE(dfa)[j] & MATCH_FLAG_DIFF_ENCODE) &&
+		      !(BASE_TABLE(dfa)[j] & MARK_DIFF_ENCODE_VERIFIED));
 		     j = k) {
+			if (BASE_TABLE(dfa)[j] & MARK_DIFF_ENCODE)
+				/* loop in current chain */
+				goto out;
 			k = DEFAULT_TABLE(dfa)[j];
 			if (j == k)
+				/* self loop */
 				goto out;
-			if (k < j)
-				break;		/* already verified */
 			BASE_TABLE(dfa)[j] |= MARK_DIFF_ENCODE;
 		}
+		/* move mark to verified */
+		for (j = i;
+		     (BASE_TABLE(dfa)[j] & MATCH_FLAG_DIFF_ENCODE);
+		     j = k) {
+			k = DEFAULT_TABLE(dfa)[j];
+			if (j < i)
+				/* jumps to state/chain that has been
+				 * verified
+				 */
+				break;
+			BASE_TABLE(dfa)[j] &= ~MARK_DIFF_ENCODE;
+			BASE_TABLE(dfa)[j] |= MARK_DIFF_ENCODE_VERIFIED;
+		}
 	}
 	error = 0;
 


