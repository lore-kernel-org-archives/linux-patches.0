Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5FC5284662;
	Tue, 21 Jul 2026 19:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663195; cv=none; b=FQrgGr5J0ISfOVK/04E9to0Ac/3a9yNxJCrh9a7vzvz4qgwj+o973aWIKMvYYaPyY1T4ZV6XwH7FWddU0yREBjbW1k1XWiaIRG3oq5KYUghDsAI5kHJMu1xrzeZTHU2URnU2rlzvWP8H/7943aJbXJ/uA+TAvFDfiAIpYfc5/Wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663195; c=relaxed/simple;
	bh=qTlJKP3gcLL2kFeyYhz8f/AxRwPxGF/G1Ocrk9Jwdn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XD/irXsOH8udFZ4aMHArIC24Y8Si8Jfu4UBVMd01V5yliLxrC2fYXXQrMIqLm4A+5QzdeAMN0LTlJCVyZ0ZwDhEpdbN4rEz5cK9TxqWbOlORA5g8M8X/Cnl5BdaBVg5w7dknOQyiSQdpItTzRiQA51U4iwa39M+IUpHi4zl4r+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wtCksp4b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wtCksp4b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EBD21F000E9;
	Tue, 21 Jul 2026 19:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663194;
	bh=SqQFVniVGKwm/tqL9ZKGTSZGsjDfSOIQQGb+VjjFi4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wtCksp4b0wawEKAZQhfCy81MTrpzbNANJHaE4tEl6AHkhG7a36i8Z3jSaJ/LeCO+h
	 trXowkwUZYg4+Lj72TnesaPUe+ud1BzP+hLywh72EN5sR4Yh4q4UI69afyOGoJbt51
	 W+DcH/zlNDL/dNNY2I6l6pkrMVfQJNlkLV5iChFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0729/1276] afs: use kvfree() to free memory allocated by kvcalloc()
Date: Tue, 21 Jul 2026 17:19:32 +0200
Message-ID: <20260721152502.398081250@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit cb39654926f8e7a08ecc1dcb3941628855275940 ]

op->more_files is allocated with kvcalloc() but released via
afs_put_operation(), which uses kfree() internally. This mismach prevents
the resource from being released properly and may lead to undefined
behavior.

Fix this by using kvfree() to free op->more_files to match its allocation
method.

Fixes: e49c7b2f6de7 ("afs: Build an abstraction around an "operation" concept")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260622090856.2746629-8-dhowells@redhat.com
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/fs_operation.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/afs/fs_operation.c b/fs/afs/fs_operation.c
index 428721bbe4f6e3..384cd893d87827 100644
--- a/fs/afs/fs_operation.c
+++ b/fs/afs/fs_operation.c
@@ -249,7 +249,7 @@ int afs_put_operation(struct afs_operation *op)
 		for (i = 0; i < op->nr_files - 2; i++)
 			if (op->more_files[i].put_vnode)
 				iput(&op->more_files[i].vnode->netfs.inode);
-		kfree(op->more_files);
+		kvfree(op->more_files);
 	}
 
 	if (op->estate) {
-- 
2.53.0



