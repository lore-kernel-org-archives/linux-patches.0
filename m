Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B5FC21B185;
	Tue,  8 Apr 2025 12:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113740; cv=none; b=cvRJlkdbuY7vCm4/TLdQMJaq0F6y3Su7gTPeyloaTkD9DJBfl2Ac6XSbPZL31IYs+7rrUgBIlCmunMZmEyb5vURH8QusaXbiUTPEfEK0DZMcjN9IF6yHjoi4ZPE7V/FeKdfrrzS45Qj+8A/uo/kDT93etVukKWdQbMGTf7pHoSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113740; c=relaxed/simple;
	bh=TlgupLfNoTgPX3V1750VtMiwfGHptmUwxwoAlNWPKSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oxtrRKhtfF24gNtXUlwKCNwPndF0ErC+rv/6NHJXVd6wnVRvmGwnrDJuRavPdLaWTk5b5qA3ZqSyaK7u+4HCVawE1G+gbF7aN/Sbw8eQhE02LyJmfI4FauSx9gIhGArKuLUDdIBRp8yV2ehXr8VaBWJ5HBR8n2Ghlje4szTWRxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uoa78UJR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uoa78UJR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 736FFC4CEE5;
	Tue,  8 Apr 2025 12:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113739;
	bh=TlgupLfNoTgPX3V1750VtMiwfGHptmUwxwoAlNWPKSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uoa78UJRYyKToPvx8P8M2KAMsbeZIeJ95/o+0wwwKGpj82TODp0JzHP2uMfyQW543
	 E/G66FVxvzKyX9xUdEqhyCTerlpiqvZO12kWP1aw6Wdo0b2xpzp5EObuVmOIQBhRsl
	 sV3QvgctFCDJ5uekw+kj3i2xuND0U8L4LYc0BiI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Elfring <elfring@users.sourceforge.net>,
	Jon Mason <jdmason@kudzu.us>
Subject: [PATCH 6.6 239/268] ntb_perf: Delete duplicate dmaengine_unmap_put() call in perf_copy_chunk()
Date: Tue,  8 Apr 2025 12:50:50 +0200
Message-ID: <20250408104835.031986189@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Elfring <elfring@users.sourceforge.net>

commit 4279e72cab31dd3eb8c89591eb9d2affa90ab6aa upstream.

The function call “dmaengine_unmap_put(unmap)” was used in an if branch.
The same call was immediately triggered by a subsequent goto statement.
Thus avoid such a call repetition.

This issue was detected by using the Coccinelle software.

Fixes: 5648e56d03fa ("NTB: ntb_perf: Add full multi-port NTB API support")
Cc: stable@vger.kernel.org
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ntb/test/ntb_perf.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/ntb/test/ntb_perf.c
+++ b/drivers/ntb/test/ntb_perf.c
@@ -839,10 +839,8 @@ static int perf_copy_chunk(struct perf_t
 	dma_set_unmap(tx, unmap);
 
 	ret = dma_submit_error(dmaengine_submit(tx));
-	if (ret) {
-		dmaengine_unmap_put(unmap);
+	if (ret)
 		goto err_free_resource;
-	}
 
 	dmaengine_unmap_put(unmap);
 


