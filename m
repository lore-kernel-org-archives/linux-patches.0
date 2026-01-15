Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9405E3C199E;
	Thu, 15 Jan 2026 17:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499562; cv=none; b=sNV8SjE1DTg84WHlMcmGSSimRx7EsGym7oNhP4f4Xt4l0iBquwDuB84eR7T4GJlFX6GaaJsZYggULQDLGmMX4onCNm7SjcZeRmjYjRmwmgtncYg4iwRtHoaz16VrdWhFkr3Co39EOt4W73BcjbngIY8U3qGZnDx7ZnFS+8zC5vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499562; c=relaxed/simple;
	bh=N4x2L/aZ/yqfUVZzcu1Lca0vKA+wtyoOfhOCidXtlZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cFaqJ3jXQLh3mktTrU2QsbTkXG90y8dc6OMhGjMoC5TcZb3/KMplh/wKOiRpSTwLPsdsTHOB4IMqr3UgbvM6ObpjFJLxmL8rOUholu7ugnV16Dwv3V7LL5td68ZgDZMueIVJX534XhTy7c9XcaCO+lPRN4nHC77NkD+L9H32Has=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Glo5jcr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Glo5jcr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 216DAC116D0;
	Thu, 15 Jan 2026 17:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499562;
	bh=N4x2L/aZ/yqfUVZzcu1Lca0vKA+wtyoOfhOCidXtlZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Glo5jcrl6nCgLguMLsE26YtxVvNU1xSJijlMzuIsVfxuuPDPuCad+5HzlexZb3ps
	 uorzLCvHnl0np74ch+1nCdLDwmjlyc72qCObeTceyrsnQTp1O+In7Rn4MAGi4XD4xN
	 UnXlyI7VeViIHIjtbZY37aX8oWImZi6FHuU7NWLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianchu Chen <flynnnchen@tencent.com>,
	Arnd Bergmann <arnd@arndb.de>,
	stable <stable@kernel.org>
Subject: [PATCH 5.10 237/451] char: applicom: fix NULL pointer dereference in ac_ioctl
Date: Thu, 15 Jan 2026 17:47:18 +0100
Message-ID: <20260115164239.467084956@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

From: Tianchu Chen <flynnnchen@tencent.com>

commit 82d12088c297fa1cef670e1718b3d24f414c23f7 upstream.

Discovered by Atuin - Automated Vulnerability Discovery Engine.

In ac_ioctl, the validation of IndexCard and the check for a valid
RamIO pointer are skipped when cmd is 6. However, the function
unconditionally executes readb(apbs[IndexCard].RamIO + VERS) at the
end.

If cmd is 6, IndexCard may reference a board that does not exist
(where RamIO is NULL), leading to a NULL pointer dereference.

Fix this by skipping the readb access when cmd is 6, as this
command is a global information query and does not target a specific
board context.

Signed-off-by: Tianchu Chen <flynnnchen@tencent.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: stable <stable@kernel.org>
Link: https://patch.msgid.link/20251128155323.a786fde92ebb926cbe96fcb1@linux.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/applicom.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/char/applicom.c
+++ b/drivers/char/applicom.c
@@ -836,7 +836,10 @@ static long ac_ioctl(struct file *file,
 		ret = -ENOTTY;
 		break;
 	}
-	Dummy = readb(apbs[IndexCard].RamIO + VERS);
+
+	if (cmd != 6)
+		Dummy = readb(apbs[IndexCard].RamIO + VERS);
+
 	kfree(adgl);
 	mutex_unlock(&ac_mutex);
 	return 0;


