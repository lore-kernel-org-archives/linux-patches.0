Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2106A471251;
	Tue, 21 Jul 2026 20:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666927; cv=none; b=K4wutXQGxqbgXRXIjYpRF/Oe24DvBJWBPaI7rHjImFIcfZ8qjVSFWHis4HHvXUj4UZbvpqLwNHqMKehq3q2ouMN2yT+iDKolX3wa1ptLaixDnKqkVXNT5j7WgVswJ6+kwvqUbK9V22SlhamWb/QF7/Pm1Z87YhgQFsiMWPlGP/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666927; c=relaxed/simple;
	bh=HQVBO/9AhrVgXOsZk0PaIyT8+1ySIbzUOGtJE1pO25Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CyYjTseJDj4i6wxuWo1g/D3ZpTjiSix7VKpNPghBQmzKYYbJX9x51bb16UetsnXbrr7G8luinYKShfjdLt3/osi/3Cf+dU3elcTZwFdWXJRSW1/Ofy/u/bCYeanvMKMbQ7JElxx4a9Zfhfje/GkWz7SVUxZkEdw+R+lDZxoDf3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lAgLJfg1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lAgLJfg1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 335E31F00A3D;
	Tue, 21 Jul 2026 20:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666924;
	bh=D4/e58yJdLBur/Djys1wShnu5Q2m/+54rCPezgekmM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lAgLJfg1PJZOlzzN3NrAaEg5sYiWdY77nm1zuZgRNf/AcOu+pGGdX02eM1p183bFd
	 ZzSQO08d0/Vz7xWRbxLQNRFyQdW66uI3f4bn1chJYlCJ1Llw9zy0YX2w+hDTxl36ch
	 m/LX5AQ5PQZJQB8DJJVDB8+scPTib0Ckc+lhcnmE=
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
Subject: [PATCH 6.6 0830/1266] afs: use kvfree() to free memory allocated by kvcalloc()
Date: Tue, 21 Jul 2026 17:21:07 +0200
Message-ID: <20260721152500.427031716@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7a3803ce3a2297..4316cce855cd7c 100644
--- a/fs/afs/fs_operation.c
+++ b/fs/afs/fs_operation.c
@@ -240,7 +240,7 @@ int afs_put_operation(struct afs_operation *op)
 		for (i = 0; i < op->nr_files - 2; i++)
 			if (op->more_files[i].put_vnode)
 				iput(&op->more_files[i].vnode->netfs.inode);
-		kfree(op->more_files);
+		kvfree(op->more_files);
 	}
 
 	afs_end_cursor(&op->ac);
-- 
2.53.0



