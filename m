Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B7621F09B3;
	Fri, 21 Nov 2025 13:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731938; cv=none; b=khxRJd1vdP+/ZerD6OA8nfHPbjBepbI8Cpily+dhkSw5Qda7rSK3kZJsYFgldMkg8/yRxpFBQXfay74WOTpSZ5ZtkpPeNyCriDzxLYMtRXir51GzwhKJIPomXr8izER6MGx4037tK8mC4NcatdxUxziSHGUbiuz4IGDhm9D5VO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731938; c=relaxed/simple;
	bh=vZRfWjYkSesOn3i2PaYErBU78Cu2sHiJIZKvz2kEdHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RrtZCQFa/43tE9kg0oMURUDzx21RjkIIB6bkT/cgdCYCbKy/7gakUjSACye4z+VV6ZcucoQbKfwp9Fi7U+PsGpF3wCBHLFGZeLPRdNG1jzfQCGOqFenuUG07mPGo97d4t62kCGeHE1mFvCuuiE3HqyhBDlx4ukDQ7lp2xINMSSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OaAJyPf5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OaAJyPf5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2784FC4CEF1;
	Fri, 21 Nov 2025 13:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731938;
	bh=vZRfWjYkSesOn3i2PaYErBU78Cu2sHiJIZKvz2kEdHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OaAJyPf5juhG5xn9okNh6fy0EFsG8cwnpIa7GsjQ012h3r50xHW1ooZn3ccPR4Qid
	 WWGfb3i7O4ft2DhmkBuiTW/elYRlDiK+ccO7mKIHBgJP2pW9yH8fGy12eMx07KNmK+
	 m1qRx/ds7sfUlOejsqiK5dQU3KS9QYn/F7hEsEsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 134/185] smb: client: fix cifs_pick_channel when channel needs reconnect
Date: Fri, 21 Nov 2025 14:12:41 +0100
Message-ID: <20251121130148.710628781@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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
@@ -1050,7 +1050,7 @@ struct TCP_Server_Info *cifs_pick_channe
 		if (!server || server->terminate)
 			continue;
 
-		if (CIFS_CHAN_NEEDS_RECONNECT(ses, i))
+		if (CIFS_CHAN_NEEDS_RECONNECT(ses, cur))
 			continue;
 
 		/*


