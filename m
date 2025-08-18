Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6012B26F2A7;
	Mon, 18 Aug 2025 12:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521508; cv=none; b=HvH2yUGvDj970kO85O849rRhW/5vlOo6lSkpVzYu9YGyQs6a18z7aFe1shxjq3Gk+yEm73ev0dr6sSsjNSlJWi2fVbXXHj/ogasxYk2tGw6RIANEnWZ5n7YGY9vlvswPl2ISgllIT3Lv+t7Uhl8E/58BR9qDPpXEP4FjoxD1DdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521508; c=relaxed/simple;
	bh=EcS991L5/QR/wySYFgfKha1KGaz52t/xMNvjJqNGKiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ys9AElZ/dAKilXc3KCQsypq+V1o92yaKNKGl3aymaz8UOzB4BYDlFm4C/1+D6Np1ELoIyEg0ZG/XZFRxcAQ3OGw9TMFKoP10P6Z5Cbh+lCLY/Q6Y9bMNcr11r32+7eZ3qqIVR66lbBFN5zsppVM5OEvdaOestxGXCW7aiX15+lI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iNvl6s07; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iNvl6s07"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C543FC4CEEB;
	Mon, 18 Aug 2025 12:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521508;
	bh=EcS991L5/QR/wySYFgfKha1KGaz52t/xMNvjJqNGKiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iNvl6s07SLm2oQE1yJR7GP7NsUPd5SRTDeJgv5kjxYxWM4kbleTsOFSju7FCaBSdL
	 4u9TrBqlPmaJCgiJ6y/Tgl1aFZ24oOyUeVS3yw3pqk31lUS4KNxS0796TSXjwhDvW5
	 ZMvvimKGXjgffZgG0wTvTOP4vx83lkH9eeOfBm/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Wang Zhaolong <wangzhaolong@huaweicloud.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 007/444] smb: client: remove redundant lstrp update in negotiate protocol
Date: Mon, 18 Aug 2025 14:40:33 +0200
Message-ID: <20250818124449.180608635@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Wang Zhaolong <wangzhaolong@huaweicloud.com>

commit e19d8dd694d261ac26adb2a26121a37c107c81ad upstream.

Commit 34331d7beed7 ("smb: client: fix first command failure during
re-negotiation") addressed a race condition by updating lstrp before
entering negotiate state. However, this approach may have some unintended
side effects.

The lstrp field is documented as "when we got last response from this
server", and updating it before actually receiving a server response
could potentially affect other mechanisms that rely on this timestamp.
For example, the SMB echo detection logic also uses lstrp as a reference
point. In scenarios with frequent user operations during reconnect states,
the repeated calls to cifs_negotiate_protocol() might continuously
update lstrp, which could interfere with the echo detection timing.

Additionally, commit 266b5d02e14f ("smb: client: fix race condition in
negotiate timeout by using more precise timing") introduced a dedicated
neg_start field specifically for tracking negotiate start time. This
provides a more precise solution for the original race condition while
preserving the intended semantics of lstrp.

Since the race condition is now properly handled by the neg_start
mechanism, the lstrp update in cifs_negotiate_protocol() is no longer
necessary and can be safely removed.

Fixes: 266b5d02e14f ("smb: client: fix race condition in negotiate timeout by using more precise timing")
Cc: stable@vger.kernel.org
Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: Wang Zhaolong <wangzhaolong@huaweicloud.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/connect.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -4001,7 +4001,6 @@ retry:
 		return 0;
 	}
 
-	server->lstrp = jiffies;
 	server->tcpStatus = CifsInNegotiate;
 	server->neg_start = jiffies;
 	spin_unlock(&server->srv_lock);


