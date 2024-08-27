Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A85F01C5783;
	Tue, 27 Aug 2024 14:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770526; cv=none; b=MtM6gH2R+ATMKYPEPYHcD7lcveoSBO9jvChi/7nGvuPr9a3ZqejW6ytAyTDswBEvf0Fh/zluYVGf1Z58eTtXFivmcZwL/B9HSrv6s+Yv164NB9HPo4Gn5ARP37BaEuR6a+vtixU+Z0IABXG5b2sDB4Phfy4MjR/WZh6bjTYgKgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770526; c=relaxed/simple;
	bh=nTphnBLXs/DuwIUbGPNlDGtyvJsutCk2ds8VAehEOJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ffqQ1aNynGPcdaB9crMHcstSvy/ZMSBNhrjLsCXgGXAchSji5jJi7F70HL4prRAqLacqf+KzwN2lbCAQBfiX7dOfcrTnUR4k6wppawPfIcT5ElkTW/C9onJYYhyT72G94kvaC080Dl3oaT3lQtNvBRoXrniT1ZtAtHN4k8GX51U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TvF9ZORq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TvF9ZORq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28E47C4E691;
	Tue, 27 Aug 2024 14:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770526;
	bh=nTphnBLXs/DuwIUbGPNlDGtyvJsutCk2ds8VAehEOJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TvF9ZORqGt5ECl84RPXdktTrnotb2wpL9gwhvvTFaoItFHpC5Em3VkgOyzfk6grxk
	 dREtVvSLBJlO2WanRJGJFMkAytOKsgjVW78M/WLeeYecGDp9RFGaKeL5Kfcwc3Ampg
	 t1t3bGNCs4ZjkwcUmv4JVLf1JFVG3BVisLyYQWGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 225/341] dm suspend: return -ERESTARTSYS instead of -EINTR
Date: Tue, 27 Aug 2024 16:37:36 +0200
Message-ID: <20240827143851.974987078@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 1e1fd567d32fcf7544c6e09e0e5bc6c650da6e23 ]

This commit changes device mapper, so that it returns -ERESTARTSYS
instead of -EINTR when it is interrupted by a signal (so that the ioctl
can be restarted).

The manpage signal(7) says that the ioctl function should be restarted if
the signal was handled with SA_RESTART.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index f945ee453457b..8ec0a263744a5 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2531,7 +2531,7 @@ static int dm_wait_for_bios_completion(struct mapped_device *md, unsigned int ta
 			break;
 
 		if (signal_pending_state(task_state, current)) {
-			r = -EINTR;
+			r = -ERESTARTSYS;
 			break;
 		}
 
@@ -2556,7 +2556,7 @@ static int dm_wait_for_completion(struct mapped_device *md, unsigned int task_st
 			break;
 
 		if (signal_pending_state(task_state, current)) {
-			r = -EINTR;
+			r = -ERESTARTSYS;
 			break;
 		}
 
-- 
2.43.0



