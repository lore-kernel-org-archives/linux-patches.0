Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE88A35A92E;
	Fri,  9 Jan 2026 12:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960799; cv=none; b=HP+AINzTpAwrkZShVAhEG+W9vdJuWP8TEzVoNzG+GescT46K7UXg5Qe1Tfqa+6hvJBSswp6agGH/bHrVgZa4Khd7Sf9SVSyPmEFj8zpgtC1i++Si3s7XaUmxe+ubkAQRzinYTB10ssgSLwogVo/XSGosIbKCCbEdyowr6I1QIKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960799; c=relaxed/simple;
	bh=2ARUMDVLobUXt0T3aQ3PIX35+xdLA+1X6G80x/zBKTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FdYXOtG1HzVkf/eM7/18UPLKqKVlD7t6hMCWjpdDUJ+F/6pqZQWGNlP2VQ/iDDcBniA6jGMnTp9PPSxFEOJbmhq/6+bY5IxGrtkxSccdUSNLxE6guGBPhtG7KbO0C8jHRE8xa8alKi+MlpihwkxpCCk1E6TrtMTmoPE5xhhEhRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gQxd9T1c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gQxd9T1c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22D7CC16AAE;
	Fri,  9 Jan 2026 12:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960799;
	bh=2ARUMDVLobUXt0T3aQ3PIX35+xdLA+1X6G80x/zBKTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gQxd9T1cnPsbmMMJBkiX6ek5pA7f/eCS8qC/Tf98nZEto+jFeWJsdtxVFP3EXKgos
	 UJCpPTdzq8dieC+2AFMIOJMPen9+svodjVEV+7hFbNT673tnVlwjIGTmCGIYnkSpEz
	 ErzmRtAf6ZnVURfdBhaEUnC5mZINfBX2e8Ph/Veo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fatma Alwasmi <falwasmi@purdue.edu>,
	Pwnverse <stanksal@purdue.edu>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 528/737] net: rose: fix invalid array index in rose_kill_by_device()
Date: Fri,  9 Jan 2026 12:41:07 +0100
Message-ID: <20260109112153.859043841@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Pwnverse <stanksal@purdue.edu>

[ Upstream commit 6595beb40fb0ec47223d3f6058ee40354694c8e4 ]

rose_kill_by_device() collects sockets into a local array[] and then
iterates over them to disconnect sockets bound to a device being brought
down.

The loop mistakenly indexes array[cnt] instead of array[i]. For cnt <
ARRAY_SIZE(array), this reads an uninitialized entry; for cnt ==
ARRAY_SIZE(array), it is an out-of-bounds read. Either case can lead to
an invalid socket pointer dereference and also leaks references taken
via sock_hold().

Fix the index to use i.

Fixes: 64b8bc7d5f143 ("net/rose: fix races in rose_kill_by_device()")
Co-developed-by: Fatma Alwasmi <falwasmi@purdue.edu>
Signed-off-by: Fatma Alwasmi <falwasmi@purdue.edu>
Signed-off-by: Pwnverse <stanksal@purdue.edu>
Link: https://patch.msgid.link/20251222212227.4116041-1-ritviktanksalkar@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rose/af_rose.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index 614695444b6a..1cc5eaeb1c60 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -205,7 +205,7 @@ static void rose_kill_by_device(struct net_device *dev)
 	spin_unlock_bh(&rose_list_lock);
 
 	for (i = 0; i < cnt; i++) {
-		sk = array[cnt];
+		sk = array[i];
 		rose = rose_sk(sk);
 		lock_sock(sk);
 		spin_lock_bh(&rose_list_lock);
-- 
2.51.0



