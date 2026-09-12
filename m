Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E571A6815;
	Sat, 12 Sep 2026 15:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228523; cv=none; b=XsKmzWoU5iBOxezHCdIq2UuCYiyNFBel6+DFyGiYw43eYapJwulq4DUlAy5WbxWWrkRjC2VxyAnFf8nK4oolV9ZrdYE7xuuvZVT6nixvW9RBdvgGxztYGm5KGuelnyFM6EdsjA26p/gwlUOfuQ1aNhzhwkhte9/EwNnLfrcV4Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228523; c=relaxed/simple;
	bh=fDG/j52+d0kjXCfcd8bUf526Dpac6Z76ZYL2wSzJxR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uJQ+tsNLsXtZBf2AUgk8nFD7zERz0KIzQBsJtxUGTmxgRyZOdNsmCQHs4KKKHoi7O6rWv9XQtm9IK/mjAENFja/j9xrUbWAAdUiAF780JU6kmvIh+0NPMVJgDQg44/6Rj6El0s7//YOYzjIZGutKCizRiuODEpP1G7mlWN2sgys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NyvZ3khA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NyvZ3khA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3C2E1F000FF;
	Sat, 12 Sep 2026 15:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228522;
	bh=64T045rBHOPd7qK2jji497Qe/+TilmqPiMTj9dM28Eg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NyvZ3khA1WZ4ewQAuZ/iX271LNrgwpmu2KwBJ9VqoyXsGFSjjHAYQVwizS2Tqy7v+
	 hxnmboEU6NR/UBiunC8mNCGt+j8tON1kTjw8Z/rgI5tW9JL7uj2MhmnT+/ziHy983y
	 b7fe7amAGBKGhDAmdlbJlD2WtgOYOEOIlwuiKK8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.1 0401/1191] scsi: qla2xxx: Dont query firmware state while chip is down
Date: Sat, 12 Sep 2026 08:52:09 +0200
Message-ID: <20260912065557.245893297@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


