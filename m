Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3009369962;
	Wed, 21 Feb 2024 14:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525455; cv=none; b=ZKkTsWedmcnJBqvJ6Mt5RZlddxWsfb5n0hZ6YRF7KFgkzkMoDX7NZAXuVzf/9eeYPqqXdXjh2JiAH9L29zHGxlYzEnLtbv0DSUeMKAQWRO2vMywIGmOQpqusDul700jvdX6n/X2mXw5JYXVtOF9mCv6ndQpR9ZZT0dFzgjOif3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525455; c=relaxed/simple;
	bh=vJIKdxYx7H5YHTxG24o8GsvY0M6Dot2VkW3P0/ETgEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dNBu1wlqNGms5lQp1xVcXYNVoSlgJmhlgUYO8YN2GaRgaujD0TJMXaxtY5QYxaA3FuEVsJcOfk5pgOt6qwn5pgKpqo8GX9jcNnePWKfk+Zh4Fk7MX2LQC8Of5aYfaKbrvuXY13DxDi1vqvJbUeEVUQ3VuJ9wivv5NLU3r5EkERg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pOR3FaU3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pOR3FaU3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46E2BC433F1;
	Wed, 21 Feb 2024 14:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525454;
	bh=vJIKdxYx7H5YHTxG24o8GsvY0M6Dot2VkW3P0/ETgEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pOR3FaU32mTTASjjnBLfTH8YIXVGIKLYqSbOm6v3yRTzjzTy/h/iwjkeF6sYt2rZd
	 XSOZZkkrHabgiLhlNWigBBg1g8SzwUoU1suzGHmYObYg2GdC8+TeWJeKaEQJhQtsHZ
	 3WBoV2ZQLS059VPY1yusnQr5rheQDaEH7l8nhytw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 159/267] scsi: isci: Fix an error code problem in isci_io_request_build()
Date: Wed, 21 Feb 2024 14:08:20 +0100
Message-ID: <20240221125945.072773742@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Su Hui <suhui@nfschina.com>

[ Upstream commit 658365c6b0857e6a306436e315a8633937e3af42 ]

Clang static complains that Value stored to 'status' is never read. Return
'status' rather than 'SCI_SUCCESS'.

Fixes: f1f52e75939b ("isci: uplevel request infrastructure")
Signed-off-by: Su Hui <suhui@nfschina.com>
Link: https://lore.kernel.org/r/20240112041926.3924315-1-suhui@nfschina.com
Reviewed-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/isci/request.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
index 343d24c7e788..591aebb40a0f 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -3398,7 +3398,7 @@ static enum sci_status isci_io_request_build(struct isci_host *ihost,
 		return SCI_FAILURE;
 	}
 
-	return SCI_SUCCESS;
+	return status;
 }
 
 static struct isci_request *isci_request_from_tag(struct isci_host *ihost, u16 tag)
-- 
2.43.0



