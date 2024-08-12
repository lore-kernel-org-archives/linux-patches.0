Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F001494B8;
	Mon, 12 Aug 2024 16:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480551; cv=none; b=lV2vrR9KvZTeG4aApYB2Vo2BzQcGLzvfmzk1i2Gn3IEjkexRd1Vcc7ouzajOwx5H/5N83hrlHJ0yi33oQuSRV74Yt4GH8SZo047TO3A+Wxd2XyWIYl1zhy6UHPudsJEisIIubZ+JO05APKVqQVvBk/tQYPb1ITZVin4O7RdxUK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480551; c=relaxed/simple;
	bh=L6nuubYUVgrakJBAonKNnytfUciV4U0gGEHVeU9Psb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dbQ2RPxQlF2j9wF8Iu1JuNVF1lhX6Cb9bFIPiNZD2rM/huKCn5dfnYcBrFkpSapLHtZ24/0+0HQT2HfGq+WrWnXKvz04QVHqniyTrnnf6Mcq5Hte5JYWcTHUpynuQJmeUyW9SLwF8SwHj7j7Yx7gIkWBkfkGqdEJSKqrlXh3+sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OmEorJXj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OmEorJXj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AC05C32782;
	Mon, 12 Aug 2024 16:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480551;
	bh=L6nuubYUVgrakJBAonKNnytfUciV4U0gGEHVeU9Psb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OmEorJXjZ1IEoFHPWLd6JAXBRitnEndUibptEZWg3UPkW0YVB8onYLiMedWUUFTvd
	 W7mAWJzhlIjG/ulLt8bou8N7SyW4EBnX+cxPOvUxxvln2MBkst8ESTV7A184hzHveQ
	 kg5IblOntjvF36QMdrxBvYks2jW3rBpYKdjGNvUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Mathias Krause <minipli@grsecurity.net>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.10 231/263] eventfs: Use SRCU for freeing eventfs_inodes
Date: Mon, 12 Aug 2024 18:03:52 +0200
Message-ID: <20240812160155.378927297@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

From: Mathias Krause <minipli@grsecurity.net>

commit 8e556432477e97ad6179c61b61a32bf5f1af2355 upstream.

To mirror the SRCU lock held in eventfs_iterate() when iterating over
eventfs inodes, use call_srcu() to free them too.

This was accidentally(?) degraded to RCU in commit 43aa6f97c2d0
("eventfs: Get rid of dentry pointers without refcounts").

Cc: Ajay Kaher <ajay.kaher@broadcom.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/20240723210755.8970-1-minipli@grsecurity.net
Fixes: 43aa6f97c2d0 ("eventfs: Get rid of dentry pointers without refcounts")
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -112,7 +112,7 @@ static void release_ei(struct kref *ref)
 			entry->release(entry->name, ei->data);
 	}
 
-	call_rcu(&ei->rcu, free_ei_rcu);
+	call_srcu(&eventfs_srcu, &ei->rcu, free_ei_rcu);
 }
 
 static inline void put_ei(struct eventfs_inode *ei)


