Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5512A1D7;
	Wed, 21 Feb 2024 13:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522946; cv=none; b=aMZgIgboLEiG5O6/ezXOjt8UoLDahVPKLqvbOXTSexXHp9UxKJYr33ZdoRlyByo/d7eEFKlyKHg/b3CJwarjxRxBTi5QIuEfSjjGD9NYqJQ/Ffnk0izX+ucd7pA9qsiIEPebMYnmva72D1+Rdiug56DQ9b/qARD0WksBNx/G8b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522946; c=relaxed/simple;
	bh=rM2F9xu9V+Ai9Rtm8E+6rgmgFDxav7RZ/ig3ggeMPrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cOISNHdxgGxcaBO0VuIXq3rfj6oZBJJ2wFKo0fQxRy2mw0EDzy+DRV1vByqKBVRGlRNrTdW6qf3kLOEpQXWDyjGx3VxvYodpSxtWD0rlHaSZxLwmkXXGfzW4Dedu+mksoW8kwdTgaap7OqCVnkuaeUJXIs26LdJno6E/b4HQ5jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BTsSvJa3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BTsSvJa3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A99C433F1;
	Wed, 21 Feb 2024 13:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522945;
	bh=rM2F9xu9V+Ai9Rtm8E+6rgmgFDxav7RZ/ig3ggeMPrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BTsSvJa3hwQYw7+33YlFionMcWYtIEqJCjaf3XKB+CfZdqEwpTbzqreJvs4gL2WiB
	 9FL1ivBljxzJXFcLuWI2ue7+fRhgfkGB/7XYfBWOGY6g4oI4xgFYCWAPMYdpNhob86
	 1/4iKuCrNHBgdzIoEzbZoeyqqGYiNbMEzuTKFERM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 270/476] scsi: isci: Fix an error code problem in isci_io_request_build()
Date: Wed, 21 Feb 2024 14:05:21 +0100
Message-ID: <20240221130017.840018733@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index fcaa84a3c210..6ef40993906a 100644
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



