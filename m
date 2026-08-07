Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE631A681E;
	Fri,  7 Aug 2026 15:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115315; cv=none; b=Xq2mtfejq/CilgdcgewcWQHjZcxw2G3TYRGwauEsNsCAIpeG7beZjjKnOI8HmnPYpZ10aHFy/Fm3gG3bFqxFTq29Q3BorhGAc6LkNIIcQaLujTW4djPwvDarhuEOjowfNyCbLrdd60KfBWmuyXTJr2L2NZRtlgSu5XOe+Kf7fZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115315; c=relaxed/simple;
	bh=OW03EUQ50Kt5D2shc6ztwNuQ8K0GWVlVlAgrEq06UIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hEFAgQPAXaGkBpFb/nH0H90N8IVB6BGAMr/5MJYL0ncXdUyvjdqGhs7rg74XziILwz/R26c+jd3Bg2xV3K3Qyw2hbx5sX2oMI65PB/CkIMBSFfsCVb2GHTZ5pTAw33VePbQy32JfT0ceIyuzRY0An2/mMlKyF7vqq1jJrOKM6IM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sqafkm+c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sqafkm+c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 235F11F00A3A;
	Fri,  7 Aug 2026 15:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115314;
	bh=0z4l6X+sEDVOWx5QBlHkgr3bHtQKQKgrlo1iX5tNf6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sqafkm+cjv5U/9x2Vdw7uwfGIr78t1jKbFaZO3JmsGOGpcEcLtXRiRN/b90jI/muM
	 0ZZdpfgUfUOzfvuwjLYSzA9RwtGHquHPw0ScQO3A7v8vFLZlGF+QeAbIvComTWi1EV
	 RB6myV6RzLaZflGfAFHAy+wNgvOy/zkRS2k7BPy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 231/396] binfmt_misc: restore write access when removing an entry
Date: Fri,  7 Aug 2026 16:36:31 +0200
Message-ID: <20260807143429.240321403@linuxfoundation.org>
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

commit db1856ea9196cf6e015d12199a34c0b9313c7bfa upstream.

Registering an entry with the MISC_FMT_OPEN_FILE flag opens the
interpreter via open_exec() which denies write access to it for as
long as the entry exists. Removing the entry closes the interpreter
file via filp_close() but never restores write access, leaving the
inode's i_writecount permanently negative. Opening the interpreter
for writing keeps failing with ETXTBSY long after the entry is gone
until the inode is evicted from the inode cache.

Commit 90f601b497d7 ("binfmt_misc: restore write access before
closing files opened by open_exec()") fixed the same imbalance in the
error path of bm_register_write() but the actual removal path has
been leaking the write denial since the introduction of the flag.

Restore write access in put_binfmt_handler() before closing the
interpreter file.

Link: https://patch.msgid.link/20260710-work-binfmt_misc-locking-v3-1-a162f7cb58d6@kernel.org
Fixes: 948b701a607f ("binfmt_misc: add persistent opened binary handler for containers")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/binfmt_misc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -161,8 +161,10 @@ static Node *get_binfmt_handler(struct b
 static void put_binfmt_handler(Node *e)
 {
 	if (refcount_dec_and_test(&e->users)) {
-		if (e->flags & MISC_FMT_OPEN_FILE)
+		if (e->flags & MISC_FMT_OPEN_FILE) {
+			exe_file_allow_write_access(e->interp_file);
 			filp_close(e->interp_file, NULL);
+		}
 		kfree(e);
 	}
 }


