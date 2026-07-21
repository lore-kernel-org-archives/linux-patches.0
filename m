Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C7F322DB7;
	Tue, 21 Jul 2026 17:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653603; cv=none; b=QB/F8TjPIhH38lVmZrPavvHudn7hWEuPqmoQ3wuvLIgVc4dBWiiV8Qs96MDlBSBNjuw48WjVrZ0z1Y4G9yrPLnNMMIq7Cb0Rm54GgZB6wOeAgCgj7GM9HZct3lOZtmPLHq+aeq9YQ2+Ji8197pdK8rj0TccnPxh8Lx8RaabYYXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653603; c=relaxed/simple;
	bh=7D0XQk6pavZOdxvJb05dt8xAQWQFVxUbb+d4lz/fd6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ER6KL5VmWNcuFqfTk289KHdWRLwuGmZnWqg7XdXKxmbS6mQDV4VeMqg1qZ7MhFRHucOmMxdSec4Huouwo52ShWJDP+YcWMynxYbXCCzZ+OHmrC2yTo19qlPNhEaqFtAnyvR29/zSUxu+rbGyYSPcGbxFpXDH87gXdlYDi5QgHsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mMi0eokn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mMi0eokn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3289D1F000E9;
	Tue, 21 Jul 2026 17:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653602;
	bh=albir+uoPgyaX4zXIfDc4zv1ufdHOTWiaNRNeepiv6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mMi0eoknufKh/vuoEvpAgulYc0TXLHrrc4Xi1gXN2Qmiz8jZARhYHfg1x8wvpG4Nt
	 4E9hSiKQWO/ap4VlUtlT6u4qhZ1rQeVo+4+QIgX/YqBXUG3qVQbG6/HdLKfMO+vy7Y
	 1bDrzLCqk154B52A2wpnIP01DXwCPljrnr102jiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Deepakkumar Karn <dkarn@redhat.com>,
	linux-afs@lists.infradead.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1382/2077] afs: Fix leak of ungot volume
Date: Tue, 21 Jul 2026 17:17:35 +0200
Message-ID: <20260721152625.412461953@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit d672c276f685a540ed2b2a8bafaed4650a89022c ]

Fix afs_lookup_volume_rcu() so that it doesn't leak a dying volume if
afs_try_get_volume() fails.

Fixes: 32222f09782f ("afs: Apply server breaks to mmap'd files in the call processor")
Closes: https://sashiko.dev/#/patchset/20260609081738.770127-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260622090856.2746629-17-dhowells@redhat.com
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Deepakkumar Karn <dkarn@redhat.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/callback.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/afs/callback.c b/fs/afs/callback.c
index 74853e0d0435ae..61354003c006cf 100644
--- a/fs/afs/callback.c
+++ b/fs/afs/callback.c
@@ -134,6 +134,7 @@ static struct afs_volume *afs_lookup_volume_rcu(struct afs_cell *cell,
 
 		if (volume && afs_try_get_volume(volume, afs_volume_trace_get_callback))
 			break;
+		volume = NULL;
 	}
 
 	return volume;
-- 
2.53.0



