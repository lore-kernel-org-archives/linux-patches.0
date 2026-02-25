Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4B61E2834;
	Wed, 25 Feb 2026 01:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983166; cv=none; b=DIhSzsFYi4L/2ZevgNV7husD0cSn1aEPJhqorFO8N8J/CBBbWRsfHfJuIz4BfxhhvcbfdzoAj6hlMqgOScyxbwv4EV3NgBxM5cWZXQgsbOGKWISboy7oYpSccxmnH0uT3CDlizeTGX5CC2iQMcdLQirAD2XAdCi3RWDPWChHRgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983166; c=relaxed/simple;
	bh=lOnmgYQZFemExmFwYGlzA5nGfl77QwpTYwV0iUY2VVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kWJJDDBzlweeyVtUCylrFukFgq0djODvwrtqcWZLh1meSmromErOE6yFBxQqcpKpl6zx0gj6XkWzF8Dkr6ULT4O07vzuZtRrD7GDSneyQrnb0UWfv7jlWJGBPvzufsLFhK5tnqRYVZ3lvFAbFWlaLK/RMhEOGd6I5VjTv4yVhC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XA6sXylA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XA6sXylA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6E24C116D0;
	Wed, 25 Feb 2026 01:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983166;
	bh=lOnmgYQZFemExmFwYGlzA5nGfl77QwpTYwV0iUY2VVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XA6sXylAb5/R4TCLdV/FIodcYbwsz7bcOk7kP9fEdUuWltlgBepxS8F66yCCR5KVf
	 HBov5BD+irVKnuk9bkbBS9ab30ukGW9udGF2DdtGx+BME9yKDMEAYz/C4eAs/+EkCw
	 b0+y53/xQR1z5krIPm614gK2GTGKFHwoK+rYcxPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Maciej Falkowski <maciej.falkowski@linux.intel.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 301/781] accel/amdxdna: Fix incorrect error code returned for failed chain command
Date: Tue, 24 Feb 2026 17:16:50 -0800
Message-ID: <20260225012407.091328793@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit 750817a7c41de083ca5d73052e97bb7b67d7c394 ]

The driver currently returns an incorrect error code when a chain command
fails. In this case, ERT_CMD_STATE_ERROR is expected to be reported for
failed chain commands.

Fixes: aac243092b70 ("accel/amdxdna: Add command execution")
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Reviewed-by: Maciej Falkowski <maciej.falkowski@linux.intel.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260203184037.2751889-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/aie2_ctx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/accel/amdxdna/aie2_ctx.c b/drivers/accel/amdxdna/aie2_ctx.c
index ad5b5cd0bc81f..fe8f9783a73c7 100644
--- a/drivers/accel/amdxdna/aie2_ctx.c
+++ b/drivers/accel/amdxdna/aie2_ctx.c
@@ -274,7 +274,7 @@ aie2_sched_cmdlist_resp_handler(void *handle, void __iomem *data, size_t size)
 		ret = -EINVAL;
 		goto out;
 	}
-	amdxdna_cmd_set_state(cmd_abo, fail_cmd_status);
+	amdxdna_cmd_set_state(cmd_abo, ERT_CMD_STATE_ERROR);
 
 	if (amdxdna_cmd_get_op(cmd_abo) == ERT_CMD_CHAIN) {
 		struct amdxdna_cmd_chain *cc = amdxdna_cmd_get_payload(cmd_abo, NULL);
-- 
2.51.0



