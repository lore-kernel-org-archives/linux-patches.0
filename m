Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66B0253B5FD;
	Wed,  9 Sep 2026 14:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962915; cv=none; b=X3dqMGh4FPcKTxeE5ITDA/MP/M/RqZlz3CGf7sRgVTOx5RcqoVTBgiuDp6Qjn9thHGDJcz1sASQIR5OlxJfffgMMa9VX1tE9Gj7MDwZ5+acFRRY6iugxE2XAHgPybY3ISV3KgsLEiKFY+ddRlnUE29z88RlCIJXSkGZ+DlhpjFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962915; c=relaxed/simple;
	bh=DpAOPM4v6aftIiQbdqbGXKorTvctJXhJ36H/244gDDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QKTxys00KcJV7xyDtJPt+bbEZ0lB6GUuwVMV8kpoLLktvinI1uYFJACRfogHe2DHMAFAHPhyRgn7RSgx2Sh6/w+VQSj/+FOrcTMuliG2sJ9uM74bkaH1HaDDsojD5xNG2ZKaeyky2pOFb+Y99eXfe4WMMYkQAItWg8vcOdACA+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i6aOFS39; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i6aOFS39"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDB0A1F00A3A;
	Wed,  9 Sep 2026 14:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962914;
	bh=rK0VFt/87yYqCWPfsYlmGl9QVlGQ0HwoeViYrPpq0bU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i6aOFS39IbIDINNxHJQlHfPuEXx+rO6bpRcRszSA+BzgqEHOGbXYvz6syKKTyThGD
	 IVhiy8eHA9dKZXvgk3TV7dtznPw+J+F2Y8GKcu8YQ9B0FOfG+V2r6NX+IzPcEYHFAP
	 36B0yWgMy7s2wM7B1cxDF4HrS+WbD4SaFATYaj3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 7.2 433/556] scsi: qla2xxx: Dont query firmware state while chip is down
Date: Wed,  9 Sep 2026 15:41:53 +0200
Message-ID: <20260909134245.835040739@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1662,10 +1662,8 @@ qla2x00_fw_state_show(struct device *dev
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


