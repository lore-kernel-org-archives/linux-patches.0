Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46220331A7E;
	Thu, 28 May 2026 20:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001361; cv=none; b=PGEjxIYrV64PgdM8YhTIUWw1+TovOMevmDZaeK9Om6VYy9jDnx3Fzf9USmElJ+2JSwAsikWa6zxRhAxP1NWorFu5ZsWBCJ0OWWGyB87fD+85Y1fmS5GPrCIjvD/HDbLQJI/8F5uWmWwhvTiug3H6++A9OE6rDcITpT+a/vuWqyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001361; c=relaxed/simple;
	bh=HwncqfSRUmMvSdYVClF21KsJaNLvxuNK0KFDzTlOwo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nnGzTfWduyViDObUw47dpc3ysPzHxVHgASluqSBTnfs6Jg1YPz9LJYxhYF3PsXMDeIqbRS9jkfMt504lSqO0RPF+stah2rw8f5sb8EngWqVu+s/OyrjrrXCJNkGs0UkV78msUKO0l+NiBclk1jTsa0hgExXnlTqjmeOhGitpyaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LsHnkQY0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LsHnkQY0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3D801F000E9;
	Thu, 28 May 2026 20:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001360;
	bh=7pf0e9nGe/WOlC++onfGbVwZ+jXT7R0mtfkb9Q86aHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LsHnkQY0KT/oex2veuWHcpR6BR20Lj1t5OFYRMHrAg4NBSmm5WP2UTSX7TD1pwQvZ
	 DwrX2cD2sI0gXQoYFZ/87dUy7BIyulIw1I8rZEec8QPLmwBmy/BAP3Iq26LjfQlJGf
	 7OIvQE6n1N3H7aqkQ01OGMuQQAh/QV7ADzBHkLp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 099/186] firmware: arm_ffa: Skip free_pages on RX buffer alloc failure
Date: Thu, 28 May 2026 21:49:39 +0200
Message-ID: <20260528194931.606707292@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

From: Sudeep Holla <sudeep.holla@kernel.org>

[ Upstream commit 09527e2c534911619d7e098729711100290bc3e1 ]

If the RX buffer allocation fails in ffa_init(), the error path jumps to
free_pages even though no buffer has been allocated yet. Route that case
directly to free_drv_info so the cleanup path is only used after at
least one RX/TX buffer allocation has succeeded.

Fixes: 3bbfe9871005 ("firmware: arm_ffa: Add initial Arm FFA driver support")
Link: https://patch.msgid.link/20260428-ffa_fixes-v2-2-8595ae450034@kernel.org
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_ffa/driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index 488f8345dd1b6..ece91d8d820b5 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -743,7 +743,7 @@ static int __init ffa_init(void)
 	drv_info->rx_buffer = alloc_pages_exact(RXTX_BUFFER_SIZE, GFP_KERNEL);
 	if (!drv_info->rx_buffer) {
 		ret = -ENOMEM;
-		goto free_pages;
+		goto free_drv_info;
 	}
 
 	drv_info->tx_buffer = alloc_pages_exact(RXTX_BUFFER_SIZE, GFP_KERNEL);
-- 
2.53.0



