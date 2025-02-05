Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42FA7151988;
	Wed,  5 Feb 2025 14:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765925; cv=none; b=vEsOtYkO62dy6E6k43rsju9+MFcfSNDF3ZzaJAPLl2eZruNtRDh3niUN/fRnLJ+nEO7n4XwOnU1H8QV/uFZa2gfHtH4ddr6aOAOOH8zEAe+rhIhvowhzJNuKQIawkMQkDPAZ+pdhPP3aG8aHFlsIurTyPEmSKzrKh/Ua3gaycm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765925; c=relaxed/simple;
	bh=uZfcU1VOIuiddUQeOhoqxcgVKEdT1MO0S9czkR1WNY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SBFtCgjwmLyO21t468NBhQRFohffYPfk57xWPuS2mWDT5xjKbulCNsKq/gw+LqFyTRJJt0HdpJdfTNFOkvmCxE+OIvMpaASI9R+Zhwl014eh9S2d1v8igPXJPx+ftyn0EXjpAq7FFj9ECCRqTqIqilA/+GCfrrSFn0tNhuKrbR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jDIJ70uz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jDIJ70uz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6A53C4CED6;
	Wed,  5 Feb 2025 14:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765925;
	bh=uZfcU1VOIuiddUQeOhoqxcgVKEdT1MO0S9czkR1WNY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jDIJ70uzDsSpUo9aEMfg73O0QvIAmNwFHXYEPYTi8e41EzIMG8mSmAJNc+r2ZSjmC
	 u5GIWLQh6VQDJQoKRwhgadIVZJd3sXL7s9HlUc5z1x1zk4leg36An149feCEUQQyv8
	 zET71zycMsAFsXiPFXxOaGvU4aU7jcfTsbX0mEmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 226/623] dev: Acquire netdev_rename_lock before restoring dev->name in dev_change_name().
Date: Wed,  5 Feb 2025 14:39:28 +0100
Message-ID: <20250205134504.870327761@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit e361560a7912958ba3059f51e7dd21612d119169 ]

The cited commit forgot to add netdev_rename_lock in one of the
error paths in dev_change_name().

Let's hold netdev_rename_lock before restoring the old dev->name.

Fixes: 0840556e5a3a ("net: Protect dev->name by seqlock.")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250115095545.52709-2-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index a9f62f5aeb840..7600820bed6bd 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1279,7 +1279,9 @@ int dev_change_name(struct net_device *dev, const char *newname)
 rollback:
 	ret = device_rename(&dev->dev, dev->name);
 	if (ret) {
+		write_seqlock_bh(&netdev_rename_lock);
 		memcpy(dev->name, oldname, IFNAMSIZ);
+		write_sequnlock_bh(&netdev_rename_lock);
 		WRITE_ONCE(dev->name_assign_type, old_assign_type);
 		up_write(&devnet_rename_sem);
 		return ret;
-- 
2.39.5



