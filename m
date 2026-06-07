Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4C521E98E3;
	Sun,  7 Jun 2026 11:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780830217; cv=none; b=sbpvtJELX4NoxtoYP3NmuXrUqKmNvzs/XeB8J/qmCYnLrQMRsELfMV1V2pV3tFdUNGJ431A/gRGSbUZDXSKYPfe95oSb1+IDkT/5q6kn9ywHMOr9jcPWSSNjT7tMyQpCTd3JmyNNu2vhqTSHOgY3jGGgmrb3cDvAgyvC1h/b1w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780830217; c=relaxed/simple;
	bh=m6IlMUatR634hhQb0U8CKnpOmPBlDTFxiJhVPvPt5S0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fMKCzMN3DNXFTX9l316VIDD7MepxqnA2Ex1m9WVnl1dN2tMBITHTtF4icknDlkmuMqbpiByyLPmyaqAqGGx/bpLdEx/1usJ4X3LdvXG2i9u6M/tCedudsLxakwfbebeb93/rO0BUuid/eA1pZtDVslqUXLNBeSqlSIBvwmbNbsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pdMZsY6I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pdMZsY6I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ADBF1F00893;
	Sun,  7 Jun 2026 11:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780830216;
	bh=XVOkPyFaQLBQL8CaM3W/O7I1+CEVVjW5QKIwlcyRYfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pdMZsY6IAqNZsp0EuXBGJUuKqJjGKA9GDNKEqG2fu0PQ32+bgOQOVoyh0mTMW3gGE
	 7eIulzlSLWULPjf+b6zJPyrzsM6zIurpsR6mVwvEGkrFLBFyiImT5pbOGT6GAju4hp
	 xNnpoFL7i581tvxJSqTthq9m13ccUlnn4+l6hz1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Pratyush Yadav (Google)" <pratyush@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Jeff Xu <jeffxu@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Brendan Jackman <jackmanb@google.com>,
	Greg Thelen <gthelen@google.com>,
	Hugh Dickins <hughd@google.com>,
	Kees Cook <kees@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 307/307] memfd: deny writeable mappings when implying SEAL_WRITE
Date: Sun,  7 Jun 2026 12:01:44 +0200
Message-ID: <20260607095739.038536709@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

[ Upstream commit 3b041514cb6eae45869b020f743c14d983363222 ]

When SEAL_EXEC is added, SEAL_WRITE is implied to make W^X.  But the
implied seal is set after the check that makes sure the memfd can not have
any writable mappings.  This means one can use SEAL_EXEC to apply
SEAL_WRITE while having writeable mappings.

This breaks the contract that SEAL_WRITE provides and can be used by an
attacker to pass a memfd that appears to be write sealed but can still be
modified arbitrarily.

Fix this by adding the implied seals before the call for
mapping_deny_writable() is done.

Link: https://lore.kernel.org/20260505133922.797635-1-pratyush@kernel.org
Fixes: c4f75bc8bd6b ("mm/memfd: add write seals when apply SEAL_EXEC to executable memfd")
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Acked-by: Jeff Xu <jeffxu@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memfd.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -273,6 +273,12 @@ static int memfd_add_seals(struct file *
 		goto unlock;
 	}
 
+	/*
+	 * SEAL_EXEC implies SEAL_WRITE, making W^X from the start.
+	 */
+	if (seals & F_SEAL_EXEC && inode->i_mode & 0111)
+		seals |= F_SEAL_SHRINK|F_SEAL_GROW|F_SEAL_WRITE|F_SEAL_FUTURE_WRITE;
+
 	if ((seals & F_SEAL_WRITE) && !(*file_seals & F_SEAL_WRITE)) {
 		error = mapping_deny_writable(file->f_mapping);
 		if (error)
@@ -285,12 +291,6 @@ static int memfd_add_seals(struct file *
 		}
 	}
 
-	/*
-	 * SEAL_EXEC implies SEAL_WRITE, making W^X from the start.
-	 */
-	if (seals & F_SEAL_EXEC && inode->i_mode & 0111)
-		seals |= F_SEAL_SHRINK|F_SEAL_GROW|F_SEAL_WRITE|F_SEAL_FUTURE_WRITE;
-
 	*file_seals |= seals;
 	error = 0;
 


