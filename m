Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023344;
	b=bbBz4K7jFSjRtB2MuntvoC91Ka11LWisxr8vR1QD49XDEcS9mXnb6G9nmouosv+BqJ8w
	 Q+ehSheOSMQLH6oktofG8Mng1tGfY64raHXs44N3FO70Vvph0VVNCkj6LwE3/Q8zbaC6V
	 i3yW8SoOKM6crVr7ohzDiZNP2z4/pN9Dc9A74VA0UzYeO/pRvevWRCNCOdjOheTC87+XL
	 upyLtbWPvYwLb4S/KiKn/TaQWNurVeiFqrAjhD9WDphgDsHrFeN0W2zpqWT8HHHIMF8Ie
	 bmp/4dt+v4a1HOzyS5FInBxqkVq0kP9MgHy+HEQvjVggK1hx6Csh9UYvPhyRPw+wo7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023344;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=flYrxIK8vLfuWGJ0GWQ5qZF/eQBK5fbeml/IBl0g8G4=;
	b=kOhKuis88Rqkzqk6wMvC10/0UMLfg5WllmGv2/E7g9Jw33YksB1RDELnHUmqALAAljdI
	 2Rm3n8aguRs6MK+Pzlm3CzU0ayZQ5A8uoB3N16CS6r1AwSASZqqvxsQZh72cqlDSNb1dZ
	 GuaL7si8VA9uiUqDG9BllJLTqGk4sSocPrhedzzmkZGinOQ6cpJMUxeZ02jBMWu2bZzMU
	 G+Xt6zhw30oea7xE4Ueenu5hvGLLOVes2/8k1xJtTwjw/VzBazeewzOy25jEo/q4/QEmz
	 cE0/zRxtX5ZAYzRXazlq3e1V6X6nNpEaf3fm+RtKiwTyFsEQX+GvRPFzW9hV7tJsmxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uRphtW7i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF3D4606A331;
	Wed, 18 Nov 2026 17:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uRphtW7i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A13C1F000C9;
	Wed, 18 Nov 2026 17:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023344;
	bh=flYrxIK8vLfuWGJ0GWQ5qZF/eQBK5fbeml/IBl0g8G4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uRphtW7igXK2om1aL65J0V9X+TikmkzF8ME+FJarISbN6UupZX5iBeLGOKfWrsgE7
	 nErdnDXwFwk+DFKLC+SVYe3vPy0TD8GSHtYfOa7PcTuBx9W+7Kx9XJwZY3bMbQqY3t
	 TK2xXAsk860VlVaoiPwDvOoOPraIykd1vXcb1FvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0334/2151] scsi: mpi3mr: Fix target device reference leak in device removal handshake
Date: Wed, 18 Nov 2026 15:34:29 +0100
Message-ID: <20261118150134.160853527@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

[ Upstream commit a04b0f3a17e32aa449fd896163a7b40efc29c4f5 ]

The device removal handshake looks up the target device to update its state
but never drops the reference that the lookup takes.

Drop it once the state has been updated.

Fixes: 13ef29ea4aa0 ("scsi: mpi3mr: Add support for device add/remove event handling")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Link: https://patch.msgid.link/20260825210411.301535-10-chandrakanth.patil@broadcom.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 848afd656cf2e..ba7bd376536d4 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2448,6 +2448,9 @@ static void mpi3mr_dev_rmhs_send_tm(struct mpi3mr_ioc *mrioc, u16 handle,
 		tgtdev->state = MPI3MR_DEV_REMOVE_HS_STARTED;
 	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
 
+	if (tgtdev)
+		mpi3mr_tgtdev_put(tgtdev);
+
 	if (drv_cmd)
 		goto issue_cmd;
 	do {
-- 
2.53.0



