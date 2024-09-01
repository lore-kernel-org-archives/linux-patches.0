Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB281DFD1;
	Sun,  1 Sep 2024 16:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209595; cv=none; b=qlItwR/91prehuwpq1e/odVfPvO12BXUzUklX2BHs6APPu/j2QAmy7t5wpDLLLgsWkSvnSc+CkBiJrt1NIXIfCgFNU/KL6n/eKhskXJulhGCTNmshg2+t5syEl0ek6Zp9TSlU+O39sR79CuCI4zCfd1k9Haby2mzoZx8JUUj+0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209595; c=relaxed/simple;
	bh=0ldbB0CY/Lh1KwTUbvPpZUrs71qVU2wT0lJRSKn8MP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NX/2FTzk28nRmqIQzMfxXHtxzY4tNevjS6+q6LIF9KpMZ0+dOMx25AOJ5/bSckMXlMBR3wuLu9YyVaKgBuflw12eqO7CG7dm5/g29T1+GeBdiagbjgh+90726oKsOn1R2qp/sqfRWIowqMc7DeoO9n0NQY3W08f9MeEeYbjSq9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LGqOF3x8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LGqOF3x8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12D79C4CEC3;
	Sun,  1 Sep 2024 16:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209595;
	bh=0ldbB0CY/Lh1KwTUbvPpZUrs71qVU2wT0lJRSKn8MP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LGqOF3x8aA95LpfSM4w7nqW2mYtZ4Hfpi/jqejFPWjbKThrpuykGQ928qJ+v0fWGa
	 lekOcoFh6pB11AC3xK0pSEEDJI+jRo6g6GQL8Hd+1feewm1teKgDMkj+sRF+5hJy/d
	 /xzeZIGXv5Z/3Y+4HMI6Etbes0SdQnCTyQjOW1s8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 085/151] dm suspend: return -ERESTARTSYS instead of -EINTR
Date: Sun,  1 Sep 2024 18:17:25 +0200
Message-ID: <20240901160817.317434443@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index dc8498b4b5c13..b56ea42ab7d2b 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2343,7 +2343,7 @@ static int dm_wait_for_bios_completion(struct mapped_device *md, long task_state
 			break;
 
 		if (signal_pending_state(task_state, current)) {
-			r = -EINTR;
+			r = -ERESTARTSYS;
 			break;
 		}
 
@@ -2368,7 +2368,7 @@ static int dm_wait_for_completion(struct mapped_device *md, long task_state)
 			break;
 
 		if (signal_pending_state(task_state, current)) {
-			r = -EINTR;
+			r = -ERESTARTSYS;
 			break;
 		}
 
-- 
2.43.0



