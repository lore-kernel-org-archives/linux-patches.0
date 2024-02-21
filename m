Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22FFE77638;
	Wed, 21 Feb 2024 13:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521504; cv=none; b=YeE7NuC7vmYkY6RRALd7ls2NVJKoWysSBoxa0v0EpXiYMQ13Te+i2ISBy/o2IZFK6+6bjt4NH2a+s+JimLCYf93gOlZgDrbSrZolrUo4IcUKqrl50tER6MtVdbGxpNEbdEsblQPzyleYQgr6ZLpAaeFxH3Pi45Y+t/+cGeEUK1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521504; c=relaxed/simple;
	bh=i7ATDTVQq2Hq+xiSL5lAif+ni97HAW5RfAWyr9115ZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VJHvv+NuHn4rYNWw9Xk/0vK5JeWItGwceRvjbuxZGMw6Ui8As0y9yKbvC2IzC2yXqV4YYABFvL3cebfBAAJwaw7f358C9DU6IB6SZ57M/sXc2xczJXhPmk4u1dxOkXm2eLRNsU0rveXaQgb4uxVu3gDemwCdUTyHe1QXNI8DptI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ylNmbpkb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ylNmbpkb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9164CC433F1;
	Wed, 21 Feb 2024 13:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521504;
	bh=i7ATDTVQq2Hq+xiSL5lAif+ni97HAW5RfAWyr9115ZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ylNmbpkboCK/XsAyKvHa4RtjAZaVH0+QL4iUKkQJuHRP8oPaT/boGhlO64Lt2D6qP
	 KvHQ3WSyLDFZWKWnLDxUxXYpqZtoRKQRcOBI3yWOI1Iy8yLyl+/rrqb0deI1cb5F1L
	 3YXZ1IrI0Gqgp3+AGekLFdqfDqngV65HFxpvfy24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 130/202] scsi: isci: Fix an error code problem in isci_io_request_build()
Date: Wed, 21 Feb 2024 14:07:11 +0100
Message-ID: <20240221125935.910837123@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 2f151708b59a..13ecf554762e 100644
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



