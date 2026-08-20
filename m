Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E815F47F2CE;
	Thu, 20 Aug 2026 17:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248522; cv=none; b=O6zmkJpYTwghr2SdNZm3gB9teFeOZdTLmRBnxC2At0WpWNWPqFudoR/VGuiBOazmeHPkha8XdyUmTorl4vRblEYPsBgFtFpdzIpC0SIsV6Dl2Kpz8PcyDwrflZloZiR3JJ23vepHanvtLCf+OZs75x0XADz5GQfAyB3k4L4VRlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248522; c=relaxed/simple;
	bh=jW/71XlGtdaG+zGTWwJQrwyhLe6d6+1y082bncmpAP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JUMO2Ke5IuH+0JNbqRET0S3FbVoQaZRlTAfzeyLaWcibeyhAD36UX6HztR2t9VIZ7aXidZoWPgVeF+0ukb9sKDadk8A7MCoJG/a5v7t68OLaWNlXxH6vIevkMbeDx/n3u0gpn/kgFyF8+vBzscEtThv7Yj7mKQ8jpvduJMR5UVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J0Wt69hJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J0Wt69hJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E4421F000E9;
	Thu, 20 Aug 2026 17:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248520;
	bh=W0w0iyaWgZvFYxuhvngiU4lyWWzS3eHuvGQs2IEQGVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J0Wt69hJ2hKZn+za77cg3gk19KokYN5eLHTgF6ufDWHNRGSiPAY+wmcNa1mjCdDq/
	 pFFWO4cWe2ibeEU9TdNRCJxgQs1hClK8YB+c+m700kUjAD3OZnTjf6mhZYNXrOPfz8
	 ZrDqk8BHweIb+VrHBftEI1j9JHfONnr0KEAIMGWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 256/303] binfmt_misc: restore write access when removing an entry
Date: Thu, 20 Aug 2026 16:56:32 +0200
Message-ID: <20260820145301.142135447@linuxfoundation.org>
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

[ Upstream commit db1856ea9196cf6e015d12199a34c0b9313c7bfa ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/binfmt_misc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -163,8 +163,10 @@ static Node *get_binfmt_handler(struct l
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


