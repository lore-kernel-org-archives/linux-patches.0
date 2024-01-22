Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5CEC6313F;
	Tue, 23 Jan 2024 01:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975024; cv=none; b=o4TWbufkYiY8lZk5/+QYIz4c9xrup/ZkOWvJ+knsvE82LsLlFz9A9xFIYRXn1rCRZto3DNomZuIqIh9SD48KHtF0Saoql2Ey0HbL6ALsynHuXyrZdUU+z1GZxnNonK7CMM2cffWYgHj02s0mNT4d2sSOZB6bjAXGNZfrfNwL78k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975024; c=relaxed/simple;
	bh=gX8QS4GztEV8tTIjLnS7Dt2BdlKyHbH0jlwhW9i+nKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MOL/I0cQAfsDcypmVAYe9kxF5brp4N9+oYzGkNNc7NxBqFwQXsRL7sZQ5BQpZnbTgSK6YSWrfNjTOSyulP5I5vmEuXTG4AwALLwVqR6FxGaWQo9L+TujaENN7Bk/78K2a56EqdpD55hKuxjTAe64zIs9HQyxuFyTEL3Dv5ppc1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FEv1PVx7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FEv1PVx7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC312C433B1;
	Tue, 23 Jan 2024 01:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975023;
	bh=gX8QS4GztEV8tTIjLnS7Dt2BdlKyHbH0jlwhW9i+nKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FEv1PVx75ONrszvAwGt8+W1q11NRi9Imp8a4vefigIFAXLtYtP7y6ZO7peedwL2JC
	 jwgGWdT6WJL6t11emrc9S7/veX7knNPoSfnhCDEKegIvPHJkBzB7yWtne0EPLg6NrO
	 Ch9BAHCdJNDdm/KSOx9O0P9Zfr6tfctsk495TW0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 328/374] nvmet: re-fix tracing strncpy() warning
Date: Mon, 22 Jan 2024 15:59:44 -0800
Message-ID: <20240122235756.311993468@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 4ee7ffeb4ce50c80bc4504db6f39b25a2df6bcf4 ]

An earlier patch had tried to address a warning about a string copy with
missing zero termination:

drivers/nvme/target/trace.h:52:3: warning: ‘strncpy’ specified bound 32 equals destination size [-Wstringop-truncation]

The new version causes a different warning with some compiler versions, notably
gcc-9 and gcc-10, and also misses the zero padding that was apparently done
intentionally in the original code:

drivers/nvme/target/trace.h:56:2: error: 'strncpy' specified bound depends on the length of the source argument [-Werror=stringop-overflow=]

Change it to use strscpy_pad() with the original length, which will give
a properly padded and zero-terminated string as well as avoiding the warning.

Fixes: d86481e924a7 ("nvmet: use min of device_path and disk len")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/trace.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/nvme/target/trace.h b/drivers/nvme/target/trace.h
index 6109b3806b12..155334ddc13f 100644
--- a/drivers/nvme/target/trace.h
+++ b/drivers/nvme/target/trace.h
@@ -53,8 +53,7 @@ static inline void __assign_req_name(char *name, struct nvmet_req *req)
 		return;
 	}
 
-	strncpy(name, req->ns->device_path,
-		min_t(size_t, DISK_NAME_LEN, strlen(req->ns->device_path)));
+	strscpy_pad(name, req->ns->device_path, DISK_NAME_LEN);
 }
 #endif
 
-- 
2.43.0



