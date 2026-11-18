Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039535;
	b=tcOeNyIVBk4rlf8kqegu8tO2U0itfcNXGcKByLQrv4cFR1sRATas/DODtNlCuc0I3+nW
	 Edko2hvzB+/ORi9yG/D35BhTA7C23HocMGcmIAFDwPbUjNDfBdUrb22EGmpqI8PuWKN9+
	 N+56omvRfKgZyPuZ5D0HN1wIaatJAo0F10qwu2PEaTlkFOb/bt1a3abwPfL29cUCoJ3iT
	 VGmfNX+1ciBv4fDlwKZv9faMcJnNXeBgo81CvMnOmw4zTjbqN3yG71I5wF0CriscC+kbJ
	 bbxw4p/fk5s/nahl1cKyfd84ZAg/lxDIZAyyB1Eq855iJhdbjMtinTjVDss6NW+jG+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039535;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BLDoy+fH+fvpVWMUzUPdwJ2KQ7tBoAG5CQlaXLmPydQ=;
	b=AC6WV59vuVW/lO99xdgzNqhD1lkH2BANC93fF/UHF+JyCiL49gVJcCyR+Mt2D7dHo6an
	 Qz+sIj9aueG4H/LOuOtOhmMJJTM6W3wPQy7T6V+eY1gk+UI2o6XhAIYl3XEVpA5afkYZz
	 kPV4FT1wB9N0p4l8QkBrkxwzlzYAYsG+HCVK9dWIET67Mm/mi0JNe54r5yFlRnN07NWdl
	 B6bPRXYiPddKkSi28z0YXxwKR8dSDcF+Bd3pLGQ135cd+uB4HxFCngBwYPd/7aoVCX1pN
	 fJVtSyYKaD6WMfZw5jFjUqpj8xfDgiRDSIVeIyFv8qFT0vVkyli1MNEvvDaJVkyK6ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yB7eOtch;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D753B606A32A;
	Wed, 18 Nov 2026 22:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yB7eOtch
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E68BA1F000C8;
	Wed, 18 Nov 2026 22:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039535;
	bh=BLDoy+fH+fvpVWMUzUPdwJ2KQ7tBoAG5CQlaXLmPydQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yB7eOtchutvJEOmpKSogXG8NEYZFgYF4fUp7JEWFLmXF9J1z5H96k7HJ/3vGDKcUa
	 jwjC+TDS043BTyCnTbDfJiYuVx8NXqHKg+tZr+gcj36NIEl9w7c0TYVEwIDYTFRvYt
	 sPEymeakh5y1m9WaZ85nwmMGl/CrF80r/jznfMwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2133/3318] scsi: mpi3mr: Fix buffer overflow in the BSG target device map
Date: Wed, 18 Nov 2026 15:45:55 +0100
Message-ID: <20261118150426.054879452@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

[ Upstream commit 203b3072e7aa10d98b3f2b766693ea925cfc571d ]

The size of the target device map buffer is held in a u16 while the number
of devices it is derived from is not bounded to fit. With enough devices
the size wraps, a short buffer is allocated, and the loop that fills it
writes past the end.

Do the calculation in size_t.

Fixes: fb428a2005fc ("scsi: mpi3mr: Fix issues in mpi3mr_get_all_tgt_info()")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Link: https://patch.msgid.link/20260825210411.301535-14-chandrakanth.patil@broadcom.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 9f846019211a0..55cea461059d5 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -309,7 +309,8 @@ static long mpi3mr_bsg_pel_enable(struct mpi3mr_ioc *mrioc,
 static long mpi3mr_get_all_tgt_info(struct mpi3mr_ioc *mrioc,
 	struct bsg_job *job)
 {
-	u16 num_devices = 0, i = 0, size;
+	u16 num_devices = 0, i = 0;
+	size_t size;
 	unsigned long flags;
 	struct mpi3mr_tgt_dev *tgtdev;
 	struct mpi3mr_device_map_info *devmap_info = NULL;
@@ -335,8 +336,8 @@ static long mpi3mr_get_all_tgt_info(struct mpi3mr_ioc *mrioc,
 		return 0;
 	}
 
-	kern_entrylen = num_devices * sizeof(*devmap_info);
-	size = sizeof(u64) + kern_entrylen;
+	kern_entrylen = (uint32_t)num_devices * sizeof(*devmap_info);
+	size = sizeof(u64) + (size_t)kern_entrylen;
 	alltgt_info = kzalloc(size, GFP_KERNEL);
 	if (!alltgt_info)
 		return -ENOMEM;
-- 
2.53.0



