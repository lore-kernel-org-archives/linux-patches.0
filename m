Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 345CF2FF64E;
	Fri, 21 Nov 2025 13:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731413; cv=none; b=fn/RKq+OOcd4cJWBr1LAnO3VbWCGaCx1IDI/pQWEov6dB0q5uh0dlbGb3SGb3c8Y1i4DyDEEo+ZcFX4etYfimxuzZE2rWNPQbDKo82HBVk+NjlnFgU1Ayjcf92bbfVaXK3Tvw2r+sQh9XoGfe63kNjrItjsbrdwpojiHdFr9Dag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731413; c=relaxed/simple;
	bh=wQuwa6nkFSis8CN0HyLYrZpDb0ZQx5aEgKlBXGmdAy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qrpq/10oA8SUpmWZNbDDTegiA3bBMuyPZmWCu1DBqWB5zJEve/12iYNi6yOO8GM6G8qZdTzrpkqnVmJtecaAe7YZrUNM5nIU9Y5dSt8HKTYUXQqDrYOHiEtEELOAoZddQ6lGVspwDxivrp5OtDqv2sllEukrUK99/PeoszxmxWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wWxJ6lnt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wWxJ6lnt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0B6CC4CEF1;
	Fri, 21 Nov 2025 13:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731413;
	bh=wQuwa6nkFSis8CN0HyLYrZpDb0ZQx5aEgKlBXGmdAy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wWxJ6lntaGkrAec+QBHg431ir/cN4LhAR1THGEh9eUQB0rLlWwSDmxNxa1OV6YIFl
	 1mHU/XGkxTGWzCZR9Q1ytBgxvW61VPjDyZbvVj02/1rUfPg+BCDIscmH1JWfKw9Y1s
	 VZd73e+QIiR+WyLJzJ1PtVvD4agVjT8Dmzcl57zc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.17 200/247] smb: client: fix cifs_pick_channel when channel needs reconnect
Date: Fri, 21 Nov 2025 14:12:27 +0100
Message-ID: <20251121130201.902942066@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henrique Carvalho <henrique.carvalho@suse.com>

commit 79280191c2fd7f24899bbd640003b5389d3c109c upstream.

cifs_pick_channel iterates candidate channels using cur. The
reconnect-state test mistakenly used a different variable.

This checked the wrong slot and would cause us to skip a healthy channel
and to dispatch on one that needs reconnect, occasionally failing
operations when a channel was down.

Fix by replacing for the correct variable.

Fixes: fc43a8ac396d ("cifs: cifs_pick_channel should try selecting active channels")
Cc: stable@vger.kernel.org
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/transport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -831,7 +831,7 @@ struct TCP_Server_Info *cifs_pick_channe
 		if (!server || server->terminate)
 			continue;
 
-		if (CIFS_CHAN_NEEDS_RECONNECT(ses, i))
+		if (CIFS_CHAN_NEEDS_RECONNECT(ses, cur))
 			continue;
 
 		/*


