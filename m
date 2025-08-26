Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF75284B5B;
	Tue, 26 Aug 2025 11:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207768; cv=none; b=QhPjvmi0nmHzZvD4NTP7uZZ6Wkj0xcq7ncqfov2rf25e3aZWPiT+C1zCpJtg+2GJoPs2TU+cm4pnl3NZbrIbbObEnCMJkV60PP0Nmx3dY/06+UIlltMmoUGR0aUm7WFfpKEIPs2j6sJyMnt4uKqWvNX5lZyc9RNwRBgOSW34RSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207768; c=relaxed/simple;
	bh=LPDv9LfLoSwIFi43w66/QJS4jCTYonbZWAi0uDztqlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kLZvUGUnyIndGLAWPRYyUeTSOwA3VR02GYru722C1/L910Oxp2+DO00gyazQKIhkTJq3sHujNm+XWBUqN3MukUu5rRpIT41zJFtdsXLm4eXZhO/fSAKaV2sSiUp+jT0TFV0G5Brv8tOnSMY5Sd69aBBnG6QzXLuEbV7ryq/Yyhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=03kZwv3V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="03kZwv3V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 463ADC4CEF1;
	Tue, 26 Aug 2025 11:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207767;
	bh=LPDv9LfLoSwIFi43w66/QJS4jCTYonbZWAi0uDztqlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=03kZwv3V9bExnBlL5x1QRbIUwuWCXKc4qMr18ZNsZ3XexV8fB/S4zMQXEYGmb/UBg
	 zVtYBS7V9NzOltR4y1DVYLV8OjpE4mJtS4GaXTb06PZWVTUpRdxGaWz7AAT2KvwfE3
	 bPYuDh8XyWULyiD3QVG7LY6ZwEK5gQLfZGxhtJYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Thorsten Blum <thorsten.blum@linux.dev>
Subject: [PATCH 6.16 309/457] cdx: Fix off-by-one error in cdx_rpmsg_probe()
Date: Tue, 26 Aug 2025 13:09:53 +0200
Message-ID: <20250826110945.000750462@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

commit 300a0cfe9f375b2843bcb331bcfa7503475ef5dd upstream.

In cdx_rpmsg_probe(), strscpy() is incorrectly called with the length of
the source string (excluding the NUL terminator) rather than the size of
the destination buffer. This results in one character less being copied
from 'cdx_rpmsg_id_table[0].name' to 'chinfo.name'.

Use the destination buffer size instead to ensure the name is copied
correctly.

Cc: stable <stable@kernel.org>
Fixes: 2a226927d9b8 ("cdx: add rpmsg communication channel for CDX")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Link: https://lore.kernel.org/r/20250806090512.121260-2-thorsten.blum@linux.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cdx/controller/cdx_rpmsg.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/cdx/controller/cdx_rpmsg.c
+++ b/drivers/cdx/controller/cdx_rpmsg.c
@@ -129,8 +129,7 @@ static int cdx_rpmsg_probe(struct rpmsg_
 
 	chinfo.src = RPMSG_ADDR_ANY;
 	chinfo.dst = rpdev->dst;
-	strscpy(chinfo.name, cdx_rpmsg_id_table[0].name,
-		strlen(cdx_rpmsg_id_table[0].name));
+	strscpy(chinfo.name, cdx_rpmsg_id_table[0].name, sizeof(chinfo.name));
 
 	cdx_mcdi->ept = rpmsg_create_ept(rpdev, cdx_rpmsg_cb, NULL, chinfo);
 	if (!cdx_mcdi->ept) {


