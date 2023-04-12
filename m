Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681BE2F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:41:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E75B7C4339C;
	Wed, 12 Apr 2023 08:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681288891;
	bh=EHvwuON3SQ9Ev6LGR681utzHUOVZM+RhR16yvNVNmKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iXCotUbd2U7/ayybOfLsGMZvVBwF85syIzLtCO0cqLjLKAp793BzctzNLeqVbB1K0
	 CVPBMmRA+rtqbGcrkStf9JCgKRhGLOF2DzIK3LSIqcrt64byxuezOxuspZnqx4gRP/
	 9lpyFxlJKifI44chppW16FMozXm+6dhYUZMVqAFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Li <ming4.li@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Lukas Wunner <lukas@wunner.de>,
	Dan Williams <dan.j.williams@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: [PATCH 6.1 057/164] cxl/pci: Handle truncated CDAT header
Date: Wed, 12 Apr 2023 10:32:59 +0200
Message-Id: <20230412082839.264901093@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lukas Wunner <lukas@wunner.de>

commit 34bafc747c54fb58c1908ec3116fa6137393e596 upstream.

cxl_cdat_get_length() only checks whether the DOE response size is
sufficient for the Table Access response header (1 dword), but not the
succeeding CDAT header (1 dword length plus other fields).

It thus returns whatever uninitialized memory happens to be on the stack
if a truncated DOE response with only 1 dword was received.  Fix it.

Fixes: c97006046c79 ("cxl/port: Read CDAT table")
Reported-by: Ming Li <ming4.li@intel.com>
Tested-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Reviewed-by: Ming Li <ming4.li@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: stable@vger.kernel.org # v6.0+
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Link: https://lore.kernel.org/r/000e69cd163461c8b1bc2cf4155b6e25402c29c7.1678543498.git.lukas@wunner.de
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cxl/core/pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/cxl/core/pci.c
+++ b/drivers/cxl/core/pci.c
@@ -531,7 +531,7 @@ static int cxl_cdat_get_length(struct de
 		return rc;
 	}
 	wait_for_completion(&t.c);
-	if (t.task.rv < sizeof(__le32))
+	if (t.task.rv < 2 * sizeof(__le32))
 		return -EIO;
 
 	*length = le32_to_cpu(t.response_pl[1]);


