Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49E03F482E;
	Thu, 16 Jul 2026 13:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210104; cv=none; b=QFmLv7uCIqJ+EmU+9pHHijQgE9v/SAc4bjXrtnGvCxqCV1kE5SdZ+WdAiyfeWM5npsJI7NBEFN0WDlZBKEwnqQ87NVJusAUxvkGezE8evmHUprS/uNdmSiI1LHOW/UjlPPnvd0ASe5Z1NDAS9wGDNK9jtymMIGF2hbCmE3v4gyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210104; c=relaxed/simple;
	bh=+JnPoPUA7V7Yz3p3vXLQAtBSjJcV0NQWA/8/v6JqZg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=grtgq38IPUaz+cQbbXxxoKY/6+J3+9CiO1637Ru0YN1OnJqpQYkdTKQ5dcYmlViKJkZI5pATsC7WCXkkQpDniXqVAYB0ttlc5zsDE/BTJXs+hYMW4bt33X155BDxZmKCEOO5TGjCYKXn+pxdkqsAjnB0zsz/bzTTxR41AXlGonE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d27dBKOB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d27dBKOB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 214CD1F000E9;
	Thu, 16 Jul 2026 13:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210103;
	bh=O2TCrL48GBK+OKfjDqYMnC0nu7iMXXGPpaltX5G2QJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d27dBKOBWAaf0R29nUawEJ53iYD88SWoUI4btbeXmBKKogxOiYcZgSJzxZwXkjt6h
	 rIYhazT62wqEFTv5clS1WeF+TqaZNjO/PzO4E2cvcDFpds/A95Z+f16+TZAZ57y5Ww
	 pyADFNTyjmz5Pj5Kh4B6jEUrnORltgMafsu5BY3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pranjal Shrivastava <praan@google.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 7.1 437/518] iommufd: Rewind header length in done if iommufd_veventq_fops_read() fails
Date: Thu, 16 Jul 2026 15:31:45 +0200
Message-ID: <20260716133057.405148745@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolin Chen <nicolinc@nvidia.com>

commit 01e41ad76c12ae5c49ab4ef4fc7dd54e9b8784d6 upstream.

When the first event copy fails, rc = -EFAULT will not be reported as done
is set to the length of the copied header.

Rewind it to report rc correctly.

Fixes: e36ba5ab808e ("iommufd: Add IOMMUFD_OBJ_VEVENTQ and IOMMUFD_CMD_VEVENTQ_ALLOC")
Link: https://patch.msgid.link/r/78f8caeb6a5d667a26b870e3068cec47dd4b5be1.1780343944.git.nicolinc@nvidia.com
Cc: stable@vger.kernel.org
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/eventq.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iommu/iommufd/eventq.c
+++ b/drivers/iommu/iommufd/eventq.c
@@ -336,6 +336,7 @@ static ssize_t iommufd_veventq_fops_read
 		if (cur->data_len &&
 		    copy_to_user(buf + done, cur->event_data, cur->data_len)) {
 			iommufd_veventq_deliver_restore(veventq, cur);
+			done -= sizeof(*hdr);
 			rc = -EFAULT;
 			break;
 		}


