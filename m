Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37EF51774B;
	Thu, 18 Jan 2024 10:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575516; cv=none; b=hlX/Eim5r391N0MH0/a9Vh/uqGFShoagukAcevRZBjk51V3/eYZ6EhUlqjNm2Ve95D8en7dU4L5W0JNRYIEabngiQkxPnA7ehxufeOXWNIvBuxVrBHHkWGByfOr6Ra6v64gdY2BrnEIQ30WwIzaKvsc4eo8HqazLKCW+1CtLtf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575516; c=relaxed/simple;
	bh=gXgZKWPkCMuNo89Qxu+1ZpzQpDBkAtkgu7/BpF/atWQ=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=FTJJuYinD24M2ldTq3ELaoUl5Uhi4ZpUTiDEdNlmDWm1oKVz0KTK7YxUEDzfs3xL6pRYW4lTWbZiIQvZuXpFGxj9WLh4qY4mnYOg0POJtjOk4mdhawG1GhUdt5X3cvZ/a1NFmLl25mSJTHd5fiS5gOCmL6ON8w5ZwHQouvSIPe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WO2mJmYK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WO2mJmYK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD3AEC433C7;
	Thu, 18 Jan 2024 10:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575516;
	bh=gXgZKWPkCMuNo89Qxu+1ZpzQpDBkAtkgu7/BpF/atWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WO2mJmYKP3Ol9NQAnnrgnZ5TGv+mETyEvtnCUJBvrTdrUiAl8113CGhUinjLysWAN
	 wh0dLiyTGKTXrRIi3v9lVPqXN5XoCnMtni2p5blnqA7WLy2yiSU3U2xEvIJHIoZ+CW
	 /nCjpLOzHoQyS6ZW5P8q3Lzr2lpm+e2QPkTyQIgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 010/100] nvme-core: fix a memory leak in nvme_ns_info_from_identify()
Date: Thu, 18 Jan 2024 11:48:18 +0100
Message-ID: <20240118104311.318366141@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104310.892180084@linuxfoundation.org>
References: <20240118104310.892180084@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5b906dbb1096..67c893934c80 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1511,7 +1511,8 @@ static int nvme_ns_info_from_identify(struct nvme_ctrl *ctrl,
 	if (id->ncap == 0) {
 		/* namespace not allocated or attached */
 		info->is_removed = true;
-		return -ENODEV;
+		ret = -ENODEV;
+		goto error;
 	}
 
 	info->anagrpid = id->anagrpid;
@@ -1529,8 +1530,10 @@ static int nvme_ns_info_from_identify(struct nvme_ctrl *ctrl,
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



