Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9EFC50279B;
	Thu, 17 Sep 2026 17:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666487; cv=none; b=Hmt0mCg6NcOJ8Pbu/0TgOBIDzvigeppih5dZz4W1SO8LbVFqGpuynB2N1ZWJVmERo45aZ25lOh2n4iwDenyGQBK8girplMXjfuDj2zpT2UH90KbtyY9BQwfVSOyTfS/AnOkXUmWWCk27CZAbkoxpRYpf7LsrO6bdpmQP/9Z+/c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666487; c=relaxed/simple;
	bh=d4U7d9mwMfYhzVmQqFaoSkDbeRNexmNKEyeYFYAyRYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TXW3yO5iUVeSCkNiK/0t+ysGLF2wIdI/BqL7MSDIO63oXWVxlCyOaht+tn7YuiXwKnpp9tW44K/A1U0abkZxcAC9bZaBRBepjEwDeOKt0ohdD6YJiCZJqvzPWU4BHgWgL0V66qofxMmyUSAWLBZn6ORDJooWjaxP8cDS+/trShk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eVx6TeR9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eVx6TeR9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2071C1F000FF;
	Thu, 17 Sep 2026 17:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666485;
	bh=1KeVZ+81yZZEL7etov3mpUV//iTiei6blrWxT9EFy20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eVx6TeR9PkQb33jbXAuomBu2khe1tKx+xzxfFJRqPCLF/9KiT4sw7A+KYA1fLMvN4
	 udSzXmIbymEwgbhRlP5G7yRG/BSvOp9R00ZGjNpNr5jwA5TBMB1hkbg8GyRty+iIGb
	 eT286zGGvVKAiCfU8QGrH6DjxBtv+1yMjr/lE5Ks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 1052/1250] afs: Fix missing kunmap in afs_dir_search_bucket()
Date: Thu, 17 Sep 2026 16:14:07 +0100
Message-ID: <20260917151620.634632291@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

commit 950ae84b5cc944fbe27d81806d0b76af765f779c upstream.

Fix afs_dir_search_bucket() to kunmap the block it's using in the "bad:"
path.

Fixes: a5b5beebcf96 ("afs: Use the contained hashtable to search a directory")
Closes: https://sashiko.dev/#/patchset/20260716103030.3065561-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260902121024.3328255-2-dhowells@redhat.com
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
cc: linux-fsdevel@vger.kernel.org
cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/afs/dir_search.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/afs/dir_search.c
+++ b/fs/afs/dir_search.c
@@ -173,12 +173,11 @@ int afs_dir_search_bucket(struct afs_dir
 
 	ret = -ENOENT;
 found:
+bad:
 	if (iter->block) {
 		kunmap_local(iter->block);
 		iter->block = NULL;
 	}
-
-bad:
 	if (ret == -ESTALE)
 		afs_invalidate_dir(iter->dvnode, afs_dir_invalid_iter_stale);
 	_leave(" = %d", ret);


