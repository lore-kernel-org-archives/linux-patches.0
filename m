Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE842ECD1D;
	Sat, 12 Sep 2026 14:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222038; cv=none; b=ihR5q28GX7/jJskHnSEGKI5N16BBUmzhCxnuk9gCLUnwkbehW6F9l3RQFQRhmaBjDLMDsSJ6f9GVoP5NYcTMLpE0vMnbqfYfmgohUVCG3ilgUpr20j7sPAVVCwkuhUHwHyd+Uj2hJC4jAC5PfGwt89qG+hz/H2Mj5ulTOA7BZqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222038; c=relaxed/simple;
	bh=OkPhWYYOKwc5cB8bQgP1M0P6niWq0WdMoisQxUI4RHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dv3FTPgolQSgRE5r265YlGZQ6zynyai/qUwClDJGTxu94uJxMiXfOXeZ+m+ZYgOXTkkI3LM49uyNe7Ic15E+avdnJOtkecf/7aceQ9cuC7rFYvn0Bb546XH5F6hRGM8JqKP3vtIajDrJveli6SpUI2cEg4A/qR/JdxIApkl6joU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QGR5aCh7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QGR5aCh7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 140F61F000FF;
	Sat, 12 Sep 2026 14:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222037;
	bh=FC6RP1EQRx0t3BVxjj6M7zTSSoUW/3oPydL6CTUwF1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QGR5aCh77V9Pfw8z23qcbc2tk1z0G3Kt4frdDaQPMRe1cuehwyipbcw6k6L6leazR
	 sJn4+zodL5f2rUdTQq2/VD32Nb3lR2nhQV6kf+cZMYt0MRz267JPGmTvBmf1T1A04Z
	 IMUVfPIjWoLnjtKiEfRMKTuWai2HWUSZbK7QMi+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.6 0488/1424] scsi: qla2xxx: Dont query firmware state while chip is down
Date: Sat, 12 Sep 2026 08:48:40 +0200
Message-ID: <20260912065618.216620376@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1669,10 +1669,8 @@ qla2x00_fw_state_show(struct device *dev
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


