Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3290282F5;
	Mon,  6 Jan 2025 15:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179165; cv=none; b=UCyIv8oo/izI+T030VEVykooqnELSpqlabWwx/fbwJj5HKVkxGMPJqQU0Lv9XaGZ73RU6OcTBVdBsjP4epy6ooPstkBe/8aYL+KMsPx6izN5NC+lGmYEP/DqXzszzZMY8BfvaEBrQhLw0vPkSBJMuGmKj9z7E0Xgy0bQbbbonfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179165; c=relaxed/simple;
	bh=EDCpKnP1fJjp+f84uGO1XBq7dFqA/ErNtEjMr9mo4mg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eN8XUF//Tc4ANK6XdgqBm88Ygh18yOPAdhBMcIlhxbZiMPnRRRiNdqJq7qgVpkcONzuMlfQnhr8Mi0nD+T3b03TpGECIyXh7JnFr822rKG4folf+DRGN8eN3UTuStNcEcAF38PoD6ETbWvIXhJ7dDOCJXa3yQKKvRrson6PKDM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u2pcFue6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u2pcFue6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AB15C4CED2;
	Mon,  6 Jan 2025 15:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179165;
	bh=EDCpKnP1fJjp+f84uGO1XBq7dFqA/ErNtEjMr9mo4mg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u2pcFue6BtxaiDdAyXF8KsNG92NxHIr2EbGmYbuEVypq01r8+wIlKvxpRUMHBpOig
	 eqS4WqRfbcGZAwYWSmooOA4S5kwCeYgqRTNaP7MbBsPTLXFHYwODmC/bqPq7nT38Ly
	 KRfOFmu3EM3Ya2g3HJlPbxMa869Z5FL+7A2vkl4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomas Henzl <thenzl@redhat.com>,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 46/93] scsi: megaraid_sas: Fix for a potential deadlock
Date: Mon,  6 Jan 2025 16:17:22 +0100
Message-ID: <20250106151130.439186077@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
References: <20250106151128.686130933@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomas Henzl <thenzl@redhat.com>

[ Upstream commit 50740f4dc78b41dec7c8e39772619d5ba841ddd7 ]

This fixes a 'possible circular locking dependency detected' warning
      CPU0                    CPU1
      ----                    ----
 lock(&instance->reset_mutex);
                              lock(&shost->scan_mutex);
                              lock(&instance->reset_mutex);
 lock(&shost->scan_mutex);

Fix this by temporarily releasing the reset_mutex.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Link: https://lore.kernel.org/r/20240923174833.45345-1-thenzl@redhat.com
Acked-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 603c99fcb74e..7f2d12c5dc4b 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -8802,8 +8802,11 @@ megasas_aen_polling(struct work_struct *work)
 						   (ld_target_id / MEGASAS_MAX_DEV_PER_CHANNEL),
 						   (ld_target_id - MEGASAS_MAX_DEV_PER_CHANNEL),
 						   0);
-			if (sdev1)
+			if (sdev1) {
+				mutex_unlock(&instance->reset_mutex);
 				megasas_remove_scsi_device(sdev1);
+				mutex_lock(&instance->reset_mutex);
+			}
 
 			event_type = SCAN_VD_CHANNEL;
 			break;
-- 
2.39.5



