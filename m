Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 123E548A8D1;
	Thu, 20 Aug 2026 17:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247302; cv=none; b=B3zTxw5zZJEVrirb8ecT7cE703x5oF7/12AkxhdJ7ZzBxNKg7aJ5opENkrYuTQtnuoqCmwudBPTfT2naub5wD/PxZ5/BVZlgXdiSCaySPI4j9ktYkkY7UMfJ6+Grs2iPzO7x94ed3jqNxOYVQ+/4VpsKj2Y55f620Nl+URD+J0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247302; c=relaxed/simple;
	bh=l9sotlg8g7Zr7NFfVM6MSgigcbiBsl5S4W7QCMxE0co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tsXaf063yQ/pZTxOoQoiLSsMNeTOMDCTbHEQjTGcMAXGsUjdLkWT9Bzdj0CJ94MXsb5T3zGeu+XfhqHGcfoAMuy/S8zC7RodoJRJLroQzmgsIUt6YL27sX/k8mxX29Heeq33HMGQFEFzpCmyJJtK35aQY+TJAwVnBLa0030iAUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QKgW1OUt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QKgW1OUt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 976AA1F000E9;
	Thu, 20 Aug 2026 17:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247301;
	bh=xYz4DX0oCTm4Dk6h+zqMax2OVdgfxp6IpKT0V1PvsgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QKgW1OUtH5oHE0gpiZHSMpEmwip7n6QjXLVF8exPSBwvLN+IJwGtOWV0rURCONz8f
	 x9KoeifsNNPfFtzumDyjbBEYTsrcHi4F3+q87EAdqJyULLwK+lTIO4XBigJqvWGt5l
	 DKiF5h3SYj66Hw5VI9IJe0wS9JUp8C4ygrOmknGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.12 218/220] binfmt_misc: use exe_file_deny_write_access() for the interpreter clone
Date: Thu, 20 Aug 2026 16:56:48 +0200
Message-ID: <20260820145230.092767946@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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
@@ -248,8 +248,14 @@ static int load_misc_binary(struct linux
 
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


