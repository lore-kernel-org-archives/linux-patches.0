Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA96D33C1AD;
	Fri,  7 Aug 2026 15:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115319; cv=none; b=JlcjxvufPcoXEFFhpXOdnTPdcLZmLWRTbJoOC1D3LwvFIdKF+Gj2bDmH8IkWHxue3DMfU176c39QqQwOuhww031lOd0JpoG6Dmn2MkbTEuufHvwTtacj2wxKRk/0JhF4AyLLncHY8lut8viJgO6PxfeTvSbrWNn8MZHk+zxiV2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115319; c=relaxed/simple;
	bh=9gdzj6v954RLi+RvoLMKuLVVuXqnLT5FY9dIgj9cUWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FNYx+BSu/8ag7Y9kNq1oiyjdVFvtkrfUVs3KeK3BD+tHt0cVwioUf4TzoTHHo4kbdKi/LCZt5q2VGlBxovoOduePBF/tRay9Az6Cmnvf7y2Ud7/GM0j+FAGpLlbPbt0xwFk2cOpQs6fCiD7AHAhtUnIqpznVdyEjhbxV7BFAI8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qFnPRmmy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qFnPRmmy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02C741F000E9;
	Fri,  7 Aug 2026 15:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115317;
	bh=6w3CvnO4nc+5elMdm1wwLGhZhA8C0mlLkRvWSFA9E14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qFnPRmmyxGfE5hhbxuiPMWvRbTNpo9529YfdvWc22qdsbU3YYr9QD2SGQkDosSlOV
	 lsV1/pMU2xtOdofVzDIvjSm5Vz7Ey+BZ+83y6M5OBnC7EGR/XKoPWDEEOWyVuO+8Us
	 rXwD56Q1lW0qaUmUKcwmTNxaxkdqcaxsQMTnBCBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 232/396] binfmt_misc: use exe_file_deny_write_access() for the interpreter clone
Date: Fri,  7 Aug 2026 16:36:32 +0200
Message-ID: <20260807143429.261151177@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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


