Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B31546C82A;
	Thu, 20 Aug 2026 17:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248629; cv=none; b=khekTfVzvK6TOPA6aoVgJm/yujT2RLNhrxexVhfo7u9MjscdGS07szHgLDBCcKg5szCZkx9wvy+GD5ZoKJ1Zxt2ABE2blJP2Z+Kd4K9uhmci9EDydqbyTHIF+uFS7Xf51fsXzwTTp+FCH6SjiG4ZHTIZduJKXrd9xfexe3Mf9u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248629; c=relaxed/simple;
	bh=KJ2TGzPlpH6q9Tx/xUbs5b/COaZjPv3pGE4dizdZdIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U4SoCiqba+AbC19lASeFscRxgyP05gFCHhvjsmZRinuDVU+MGRwoCYJn8tmvq0MtgIit+3OEPmBoRfff9clPhsVdRqyXZKOb+g0S+Dz+RQEZVyHk5y07ksW/2UbijmSAcBOWSPG/Gfp1MjooRl5/d1G/NWnzBnWcFo00hJX6dvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g5eyWsft; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g5eyWsft"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6B5E1F000E9;
	Thu, 20 Aug 2026 17:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248628;
	bh=CHulttgJWJNfII4Uukkij9e8iIQIZNMfShVAwNWOoO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g5eyWsft+K6q/efa7rZuA+ZKn3UyiCccfUi6YLs64s9iUo3Y/j98ySMATF08hRvBv
	 mfH0RgGNXv607MXwtd85cqTwLaFCjoGmvWAUAfT1yMZKuaxjhRDjJO9JB7gcufvEMp
	 qUMidffbhF+l+YVs4U4iinAnPbZZeDpsoofHFE90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.1 294/303] binfmt_misc: use exe_file_deny_write_access() for the interpreter clone
Date: Thu, 20 Aug 2026 16:57:10 +0200
Message-ID: <20260820145302.310840511@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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


