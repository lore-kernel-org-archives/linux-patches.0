Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2FB04ED1A5;
	Thu, 17 Sep 2026 17:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665260; cv=none; b=Jd3EEJyHpOkaOgPHcwupWefbf1ZMazFxyMtPpVFUv56ifpf7uqpRzbIb6WArMnU/7ZqTIwqOgSN+cVpPHJmcjat4cM1iIw7cicu4pmOYIjr+vmiThwuzzveVK9YJeDxu+Bl/NX2q+6ypYMUha15UHE8xVEv9MmY4I/S4K1aKeNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665260; c=relaxed/simple;
	bh=1t1RQrjFLsqLy4cgga9ncWyUF04ZnyTdbCi6w/z84Iw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CGIxKsIXrR7zj2qdQdVWWT+inLkxd6vgubgOwK32YH5clngO9nkWbSNJeXTyn0nHquyILnhT/m6x4nkLjwV0H5LP7sM0P16wsogB/3UcZAvqWNvVZ7HZN3qM5puycYW3YM9mArOipUiOk9rbsKc2I8behQ3zXvSMst7CJPAUDrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OYerVbXq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OYerVbXq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 101371F000FF;
	Thu, 17 Sep 2026 17:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665257;
	bh=kAKsts0ChwcLshceyR+rDYzHRYkrhoqgnX7U/cHp+bo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OYerVbXqPsUrjwak9T8UQMBl/XXdoJ15amaWiQCvGQQECu4a+wQ/FlFHhLalgwrPk
	 Hoeo/nNZIGiMQE/lgyCgoXu7DMA8CQ44e8F2Ad3l4Jkix9kF1SdKrVFpO8sEILR4eK
	 S/Jb7YlwzK652EvznzwRJpQDjzJb9RyGHo/nBnl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0643/1250] netfs: Fix error vs transferred passed to ->ki_complete()
Date: Thu, 17 Sep 2026 16:07:18 +0100
Message-ID: <20260917151609.320682111@linuxfoundation.org>
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

[ Upstream commit 0bfe2571a6af653611860d0e24c4e4c83bae7a54 ]

Fix netfs_unbuffered_write_done() to pass the amount written to
->ki_complete() rather than the error in the event of a partially complete
transfer.

Fixes: a0b4c7a49137e ("netfs: Fix unbuffered/DIO writes to dispatch subrequests in strict sequence")
Link: https://sashiko.dev/#/patchset/20260824120224.504575-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260827134304.2075713-4-dhowells@redhat.com
Acked-by: Paulo Alcantara <pc@manguebit.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/direct_write.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/netfs/direct_write.c b/fs/netfs/direct_write.c
index cc5151ea75a11..4b81e8a6fb438 100644
--- a/fs/netfs/direct_write.c
+++ b/fs/netfs/direct_write.c
@@ -51,7 +51,7 @@ static void netfs_unbuffered_write_done(struct netfs_io_request *wreq)
 		wreq->iocb->ki_pos += written;
 		if (wreq->iocb->ki_complete) {
 			trace_netfs_rreq(wreq, netfs_rreq_trace_ki_complete);
-			wreq->iocb->ki_complete(wreq->iocb, wreq->error ?: written);
+			wreq->iocb->ki_complete(wreq->iocb, written ?: wreq->error);
 		}
 		wreq->iocb = VFS_PTR_POISON;
 	}
-- 
2.53.0



