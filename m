Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673932B9C7;
	Sun,  1 Sep 2024 16:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208918; cv=none; b=qQPJoM4YrYHgzCuGR9+encWPkrjB5un/2mxO6A1T4SV6+Kj3SjYDpovI2rs4fzpZZtjV9te/hfanKaiEvnIYaKg5tUVkADR3a1wkE+fvD0I/0HqKQIYbMbV6l7PAThIBFd2xHgS51SAKYIfouvRwK2LPxrE6UNnrlOlU0q5rAaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208918; c=relaxed/simple;
	bh=wpNRJXqiISWo+nSpbqMf67eNdoYlq1HlAXOrzsOkFPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RygSWcyr2X4LkiPAhbPLkwaiZGhvKprjT0btHP7mjOi0tbDEMS9i1RJhpLuIuBzdr8NuFhLl68PJbCmzMQWtq4AieXj00BnD8uVf8QhYOHXY/TuRNHsXOSeFsYOl07zQxzJSouYaFXB0bQjfIkmU1R+2Wpp3IY+nF/aPI/qbPz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m8xlf54/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m8xlf54/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB675C4CEC3;
	Sun,  1 Sep 2024 16:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208918;
	bh=wpNRJXqiISWo+nSpbqMf67eNdoYlq1HlAXOrzsOkFPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m8xlf54/74MUMnuO0mSyhn6X2SF3c8kPWPBxgZ8KGe2UuO0PnlaOnfg+hpeWac59C
	 +itSybEALslkhWvMMpfXFzK0GArs6E/AlFoWYKSJt4OqjUXNLyaT1EIFmTXxQxXlgY
	 ECqG1Ks4XCs/6m2mgsllIl8REWoKZ7VvsLiW7hiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 079/134] dm suspend: return -ERESTARTSYS instead of -EINTR
Date: Sun,  1 Sep 2024 18:17:05 +0200
Message-ID: <20240901160813.073066804@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index f6f5b68a6950b..3d00bb98d702b 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2432,7 +2432,7 @@ static int dm_wait_for_bios_completion(struct mapped_device *md, long task_state
 			break;
 
 		if (signal_pending_state(task_state, current)) {
-			r = -EINTR;
+			r = -ERESTARTSYS;
 			break;
 		}
 
@@ -2457,7 +2457,7 @@ static int dm_wait_for_completion(struct mapped_device *md, long task_state)
 			break;
 
 		if (signal_pending_state(task_state, current)) {
-			r = -EINTR;
+			r = -ERESTARTSYS;
 			break;
 		}
 
-- 
2.43.0



