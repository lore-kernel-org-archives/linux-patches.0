Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 158272DF9F;
	Tue, 20 Feb 2024 21:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464153; cv=none; b=Z47XOOOCXbBJUdxJmneigRH0FDzdC9Ol8bgmQJ7Er8ORadrmH1BhKXwn9t4EvCRGzXa+1Y73aPY7bhrciZ2qe/b/7U8YnYEcl6xYCXtguwksoXIndoZ+vGvA9x2KCxLYy7B5jJ3JAsooCCFK5lbw9n5z9ZrWoVvEUq0ZtobDgIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464153; c=relaxed/simple;
	bh=uda1AIHKIo+fjayH1DWX1MQyTQm2rEY4cIB0uXDqato=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nbp6HcGa3sJnsfk1s/Rf2BtmTmnhHr3+Sr5ecjG59+Sc6LHHG/uYGdbuhB/jnpwIQJHcItj9f68p2GINLjtehl28Uu8Ztnu03aJc9Gvh5ctt7PoULP4ah6uCoW80nqvwXpFC0z4s9G2IMFEnwzNEo9gDx2aDZuU24CnnDAUB1os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1iyNL3VW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1iyNL3VW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FA5BC433C7;
	Tue, 20 Feb 2024 21:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464152;
	bh=uda1AIHKIo+fjayH1DWX1MQyTQm2rEY4cIB0uXDqato=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1iyNL3VWP3eAc2VgjDLq5mFuKN7wx4n7ur79rClr/kSkrFV/UqYtD9baUSEctIAVT
	 g+3pbPNkm7A80ZmaQSY+bZIpWyOQiME8PVs1Kplb0w8EfR5w6feviUFuBBtVTU7EF3
	 v2751+wJSXIeP1vPrKsTEB5oBQv71ITfhzXkQ+Eo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Julia Lawall <julia.lawall@inria.fr>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 267/331] eventfs: Fix failure path in eventfs_create_events_dir()
Date: Tue, 20 Feb 2024 21:56:23 +0100
Message-ID: <20240220205646.277218449@linuxfoundation.org>
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

commit 7e8ad67c9b5c11e990c320ed7e7563f2301672a7 upstream.

The failure path of allocating ei goes to a path that dereferences ei.
Add another label that skips over the ei dereferences to do the rest of
the clean up.

Link: https://lore.kernel.org/all/70e7bace-561c-95f-1117-706c2c220bc@inria.fr/
Link: https://lore.kernel.org/linux-trace-kernel/20231019204132.6662fef0@gandalf.local.home

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Fixes: 5790b1fb3d67 ("eventfs: Remove eventfs_file and just use eventfs_inode")
Reported-by: Julia Lawall <julia.lawall@inria.fr>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -735,7 +735,7 @@ struct eventfs_inode *eventfs_create_eve
 
 	ei = kzalloc(sizeof(*ei), GFP_KERNEL);
 	if (!ei)
-		goto fail;
+		goto fail_ei;
 
 	inode = tracefs_get_inode(dentry->d_sb);
 	if (unlikely(!inode))
@@ -781,6 +781,7 @@ struct eventfs_inode *eventfs_create_eve
  fail:
 	kfree(ei->d_children);
 	kfree(ei);
+ fail_ei:
 	tracefs_failed_creating(dentry);
 	return ERR_PTR(-ENOMEM);
 }


