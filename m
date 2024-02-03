Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A1010A1C;
	Sat,  3 Feb 2024 04:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933450; cv=none; b=fM+PM6YGCCQcXC+li/WGXvQ1X3jVF0C4veyuvImKcChdpoD4RQ0IUACwM77sG4U8uWg5Bu0XyKlHxzSHhMMhKpwYuSE4/CxGZi+X0gT5QAKDtdl5QLWlvI/Yq7VjR4pNKMtMu8g90ygC5LQqsOUxxooSjAkOSBfP+15riQUgeOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933450; c=relaxed/simple;
	bh=8647j7HzTzLaykn1bwORS55uVaNODau5MRXWsUWMuaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t/cyeYxkbKdmu1IUbw+dJRfftk3/QMfFdXmu7Pa7W2C2gfFl8JVlJNRRpRGq+00Eze+tidmPEl2u/y4tvPkJLsQLqmswH9awx7s3CTT6YVG2riv0UzEzIByWGMLFuUfh59mHWQbVHLLl/fRZ/YQMBCaaTWOFlLr2H2cLIbV2W68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nnjn6kmC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nnjn6kmC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 514F5C433C7;
	Sat,  3 Feb 2024 04:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933450;
	bh=8647j7HzTzLaykn1bwORS55uVaNODau5MRXWsUWMuaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nnjn6kmCcgjN24SCgW47k4gtYu/Q2ZOGbp636a2rSYeCmY4aNa1BbfI0xXlqjivpt
	 sDaTwRJ3uG28HOGUX2TyfRVOoLVaqwsvYGYD2Mjh3skA+ieEiJSvinEkcYtarJW6tN
	 Gpa8t1z30DlcX0JQ9UQSDwuO4R34B6JsZL5nEE1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 185/219] scsi: isci: Fix an error code problem in isci_io_request_build()
Date: Fri,  2 Feb 2024 20:05:58 -0800
Message-ID: <20240203035342.642693345@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6370cdbfba08..0f0732d56800 100644
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



