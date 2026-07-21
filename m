Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B75A4366816;
	Tue, 21 Jul 2026 20:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667229; cv=none; b=uwV+LDfCEU/O4F3SsV2KMb6kFkQhns0jjFjXc80LtovujdpZle9CUxnHfFKhZ298xKPL+rKS9NM5wvEpsZfPvsdajlcnB5awRE4WMQZfYomkytNaVJFrJcbjs8xpptf6n4qyZkCChRDubuZt5bOY+b3kiwWcZkQ/qziC2ACUIWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667229; c=relaxed/simple;
	bh=7RuYEj6nY4g45hcYbfNvGvOXtQ68sjf/nwHusOky6pU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GvNwJtncNQqgFmvd5gvCjziDdLxixDxgfXIB7rVET4nFuC5g4372LByCMREqw1qZcbtZ+Xh4H1iOGnfoEn4d6PLP3tjpFCvErEa1vSDrqH3AAgB+1gEesA9qLzhvSpwxeFFHQLzq4UR7T2uid4JEs838R2UqpaTgFKfN4EmgQis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wVH0VsAF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wVH0VsAF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28C8F1F000E9;
	Tue, 21 Jul 2026 20:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667228;
	bh=BT6x75Yd0nXFFOA9YwUyQBt/tzDE7ezLjlxXQ9Nacvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wVH0VsAFYG1qjGSQYBBeicIvDvw3kwNPSYMNuGglyFq2izPnrsVMAMsgcYbIkfp86
	 zHjRNA8nIIMV90lFOtxZWvtZpdZDQFb+lb04TFW6mpAfZNwPsfrpoZAEv9JV4KMqri
	 Nn8sdk6e5e5Eo1lRwEo+v1WrTR/v+rPJxcBIjgZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.6 0983/1266] ntfs3: cap RESTART_TABLE free-chain walker at rt->used
Date: Tue, 21 Jul 2026 17:23:40 +0200
Message-ID: <20260721152503.835386401@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 9611f644302c07d21bc8af97e3e06a3d30064253 upstream.

A crafted NTFS3 disk image triggers an in-kernel infinite loop at
mount time, hanging the mounting thread and firing the soft-lockup
watchdog within ~22s on multi-CPU hosts (panic with
kernel.softlockup_panic=1).  The bug is reachable from desktop USB
auto-mount on distributions where udisks2 routes the NTFS signature
to the in-tree ntfs3 driver (Arch family and an increasing fraction
of Fedora / openSUSE / RHEL deployments); CAP_SYS_ADMIN-class manual
mount elsewhere.

check_rstbl()'s second walker iterates the free-entry singly-linked
list headed by rt->first_free with no upper bound on iteration count:

  for (off = ff; off;) {
      if (off == RESTART_ENTRY_ALLOCATED)
          return false;
      off = le32_to_cpu(*(__le32 *)Add2Ptr(rt, off));
      if (off > ts - sizeof(__le32))
          return false;
  }

The existing guards cover three exits: end-of-list (off == 0), the
in-use marker (off == RESTART_ENTRY_ALLOCATED), and out-of-bounds
(off > ts - sizeof(__le32)).  None of the three prevents an
in-bounds cycle.

A crafted on-disk RESTART_TABLE whose free chain contains a
self-loop or A->B->A cycle whose offsets satisfy:

  - in range [sizeof(struct RESTART_TABLE), ts - sizeof(__le32)]
  - (off - sizeof(struct RESTART_TABLE)) % rsize == 0

passes all existing guards and spins the mount-time thread forever.
Reproduced in UML by hand-forging a 2 MB NTFS3 image whose journal
RESTART_TABLE first_free = 0x18 and whose entry at offset 0x18
stores 0x18 as its next pointer; mount of the forged image with
the in-tree ntfs3 driver never returns.

Bound the walker by rt->used.  Each entry on a legitimate free
chain is unique, and the total slot count is ne = le16_to_cpu
(rt->used).  A traversal that visits more than ne slots is by
construction malformed; reject it as a corrupt RESTART_TABLE.

After this patch, mount of the forged image returns with -EINVAL
and a log_replay failure message, and mkntfs-produced legitimate
images mount cleanly (verified in the same UML harness).

Fixes: b46acd6a6a62 ("fs/ntfs3: Add NTFS journal")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/fslog.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -764,8 +764,19 @@ static bool check_rstbl(const struct RES
 	/*
 	 * Walk through the list headed by the first entry to make
 	 * sure none of the entries are currently being used.
+	 *
+	 * Bound traversal by ne (rt->used) to defeat a crafted on-disk
+	 * cycle in the free chain.  Each entry in a legitimate free
+	 * list is unique, so a chain that visits more than ne slots
+	 * is malformed.  Without this guard, an attacker-controlled
+	 * RESTART_TABLE with a self-loop or A->B->A cycle whose
+	 * offsets satisfy the existing alignment + in-bounds guards
+	 * spins forever at mount time.
 	 */
-	for (off = ff; off;) {
+	for (off = ff, i = 0; off; i++) {
+		if (i > ne)
+			return false;
+
 		if (off == RESTART_ENTRY_ALLOCATED)
 			return false;
 


