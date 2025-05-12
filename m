Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FD8B2505C5;
	Mon, 12 May 2025 17:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072783; cv=none; b=XhAgOlX99WHuekngNS811qweye14yOLSXqCvDtH26sRpnSfmfpbLanmkuoMtzn1cW7KVcuGPvSw1o52SL1sq4319esC8RvH3/KO3ZWLcJSSUPluE33iCC0PgCNhYzg8cQuXNhfmBoXpWETyWKcHcvEBXtRGjK9vfJja7SDaE1iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072783; c=relaxed/simple;
	bh=LMzi4THUSNGe7MkxzxXVvufxhw5O/XNRngyaEIsM5mM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dE2PTgX2whuDqBIrlHZ7biAsv8poIq8uFqXk07u0vOczfAbjnlGv+kuoq2x4OwNQpxwSNWq0cXt0wMa9xgOL1+9YGfPSUMuA2xqUtifdhIUvmBxVY4tjWuVmRym3UmaLBeesh1JUeyot1RfHMs0JN34VCpSqlKvS3ZISLsjlbhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sG+LABlB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sG+LABlB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E1FC4CEE7;
	Mon, 12 May 2025 17:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072783;
	bh=LMzi4THUSNGe7MkxzxXVvufxhw5O/XNRngyaEIsM5mM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sG+LABlBjiIeA9hP7G/Tsj91BGg/bOQQepgGnDr1Wddd4G63g/l2QAXjbT6iQd2NY
	 TlVTAbT6rITyU+AEjfhOMtwF3cK/ouVItvgUClpt0hwmqYfiSGnZ70pCXw/Fl+GrYJ
	 z8k+pP5jsM+l50jxTzC4MwABzfJwZVfgrgQ1o0Rk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikael Gonella-Bolduc <mgonellabolduc@dimonoff.com>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Alistair Francis <alistair@alistair23.me>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 055/184] Input: cyttsp5 - fix power control issue on wakeup
Date: Mon, 12 May 2025 19:44:16 +0200
Message-ID: <20250512172043.977992150@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikael Gonella-Bolduc <mgonellabolduc@dimonoff.com>

commit 7675b5efd81fe6d524e29d5a541f43201e98afa8 upstream.

The power control function ignores the "on" argument when setting the
report ID, and thus is always sending HID_POWER_SLEEP. This causes a
problem when trying to wakeup.

Fix by sending the state variable, which contains the proper HID_POWER_ON or
HID_POWER_SLEEP based on the "on" argument.

Fixes: 3c98b8dbdced ("Input: cyttsp5 - implement proper sleep and wakeup procedures")
Cc: stable@vger.kernel.org
Signed-off-by: Mikael Gonella-Bolduc <mgonellabolduc@dimonoff.com>
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Reviewed-by: Alistair Francis <alistair@alistair23.me>
Link: https://lore.kernel.org/r/20250423135243.1261460-1-hugo@hugovil.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/cyttsp5.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/touchscreen/cyttsp5.c
+++ b/drivers/input/touchscreen/cyttsp5.c
@@ -580,7 +580,7 @@ static int cyttsp5_power_control(struct
 	int rc;
 
 	SET_CMD_REPORT_TYPE(cmd[0], 0);
-	SET_CMD_REPORT_ID(cmd[0], HID_POWER_SLEEP);
+	SET_CMD_REPORT_ID(cmd[0], state);
 	SET_CMD_OPCODE(cmd[1], HID_CMD_SET_POWER);
 
 	rc = cyttsp5_write(ts, HID_COMMAND_REG, cmd, sizeof(cmd));


