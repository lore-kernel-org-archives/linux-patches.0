Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E747321576C;
	Thu, 12 Dec 2024 15:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016004; cv=none; b=q1D5hOrifMQC5Ye7tQ2uSpY3hgzoz3tn+psMXP8zIxibLQk2LxV1zhhSTGZGE+d3S3mCTMBwerwJpMD+WfHmp0T1bSF1Q4UmQud3+aGbE9jik8sSCTO6c8UEKystMBeGa0Z1DzbtNtvZ0hLEdNe8gFLOJaqu7mN8URRbH5UK86Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016004; c=relaxed/simple;
	bh=0hPJ8J68dfzh5vzjzOO5QMv5REGXmxQb8FI4OUArdAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aXv3NDeMHlRr+rziW/+a0UGP314ny3UBe6qpehoa9i/zHk3ppUiYb0Wr41vODh706QGq58ChfpmxSdHBWhCCmP/JbR47ZQIUYGStoOMM2Io7hPZZdBA08/5niozTPyceSUjTyVDfM0OIgYZS3DKg+9nmFMlmEoLheUTUT3gYNhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VbI85SEI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VbI85SEI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D7DFC4CED7;
	Thu, 12 Dec 2024 15:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016003;
	bh=0hPJ8J68dfzh5vzjzOO5QMv5REGXmxQb8FI4OUArdAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VbI85SEIWG9RU/19qyUzLWjLYNVJozq9jX7BGW1V74kcecivRQiQRI7/E3hCMG8Yy
	 wVY9gK/6kKj7SABIEvOyIlGYd1WXz8xEDPxaiScJa1z3abuvtaEKAzyqim+qMN++t/
	 YC/GWBCx9AIAqRHYgIia9yvRw1ZaJHcbPbqG6C/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Laurence Oberman <loberman@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 105/466] nvme-fabrics: handle zero MAXCMD without closing the connection
Date: Thu, 12 Dec 2024 15:54:34 +0100
Message-ID: <20241212144310.964726207@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit 88c23a32b851e36adc4ab36f796d9b711f47e2bb ]

The NVMe specification states that MAXCMD is mandatory
for NVMe-over-Fabrics implementations. However, some NVMe/TCP
and NVMe/FC arrays from major vendors have buggy firmware
that reports MAXCMD as zero in the Identify Controller data structure.

Currently, the implementation closes the connection in such cases,
completely preventing the host from connecting to the target.

Fix the issue by printing a clear error message about the firmware bug
and allowing the connection to proceed. It assumes that the
target supports a MAXCMD value of SQSIZE + 1. If any issues arise,
the user can manually adjust SQSIZE to mitigate them.

Fixes: 4999568184e5 ("nvme-fabrics: check max outstanding commands")
Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reviewed-by: Laurence Oberman <loberman@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index fe83d31ac928b..ec03b25eacbbc 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3251,8 +3251,9 @@ static int nvme_check_ctrl_fabric_info(struct nvme_ctrl *ctrl, struct nvme_id_ct
 	}
 
 	if (!ctrl->maxcmd) {
-		dev_err(ctrl->device, "Maximum outstanding commands is 0\n");
-		return -EINVAL;
+		dev_warn(ctrl->device,
+			"Firmware bug: maximum outstanding commands is 0\n");
+		ctrl->maxcmd = ctrl->sqsize + 1;
 	}
 
 	return 0;
-- 
2.43.0



