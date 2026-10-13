Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5271990C7;
	Tue, 13 Oct 2026 12:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893178; cv=none; b=HhuKPLzdq8pfHSGeDNk3m9PcPoy9qXJ45M3XjVgUcc95PcH8mlOdANa315YEn7zSuVjZgTg/KcZXFT4PMwfo6RER9ih5QH27SWnNWthIfJRFZj4PsY5KyrB434Wtz8kpu/catbg3ZICtwsU7FjpJRutYHFk8/4NiPJZqCmha+DM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893178; c=relaxed/simple;
	bh=6gpLoosFK0STCqi2n0fvOcAidfmW+FKr7zZ5DBqX8Tw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XHClltDt5Va+9j/p84uXUMLAMSrgXQvsNcbunJNXOriD+Kws8f2zd8xPOXTPiP0B7mWkNfh43vk4gPF0ege7DPslg2N7HKJF1sJomi74DA9hCDzg2LjU+gENM1DlAlEp0U0bGBAWCxAGcRQ9cyiE0Pi3VWHCvtuwqvb/gzEFIJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r6rGjlVK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r6rGjlVK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F46E1F00893;
	Tue, 13 Oct 2026 12:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893177;
	bh=YPthwCa+5OWYuKAmQ0Be16qWpo5JAn/lgitVF3twfgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r6rGjlVKUk1Udja55bGjAqTbCiGKQ/XOrK6YJL1/faaKwB1WAPS74EYbygaxADRIH
	 qcyB6hjVfs3Lt9R9eu1Iwo9stdKIDTvP0iJvjZtQxDHRJYanXEM3u1VDN6uo5MG5rs
	 HnPMbXRqMWbNM3SolBzb3LXdLCOeLG+qNVNlzy7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 138/621] namespace: look at the topmost mount for a mount namespace file
Date: Tue, 13 Oct 2026 13:32:13 +0200
Message-ID: <20261013112924.131638794@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

commit 8714b44adac7b10506e1db3ef1710689751f0f10 upstream.

attach_recursive_mnt() preallocates a mountpoint for the root of the
topmost mount of the source so that a mount that already sits at the
destination can be put on top of the source or on top of one of its
propagated copies.

The copies are made without CL_COPY_MNT_NS_FILE so their chain of
overmounts is shorter than the source's. It ends below the first bind
mount of a mount namespace file. So while the loop walks up the chain of
the source it remembers the mountpoint of that mount in "shorter" and
the existing mount is put there for the copies.

But the loop ends at the topmost mount without ever looking at it. If
the topmost mount is the only mount namespace file in the chain
"shorter" stays NULL and mnt_change_mountpoint() attaches the existing
mount of the copy below the root of the mount namespace file. That's a
dentry of nsfs. No path walk in the copy's mount namespace ever gets
there. The mount is gone until its parent goes and the copy that took
its place can't be unmounted synchronously because it has a child:

  S      bind mount of a file
  N      bind mount of a mount namespace file on top of S
  A      shared mount, B a slave of A, Q mounted on B/file

  move_mount(S, A/file)
  cat B/file          -> the content of S instead of Q
  umount B/file       -> EBUSY

Look at every mount of the chain including the topmost one.

Fixes: 96f5d2e05165 ("attach_recursive_mnt(): unify the mnt_change_mountpoint() logics")
Cc: stable@vger.kernel.org # v6.17+
Link: https://patch.msgid.link/20260930-work-mount-fixes-3-v1-8-be34c83956ae@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/namespace.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2585,9 +2585,11 @@ static int attach_recursive_mnt(struct m
 	 * Preallocate a mountpoint in case the new mounts need to be
 	 * mounted beneath mounts on the same mountpoint.
 	 */
-	for (top = source_mnt; unlikely(top->overmount); top = top->overmount) {
+	for (top = source_mnt; ; top = top->overmount) {
 		if (!shorter && is_mnt_ns_file(top->mnt.mnt_root))
 			shorter = top->mnt_mp;
+		if (likely(!top->overmount))
+			break;
 	}
 	err = get_mountpoint(top->mnt.mnt_root, &root);
 	if (err)


