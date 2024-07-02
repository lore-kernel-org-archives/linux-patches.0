Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB391BE22A;
	Tue,  2 Jul 2024 17:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940237; cv=none; b=ZpzR+nipo52IzmO+bXSKUjGYMrjjmcwc7IC03uy+LmbZuZv1OjJxdcrHJCFQlfthrqZDYtUzI+sgPcWoJmYMqYhJrGvLaSyALgi9zVheumlwH9xoZ6MYCqcaX911Vvj5ZoqhjjGKdcK+b0A471iwutTbvpPV1WjcQLzh89p9jR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940237; c=relaxed/simple;
	bh=t7nXTK/xcQ6pyN5R7EHWxzO4woGgjexDpMAmA4LgjsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IMBt0NlezoH5HA5gIdKRzgGx6K8xQe0rW21yMaGeHwOGRjvS6NjZqMzmJKqwfmSA47CRVGIEX+gPY6HBcvc21Cfqa7bA4sNprVfQ0kD+tp1BI5lWAkHKsHAcoNglhITYBvAMN0cy19TANUnKdT+ezVyt5XHRHg2XldJZDXLJhtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DVqI3NZT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DVqI3NZT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 703B2C116B1;
	Tue,  2 Jul 2024 17:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940236;
	bh=t7nXTK/xcQ6pyN5R7EHWxzO4woGgjexDpMAmA4LgjsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DVqI3NZTxzWeOctTddUpp7mnh1tpwy2J0k1TJ/rxZnQNn/f+5WwD5tx2hiscxCdu3
	 w9QNSQxdDGC+uTMBGB7jtRLW6nsniI28RD9wOP6RyRnIIbYwB7cCmdzQ6HrFszODmy
	 jiAi8neU9fJ9e8In2DDdXm5Nsk67kZVup1P52C4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 094/222] nvmet: do not return reserved for empty TSAS values
Date: Tue,  2 Jul 2024 19:02:12 +0200
Message-ID: <20240702170247.566062331@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Reinecke <hare@kernel.org>

[ Upstream commit f31e85a4d7c6ac4a3e014129c9cdc31592ea29f3 ]

The 'TSAS' value is only defined for TCP and RDMA, but returning
'reserved' for undefined values tricked nvmetcli to try to write
'reserved' when restoring from a config file. This caused an error
and the configuration would not be applied.

Fixes: 3f123494db72 ("nvmet: make TCP sectype settable via configfs")
Signed-off-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/configfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/target/configfs.c b/drivers/nvme/target/configfs.c
index dfdff6aba6953..c9640e6d10cab 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -410,7 +410,7 @@ static ssize_t nvmet_addr_tsas_show(struct config_item *item,
 				return sprintf(page, "%s\n", nvmet_addr_tsas_rdma[i].name);
 		}
 	}
-	return sprintf(page, "reserved\n");
+	return sprintf(page, "\n");
 }
 
 static ssize_t nvmet_addr_tsas_store(struct config_item *item,
-- 
2.43.0



