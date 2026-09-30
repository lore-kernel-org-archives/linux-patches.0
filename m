Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58FAA4E780D;
	Wed, 30 Sep 2026 16:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786595; cv=none; b=BWKB8YIB8DUbX/v/5iNJHKYl6wW5X2oSZTtp+lyf1e/j1L7P4sJndbWyPN2znfs9YHmoQYZqOPUtDQ+oaQt5c5MZ45BZF/piFfuJhiI0DyqKYbw/AFQlE6OR+o9C0d/23Inl7ebCjjwRhYhAXBTtJczY1hWWAiG0YgqilOBNbBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786595; c=relaxed/simple;
	bh=fuMiV5DpJdgI68Pk8lRljhFMS5rqugdJH5EGTcL8dPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IG9cDHyl1Yyz7Of3l1GK69OXmZiRS+ytka+Stk5S+iZgCYx4YcqFrX9IhwG5rLXlKgGXzSGZUcOk53+jX/EnR2SoOUr7nfKVUnhmnoKrh7ATBctuzhgjPA1ZAGvgOMHJLZbvRu5nRFbu/u/gow3Jjza/wgpnMnDw4XwsqHoJ2fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nZrPtCrg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nZrPtCrg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30541F000FF;
	Wed, 30 Sep 2026 16:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786594;
	bh=4rnKuL5MGlGhDydi8v7klgc1UdO44PhXfPVx54qDFVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nZrPtCrg5t/QxNoggXkjD5GJwm08E1Bo/fE13Ip38eEcwfEwFxF+OpZtPp+uxN7PW
	 a54+yIYTWzqE0VTKCMxD37Q5zGacEiaf635dSTgmdxvPoY6MOPK4xigx1BBadwX2An
	 pvsD3XL9od7iMkt9h4oy4Qk42i6LfoUUWYZbOQ8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Peng <benquike@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 916/982] autofs: fix sbi->pipe file reference leak in autofs_kill_sb()
Date: Wed, 30 Sep 2026 17:27:32 +0200
Message-ID: <20260930152436.414183810@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Hui Peng <benquike@gmail.com>

[ Upstream commit aa5e44b29ffe4eaa08cc2237fd65bc2596bc023e ]

When autofs_fill_super() fails before clearing AUTOFS_SBI_CATATONIC (for
example, when find_get_pid() fails on an invalid pgrp mount option, or
when an fs_context is closed before mounting), deactivate_locked_super()
invokes autofs_kill_sb() -> autofs_catatonic_mode(sbi).

Because AUTOFS_SBI_CATATONIC is still set in sbi->flags,
autofs_catatonic_mode() returns early without calling fput(sbi->pipe),
permanently leaking the pipe struct file reference.

Explicitly release sbi->pipe in autofs_kill_sb() if it is still non-NULL
after autofs_catatonic_mode().

Fixes: ebc921ca9b92 ("autofs: copy autofs4 to autofs")
Signed-off-by: Hui Peng <benquike@gmail.com>
Link: https://patch.msgid.link/20260919204808.2812930-1-benquike@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/autofs/inode.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/autofs/inode.c b/fs/autofs/inode.c
index affa70360b1f8..47356259a1a68 100644
--- a/fs/autofs/inode.c
+++ b/fs/autofs/inode.c
@@ -50,6 +50,10 @@ void autofs_kill_sb(struct super_block *sb)
 	if (sbi) {
 		/* Free wait queues, close pipe */
 		autofs_catatonic_mode(sbi);
+		if (sbi->pipe) {
+			fput(sbi->pipe);
+			sbi->pipe = NULL;
+		}
 		put_pid(sbi->oz_pgrp);
 	}
 
-- 
2.53.0



