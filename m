Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8570377ABA;
	Sat, 12 Sep 2026 19:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242148; cv=none; b=LpJKq3Uvj/60XBuMOrlGrMw0/F0joJ9WL7bppnWYXl+wTBQ8LLN5jAE3fn1CJi6NgJW901zSpgBZ7PiRt6EkpAiisAoa4IX3vVrfg+qt6Jhj2yPIXJhxCiqSyb1RQLseOh+F52epGj2gkAjtcbZlgEfK7po7/fZgZP/iDNbd5so=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242148; c=relaxed/simple;
	bh=yrG3o8Gv8rn805iHw0KsZDSoW4b6Y7hV5UKodg8fj4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aqoKjQYHuQfaUzBo4qDcpA0AxU6qoun6o8Vay0mu7+bb46XE3G3FpjwyEtLbV+QYRiP4yDpIi+mlPmDFeTGCDIknlXpWZcnsYtYps98gDyCg3HewgcF1lVhQ4voSB7DcHQD6GiiQvkBtgpPqbOj3NQFgiH1C/bgGc4S/qTG4++Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yXxpU1L7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yXxpU1L7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50BF91F000FF;
	Sat, 12 Sep 2026 19:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242146;
	bh=EvQ0dxMAtB8ZQ0mBD6s2NtBeprA2FcX7ZYAgCXwqEZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yXxpU1L7eWPYpa7pLSwaELK/INmHtkoi2/dJABHGis+RD9kGodWH69teHcq/2yDj2
	 IyK7TjI30tdsuTG3VLghjfry6JL3on/xvASqoPDPQjtR/D8iJa1c+5e4zV1I+IzfEO
	 7GLi+bW3nvSgJxIYnnYM1i4t94FbTx+w6rlUab/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 5.10 303/798] scsi: qla2xxx: Dont query firmware state while chip is down
Date: Sat, 12 Sep 2026 08:58:51 +0200
Message-ID: <20260912065524.106501189@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nilesh Javali <njavali@marvell.com>

commit e0cebe20dcffbed9c078fe30e2d18cd5046d9eff upstream.

qla2x00_fw_state_show() initializes rval to QLA_FUNCTION_FAILED and jumps
to the out: label when the chip is down or EEH is busy. The out: block
then re-issued qla2x00_get_firmware_state() because rval != QLA_SUCCESS,
defeating the chip-down/EEH-busy guards and issuing a mailbox command
(outside optrom_mutex) during ISP reset or PCI error recovery, which can
hang the adapter. It also turned a normal in-lock mailbox failure into a
second unsynchronized mailbox attempt.

Make the out: fallback only mark the firmware state as unknown. The
mailbox is now issued at most once, inside optrom_mutex, and only when
the chip is up and not EEH-busy.

Fixes: b6faaaf796d7 ("scsi: qla2xxx: Serialize mailbox request")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://patch.msgid.link/20260730155838.2119230-8-njavali@marvell.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_attr.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1663,10 +1663,8 @@ qla2x00_fw_state_show(struct device *dev
 	rval = qla2x00_get_firmware_state(vha, state);
 	mutex_unlock(&vha->hw->optrom_mutex);
 out:
-	if (rval != QLA_SUCCESS) {
+	if (rval != QLA_SUCCESS)
 		memset(state, -1, sizeof(state));
-		rval = qla2x00_get_firmware_state(vha, state);
-	}
 
 	return scnprintf(buf, PAGE_SIZE, "0x%x 0x%x 0x%x 0x%x 0x%x 0x%x\n",
 	    state[0], state[1], state[2], state[3], state[4], state[5]);


