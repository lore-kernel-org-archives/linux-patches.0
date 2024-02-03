Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124B3171D4;
	Sat,  3 Feb 2024 04:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933933; cv=none; b=uG1gv20drZ14KKCrdqw4wpWdadn1sU1qrnxVefNB3YaPOHIsSSz7Lg4ZZ798jbxuCnHoMwWIao0k+FWpdyVFdAEFm1QfL3wyOBehWHV31lfVJ5A52LnkKZS2cA9Ws9af/6ak9wM5ydkM1/0XwfVp1K/18E+2Yrlr8F4UOd2vHZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933933; c=relaxed/simple;
	bh=Gm+HO3fzjdABOW+rYozkIX3TOFQ1AhP5j2+59ER7otg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UIrAHPVR2AbWSPq6FypLjU2R5JJQGjrdc7LmN+wv/JiULSt/VGiwUcVuby6Tq5NHnPQ/vutWHxyQqtGYcZKQhulC3G/PvnUTa3zVZ6vXmr10ZsH6c5luUhBATJ/Oy+lzLfAlfK1FN0d18tZXlS/ep9qR5GMt8T6fK26b20QhhNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gdvw25Ui; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gdvw25Ui"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD2B2C433C7;
	Sat,  3 Feb 2024 04:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933932;
	bh=Gm+HO3fzjdABOW+rYozkIX3TOFQ1AhP5j2+59ER7otg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gdvw25UibNSA/vMyMFZ/gav8DFXwR/w/EZu1tONBoCkvGnOiXGaLUHNhWJYskWZ5I
	 zLrRNN85P2ZnS3Qik7Y6THtoItfDbjt5Lt0JRbJM/i2UmWcN5wBzcz8QGuvKn7Ddjn
	 CogoQakWYXkVvJkCnO2D8BXY0gGfd1q5neOz3iJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 293/353] scsi: isci: Fix an error code problem in isci_io_request_build()
Date: Fri,  2 Feb 2024 20:06:51 -0800
Message-ID: <20240203035413.073833018@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index a7b3243b471d..7162a5029b37 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -3390,7 +3390,7 @@ static enum sci_status isci_io_request_build(struct isci_host *ihost,
 		return SCI_FAILURE;
 	}
 
-	return SCI_SUCCESS;
+	return status;
 }
 
 static struct isci_request *isci_request_from_tag(struct isci_host *ihost, u16 tag)
-- 
2.43.0



