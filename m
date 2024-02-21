Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 674F94C62;
	Wed, 21 Feb 2024 14:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524462; cv=none; b=N75sEyC1kwEA6WxhKVzW/uvPQ4JFOsZVs7IMdM+x0Kriw7j4e1wJU2FiU1NwjXM/QNl2RUfqfz6fReVSUh/SM79qHKmL/6mwbNPFXYpY4P/RftEhstKZaD+NUHjVQaRw8QFx5KXNi11JfQTY6UKemgkW4bA6gxSRGFEQkGphGF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524462; c=relaxed/simple;
	bh=j/8FlocKoQiVjsaFXrlN5kg0nlNdiZvLVEOP+YuYLXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gMByWIfpW0xkX0Z/hqSjfExs3+PsvBf4ah5uoDujPkEXn1FDpzV+YZh3PQPdK4Tis72g6ocpVr+LQLIQkkAex18K+oraY0wu3NmAJqwiXMlekpZ3/yonIFiQ9R+jvPEM4Z6eQo74KI4SqnQP7k4/QztUJEjQkrrvdg3rSzR7MCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ktxoQXhS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ktxoQXhS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A05C43394;
	Wed, 21 Feb 2024 14:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524462;
	bh=j/8FlocKoQiVjsaFXrlN5kg0nlNdiZvLVEOP+YuYLXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ktxoQXhSr9hDcy2k/8M64Jbd1ch09ypEmEbV9RAqy9kIbW/c9nULdtmkF5XCVHnWI
	 +RV13scqtjgV69SrOq43vSdMXL3MAI1n0tCrV3I8c0GG93hvByJZRMA22ZVsqY5ht/
	 lijAURHM++5QXI3r7H0qQ1jPZ3tzxSx0qDoQFmbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 223/379] scsi: isci: Fix an error code problem in isci_io_request_build()
Date: Wed, 21 Feb 2024 14:06:42 +0100
Message-ID: <20240221130001.496718024@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b6d68d871b6c..a4129e456efa 100644
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



