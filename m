Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673422581;
	Tue, 23 Jan 2024 00:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969631; cv=none; b=aVZM/pYh6TZaKxyCIMIyzoIOceuh4UMu3CjO3h6fPGJhatYgIBwQ1PThOo223gNtp7wJAUZzKkcvnb+CJNe4ME+4i2Z3/TRK10xNx8dKGvyfVUg7jMqt8HNhaYTSjwP8PuZ6d8uBRZ8u113xpzPNtXD9aDc9FAYijqipf8T0Jqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969631; c=relaxed/simple;
	bh=BHM0avGNNUxruQKH7nxGd2ODEwOoZq1ekisH53K43UE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i+b0y5mjA3D1gzRokd9fu6dDI3oKerjNRJ7IgoP/pZjWW23LNjFMQGY44CQ7gMoP69Eimu1d4uSs+g85h7GvWpT+8RRKu7Mea5Gl1i3x9Hq+Pe2DWgU6M52t9MNf7LGdDe9EftL6jJtnXbrKaIf3Qk/uyru+7djoGJz3uORm838=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TjJW/eaU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TjJW/eaU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1716FC433F1;
	Tue, 23 Jan 2024 00:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969631;
	bh=BHM0avGNNUxruQKH7nxGd2ODEwOoZq1ekisH53K43UE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TjJW/eaUSh+Yk9K17ze3fkxegya9FDS3wlcInq51n/yWqIMDF/JrQKxyILEH6TcIq
	 GPuQc4gIV3I2+1vCUoSuo1PvWc7PmtyPUdYRDWiCdb8BahE6vVNGqMZ3Vz+LTSEFzV
	 r/TOzJcMigXcZepXs1EcpGEyAFIai1MgJwLv73EY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingyuan Mo <hdthky0@gmail.com>,
	Oded Gabbay <ogabbay@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 346/641] accel/habanalabs: fix information leak in sec_attest_info()
Date: Mon, 22 Jan 2024 15:54:10 -0800
Message-ID: <20240122235828.754167044@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xingyuan Mo <hdthky0@gmail.com>

[ Upstream commit a9f07790a4b2250f0140e9a61c7f842fd9b618c7 ]

This function may copy the pad0 field of struct hl_info_sec_attest to user
mode which has not been initialized, resulting in leakage of kernel heap
data to user mode. To prevent this, use kzalloc() to allocate and zero out
the buffer, which can also eliminate other uninitialized holes, if any.

Fixes: 0c88760f8f5e ("habanalabs/gaudi2: add secured attestation info uapi")
Signed-off-by: Xingyuan Mo <hdthky0@gmail.com>
Reviewed-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/habanalabs/common/habanalabs_ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/accel/habanalabs/common/habanalabs_ioctl.c b/drivers/accel/habanalabs/common/habanalabs_ioctl.c
index 8ef36effb95b..a7cd625d82c0 100644
--- a/drivers/accel/habanalabs/common/habanalabs_ioctl.c
+++ b/drivers/accel/habanalabs/common/habanalabs_ioctl.c
@@ -685,7 +685,7 @@ static int sec_attest_info(struct hl_fpriv *hpriv, struct hl_info_args *args)
 	if (!sec_attest_info)
 		return -ENOMEM;
 
-	info = kmalloc(sizeof(*info), GFP_KERNEL);
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
 	if (!info) {
 		rc = -ENOMEM;
 		goto free_sec_attest_info;
-- 
2.43.0



