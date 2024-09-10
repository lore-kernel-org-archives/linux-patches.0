Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53BD718CBE6;
	Tue, 10 Sep 2024 09:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961344; cv=none; b=X3gnGNp4utMnLdf733GWTyvR6pBF/O4f8TBUOHyUfpoWR4/+7sXYK5N2EiTLOkzI1wGz5trMMTPIGZG9TMv7kzLlpzKvJcro69OB/1oIZo1bC8hH+I4VQHx2r3Me2lPCrqHWIXoNBxVnwww62uzvzJJrxEAGXsfkMuZcEyF8Ba0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961344; c=relaxed/simple;
	bh=TajMIsohyM08iZKUHRQO0U6SddwxBHKFCB2z8jANdmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aJvSsOG8hwQUJo2d4OpgcDR/A5uzFrrLxyF73Ztargk1s48NsEoWGV7YvwJ1hAR0M+WWXddkx5GZQvNPXoPt+BZNEd/0/+dj34oAK69tJRXvX7kedmzcLVvwAiXGXURamusCKK4OCInk5kHIMhujO0A4eYRdD8QJpSovryzzmzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fdU1c0oC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fdU1c0oC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD262C4CEC3;
	Tue, 10 Sep 2024 09:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961344;
	bh=TajMIsohyM08iZKUHRQO0U6SddwxBHKFCB2z8jANdmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fdU1c0oCRcA4kM1L5jXYlrHcwwTr5q5ahDyes6sJhrdPpsprarfFT1U+0RdtZiHZd
	 gXYhz6JsH6g7i3i+b5UK1phiJ9OUjeOcdJyCEcosJFoz56qNWPZRx+9I51BISeyJCk
	 PEqVYL7sYSSEacXAYdvlf7Vd2fPQh4x3dsgZmVYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernd Schubert <bschubert@ddn.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	stable@kernel.org
Subject: [PATCH 6.10 038/375] fuse: disable the combination of passthrough and writeback cache
Date: Tue, 10 Sep 2024 11:27:15 +0200
Message-ID: <20240910092623.508078195@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernd Schubert <bschubert@ddn.com>

commit 3ab394b363c5fd14b231e335fb6746ddfb93aaaa upstream.

Current design and handling of passthrough is without fuse
caching and with that FUSE_WRITEBACK_CACHE is conflicting.

Fixes: 7dc4e97a4f9a ("fuse: introduce FUSE_PASSTHROUGH capability")
Cc: stable@kernel.org # v6.9
Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Acked-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/inode.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -1336,11 +1336,16 @@ static void process_init_reply(struct fu
 			 * on a stacked fs (e.g. overlayfs) themselves and with
 			 * max_stack_depth == 1, FUSE fs can be stacked as the
 			 * underlying fs of a stacked fs (e.g. overlayfs).
+			 *
+			 * Also don't allow the combination of FUSE_PASSTHROUGH
+			 * and FUSE_WRITEBACK_CACHE, current design doesn't handle
+			 * them together.
 			 */
 			if (IS_ENABLED(CONFIG_FUSE_PASSTHROUGH) &&
 			    (flags & FUSE_PASSTHROUGH) &&
 			    arg->max_stack_depth > 0 &&
-			    arg->max_stack_depth <= FILESYSTEM_MAX_STACK_DEPTH) {
+			    arg->max_stack_depth <= FILESYSTEM_MAX_STACK_DEPTH &&
+			    !(flags & FUSE_WRITEBACK_CACHE))  {
 				fc->passthrough = 1;
 				fc->max_stack_depth = arg->max_stack_depth;
 				fm->sb->s_stack_depth = arg->max_stack_depth;


