Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0284446A5FD;
	Tue, 21 Jul 2026 18:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658065; cv=none; b=tTWyOsRZ/E9uTLuiwUBhW8J69w51u4Mg+KczwZxHTo8b4SaTp0V67OfaqEqqaq86VA0NH6q2OiJfkDzPiOpybysLJ9rjSgu5uctox7nxrmJrRg3wi3nisy+zhofun/baxF8Ylyxxh7M7o/l7Zh7mTdfxjhxzF+GRfCcHqwSJcQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658065; c=relaxed/simple;
	bh=uDXIpfB3QeqX+++x/kRLNvNNtl8o8Af5aGbAOSCNuFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R5P0RW8bkXU/xrVX4wOnQxkawFfONMtWZM41HG74l4w48iKOwlRBhxhv+Sk2lMSJpVmq4xhfsYE6jSu4mkMsdAKiovrlDYDASU8mlztwzgA8qbwcDehO3U7xYZR9xI2Ew6O+o10HBhDZbReM8PR+fSSZVD3Mxo2PCGXtOVWAZ2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GnaZCPMk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GnaZCPMk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D31A1F000E9;
	Tue, 21 Jul 2026 18:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658063;
	bh=yKkB03f4JCmLJ9occhM/L4k4IDpJqOJISc9nkgEmgEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GnaZCPMkitlozM+ZgRQR+PVO7hvGZV1JDbYKErPhi0zcVyYSvA0yXWjLMwDzL0rt+
	 EQXJAf+yFVplc0Br//dkUnk7jTWVTdQNWhOSBLXGSALlY5jm074DzJpwRL6mWuNJ+z
	 SEga0AZKTVJahHw/OCRRg8IXzowoAYhkhbSF71r8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	David Howells <dhowells@redhat.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1002/1611] afs: Remove erroneous seq |= 1 in volume lookup loop
Date: Tue, 21 Jul 2026 17:18:38 +0200
Message-ID: <20260721152537.931728915@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit a58edda50a3ec08e6adac1d04dc3e488494e412d ]

The `seq |= 1` operation in the volume lookup loop is incorrect because:
seq is already incremented at start, making it odd in next iteration
which triggers lock, but The `|= 1` operation causes seq to be even
and unintended lockless operation

Remove this erroneous operation to maintain proper lock sequencing.

Fixes: 32222f09782f ("afs: Apply server breaks to mmap'd files in the call processor")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260622090856.2746629-9-dhowells@redhat.com
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/callback.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/afs/callback.c b/fs/afs/callback.c
index 894d2bad6b6cec..833ac3178ddc75 100644
--- a/fs/afs/callback.c
+++ b/fs/afs/callback.c
@@ -140,7 +140,6 @@ static struct afs_volume *afs_lookup_volume_rcu(struct afs_cell *cell,
 			break;
 		if (!need_seqretry(&cell->volume_lock, seq))
 			break;
-		seq |= 1; /* Want a lock next time */
 	}
 
 	done_seqretry(&cell->volume_lock, seq);
-- 
2.53.0



