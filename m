Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF2C13B2A2;
	Tue, 27 Feb 2024 14:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042870; cv=none; b=rl2vP2CEmZ4v6X3qx7xeDv843AziHz/0EL8mfsO257JewnmmEa7YXjrO5IzSq9WFXNaafYb37nulr+urUC7+mi/uVpyncXlTDobAXGpxjG+8kRdE3Th56UpT/0rGphqpall1EXbPiMdhoSpDGDIl9d/l/qBWJJ+nL2W3aA0b7do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042870; c=relaxed/simple;
	bh=BGLiPZWXgvJFl9uBQRYbQ3tz2ueEFDwK1PlqYbiQDiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HqERHYlpmtD0vUCjJs0JDkofawIjXZQL2Cz/CKacdKejvB4lN0gU/8PyhWChzJyDnCHtz0ecY45ORqF6OIMgQlEa6td+VnhHGmi/p0NSv39AfS+Weez2sXTF8WgdKYCmHPsY+luS+bIzKX3P3YxG2XZZD9DNU5BjPdcGfOEOJIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZLbXwVij; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZLbXwVij"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 330A5C433C7;
	Tue, 27 Feb 2024 14:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042870;
	bh=BGLiPZWXgvJFl9uBQRYbQ3tz2ueEFDwK1PlqYbiQDiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZLbXwVijPrukNwRZNGugvWEVK3hR6rOvNI0um0bNJx9DQDA7QOIZYHuLjJJch8bMu
	 2ip3ZmmbiVZTilzh801PTRS9joC9HVKzxnRsOyCzsZJ6GQ1EQPo7YVkbhuW+mpFRYt
	 P+KHqo/VWLh5S4Tl6bXaHi9q81SnrN2XMyvYZDJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Lynch <nathanl@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 123/245] powerpc/pseries/lparcfg: add missing RTAS retry status handling
Date: Tue, 27 Feb 2024 14:25:11 +0100
Message-ID: <20240227131619.228040405@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Lynch <nathanl@linux.ibm.com>

[ Upstream commit 5d08633e5f6564b60f1cbe09af3af40a74d66431 ]

The ibm,get-system-parameter RTAS function may return -2 or 990x,
which indicate that the caller should try again.

lparcfg's parse_system_parameter_string() ignores this, making it
possible to intermittently report incorrect SPLPAR characteristics.

Move the RTAS call into a coventional rtas_busy_delay()-based loop.

Signed-off-by: Nathan Lynch <nathanl@linux.ibm.com>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20230125-b4-powerpc-rtas-queue-v3-4-26929c8cce78@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/lparcfg.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/lparcfg.c b/arch/powerpc/platforms/pseries/lparcfg.c
index 19503a8797823..a291b5a94d4da 100644
--- a/arch/powerpc/platforms/pseries/lparcfg.c
+++ b/arch/powerpc/platforms/pseries/lparcfg.c
@@ -322,6 +322,7 @@ static void parse_mpp_x_data(struct seq_file *m)
  */
 static void parse_system_parameter_string(struct seq_file *m)
 {
+	const s32 token = rtas_token("ibm,get-system-parameter");
 	int call_status;
 
 	unsigned char *local_buffer = kmalloc(SPLPAR_MAXLENGTH, GFP_KERNEL);
@@ -331,16 +332,15 @@ static void parse_system_parameter_string(struct seq_file *m)
 		return;
 	}
 
-	spin_lock(&rtas_data_buf_lock);
-	memset(rtas_data_buf, 0, SPLPAR_MAXLENGTH);
-	call_status = rtas_call(rtas_token("ibm,get-system-parameter"), 3, 1,
-				NULL,
-				SPLPAR_CHARACTERISTICS_TOKEN,
-				__pa(rtas_data_buf),
-				RTAS_DATA_BUF_SIZE);
-	memcpy(local_buffer, rtas_data_buf, SPLPAR_MAXLENGTH);
-	local_buffer[SPLPAR_MAXLENGTH - 1] = '\0';
-	spin_unlock(&rtas_data_buf_lock);
+	do {
+		spin_lock(&rtas_data_buf_lock);
+		memset(rtas_data_buf, 0, SPLPAR_MAXLENGTH);
+		call_status = rtas_call(token, 3, 1, NULL, SPLPAR_CHARACTERISTICS_TOKEN,
+					__pa(rtas_data_buf), RTAS_DATA_BUF_SIZE);
+		memcpy(local_buffer, rtas_data_buf, SPLPAR_MAXLENGTH);
+		local_buffer[SPLPAR_MAXLENGTH - 1] = '\0';
+		spin_unlock(&rtas_data_buf_lock);
+	} while (rtas_busy_delay(call_status));
 
 	if (call_status != 0) {
 		printk(KERN_INFO
-- 
2.43.0



