Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D200514F9CE;
	Tue, 20 Feb 2024 21:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464285; cv=none; b=VMdl0u4otzOVLeI0OdQnj0of1n/r08+wrIezMztHWJCo+imkTQ/P0n/zVCbo3v15gaRq9TRvUHKMKZkOqmc686GQndBh1j8yVlIgta4F/F7/UR33W77k1Hw+VZEhys2J2nxXW/PnZu4w47wKuumn+p/lRRa9hKeyNX/JI1rZbcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464285; c=relaxed/simple;
	bh=ClyEEoRstEsLyDiprOb+MiyoAgB3MtQytR40HQLkl08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XsPoSB2AQiE3caX1hY2bIzRr8wqPbvhIGPog1feiEcwhviETCCfB0NeUpdU5hnXaeOMgwUv8z8ufIXYeIBTxgt+muApwS8EHln1dToP4V43HL8f+mpfNnMmFFdZBBVIYLaSjdlCveEX2SQRp35eLXW+5DKiUREZja2Tup3vsawY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wOzySVGl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wOzySVGl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3EEDC433C7;
	Tue, 20 Feb 2024 21:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464285;
	bh=ClyEEoRstEsLyDiprOb+MiyoAgB3MtQytR40HQLkl08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wOzySVGl1oGBPLbbyEeL42rCEkRTtSoAYFKK2Y+rQxYHYOtYfoET5KooMzY828Uys
	 XOJ+6I0yv/Wr44ITfvjg/tWcwqi+eq/gtab2uij9F35R8uUVocq2uMVspUJ4CB3zK2
	 PIDQn+nsyXIxCG8e9lOkd32iFfRpivw+GN16itWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 271/331] eventfs: Remove extra dget() in eventfs_create_events_dir()
Date: Tue, 20 Feb 2024 21:56:27 +0100
Message-ID: <20240220205646.404132617@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

commit 77bc4d4921bd3497678ba8e7f4e480de35692f05 upstream.

The creation of the top events directory does a dget() at the end of the
creation in eventfs_create_events_dir() with a comment saying the final
dput() will happen when it is removed. The problem is that a dget() is
already done on the dentry when it was created with tracefs_start_creating()!
The dget() now just causes a memory leak of that dentry.

Remove the extra dget() as the final dput() in the deletion of the events
directory actually matches the one in tracefs_start_creating().

Link: https://lore.kernel.org/linux-trace-kernel/20231031124229.4f2e3fa1@gandalf.local.home

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Fixes: 5790b1fb3d672 ("eventfs: Remove eventfs_file and just use eventfs_inode")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -774,9 +774,6 @@ struct eventfs_inode *eventfs_create_eve
 	fsnotify_mkdir(dentry->d_parent->d_inode, dentry);
 	tracefs_end_creating(dentry);
 
-	/* Will call dput when the directory is removed */
-	dget(dentry);
-
 	return ei;
 
  fail:


