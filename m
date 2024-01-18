Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97811B96D;
	Thu, 18 Jan 2024 10:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575104; cv=none; b=e1pVTUJYUrwGQDN9/YOMQTTCX+HUA839z5ZXSHDqgHfJ/ped0oDulH7hDROEl7KQ3HGxcGbM5s2xBQWsIYzxkLQVMJHGZqkCwTbvnVMxA6p5m/g4ltHkE3K2E70FBiuqE0AKqHu66gZih2GKwB1JcNoVLIN/WxLS3GPR0JX+qHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575104; c=relaxed/simple;
	bh=6Q2TMEgs7U6YHMf3bY3KX/wPKVeAHxE4MPVV0xoA1lA=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=lJBjzQzdynzIK4wo7g8hvuPhGqoPYgJCORp6oYcOjxbqfdkp7zw2Foicxy+k6fH0J4djyNSzIueT7cvIKXF1Vsi02bhcBufL/ACX+2QR6gho7t9CjZWchuv3Q4/Q+PvHP5xnWx6aRUc0UdvuqgoITVilX1doZt+1WIaqegWXeJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ti2irIZd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ti2irIZd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B8ECC43399;
	Thu, 18 Jan 2024 10:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575104;
	bh=6Q2TMEgs7U6YHMf3bY3KX/wPKVeAHxE4MPVV0xoA1lA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ti2irIZdRPwEMbumqu3zFC522TB6tzViIBOlEocGD08UcwQ8LryW1MQpTzFSIZdfm
	 fHai4xkwP2FX265sdVrmFPfXic+EPZkVtlSv1l7LAM9iBTcxF7TS9hqX/j6KhyZVU5
	 LZzs572oEVJOF9y9IXPULQSt3gYkoswNkMImM/eY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 013/150] nvme-core: fix a memory leak in nvme_ns_info_from_identify()
Date: Thu, 18 Jan 2024 11:47:15 +0100
Message-ID: <20240118104320.641070157@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit e3139cef8257fcab1725441e2fd5fd0ccb5481b1 ]

In case of error, free the nvme_id_ns structure that was allocated
by nvme_identify_ns().

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index b32e3cff37b1..212991308bbe 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1479,7 +1479,8 @@ static int nvme_ns_info_from_identify(struct nvme_ctrl *ctrl,
 	if (id->ncap == 0) {
 		/* namespace not allocated or attached */
 		info->is_removed = true;
-		return -ENODEV;
+		ret = -ENODEV;
+		goto error;
 	}
 
 	info->anagrpid = id->anagrpid;
@@ -1497,8 +1498,10 @@ static int nvme_ns_info_from_identify(struct nvme_ctrl *ctrl,
 		    !memchr_inv(ids->nguid, 0, sizeof(ids->nguid)))
 			memcpy(ids->nguid, id->nguid, sizeof(ids->nguid));
 	}
+
+error:
 	kfree(id);
-	return 0;
+	return ret;
 }
 
 static int nvme_ns_info_from_id_cs_indep(struct nvme_ctrl *ctrl,
-- 
2.43.0



