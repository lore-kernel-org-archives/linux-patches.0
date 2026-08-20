Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A325E46D544;
	Thu, 20 Aug 2026 16:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244615; cv=none; b=t5kQv/jWTFFdIwktVQ5/WlbDwqhVsRaYcehxklmV9As8tC+MOcVd/0gIM3tTIoZUrzAc/+JQqbc+dQryRTBNA6ZAwbwQbwwFh5bDXWMtAa0Z6mAF4f+X5I5XwRuhO4E+smaumpIveODR+n5RqDQZK+jUdlEYZwTgKxNqdOsLs5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244615; c=relaxed/simple;
	bh=HOSsC4Z6WuLLUDXQk4hfgxLFH4KVQnxin/udYlOxIXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LiBzATgxksglWi9FHyf5t8JWaKunhqK1WkSZpWTBl4wgljliDogc+0g8GaHTs2FTNw29GGopguuSwyf7CHqkjNxN7oKUMHlebcrbZ3Pkvcen7zMN31GsfT5E+0o/sSJnKxMfKVx7RM6QO626L7DpLJBngRfJrDgNan/ikHllbSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K1PmbaYt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K1PmbaYt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA7B21F00A3A;
	Thu, 20 Aug 2026 16:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244614;
	bh=OD8NTnau42/n3ut2L8WNBVmUC/cYdOyu7jGizoEEjMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K1PmbaYtiv3e6qGh6s61R4RsWqOQN1LPr3n02+y8hzICDT+TXm1tgIaFNQBTzvbZi
	 Zh1KpkwVUFiw0k8Vx9/opSU/6tnPTzrFsqgx6wV19jDvfDC/Cwl3uydQbhVHAW3vo0
	 YM+An/ZxtNfEKSEBgFkUCrI55PbJmZjHTthaIvjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 5.10 231/235] binfmt_misc: use exe_file_deny_write_access() for the interpreter clone
Date: Thu, 20 Aug 2026 16:57:47 +0200
Message-ID: <20260820145223.619795900@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

commit fa5990ca8fd917003e526036bcc50413edb9722c upstream.

For MISC_FMT_OPEN_FILE entries load_misc_binary() clones the
registered interpreter file and denies write access to the clone via
plain deny_write_access(). The clone is installed as
bprm->interpreter and later released by the exec machinery through
exe_file_allow_write_access() which skips the i_writecount increment
for files with FMODE_FSNOTIFY_HSM set.

The deny and allow side can therefore come to different conclusions
when pre-content watches are in play: if a pre-content watch is added
to the interpreter after registration every subsequent exec through
that entry takes a write denial on the clone that is never paired
with a write allowance, driving the interpreter inode's i_writecount
further down with each exec and leaving the interpreter unwritable
even after the entry and all its users are gone.

Take the write denial via exe_file_deny_write_access() so both sides
of the pairing base their decision on the same file mode, and
propagate failure instead of silently ignoring it: an interpreter
that is concurrently open for writing now fails the exec with
ETXTBSY, exactly like an interpreter freshly opened via open_exec()
would.

Link: https://patch.msgid.link/20260710-work-binfmt_misc-locking-v3-2-a162f7cb58d6@kernel.org
Fixes: 0357ef03c94e ("fs: don't block write during exec on pre-content watched files")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/binfmt_misc.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -220,8 +220,14 @@ static int load_misc_binary(struct linux
 
 	if (fmt->flags & MISC_FMT_OPEN_FILE) {
 		interp_file = file_clone_open(fmt->interp_file);
-		if (!IS_ERR(interp_file))
-			deny_write_access(interp_file);
+		if (!IS_ERR(interp_file)) {
+			int err = exe_file_deny_write_access(interp_file);
+
+			if (err) {
+				fput(interp_file);
+				interp_file = ERR_PTR(err);
+			}
+		}
 	} else {
 		interp_file = open_exec(fmt->interpreter);
 	}


