Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A57872F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:41:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C4FEC433EF;
	Wed, 12 Apr 2023 08:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681288896;
	bh=h9nPUCF1LhaT8A96J090/iUdOuSvI3+AqO1M64Kfrok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WITehfBnLJR/OL+Q6Zhqe0m7z+BSSIYn+WUCKuQOMWmO3cmiD0bcsMJfj6ZlpAoG3
	 5cW9di/g3rj2rme9Q1PnOPhr7+ptySHEX1bhdEN+r44zQ8XYDVZMyGyghWDZaiO8G8
	 Tgjx8tQqglF/H1egG1ZpGmel/Zvg2OWp4MT6Y690=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ira Weiny <ira.weiny@intel.com>,
	Lukas Wunner <lukas@wunner.de>,
	Dan Williams <dan.j.williams@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 059/164] cxl/pci: Handle excessive CDAT length
Date: Wed, 12 Apr 2023 10:33:01 +0200
Message-Id: <20230412082839.331340803@linuxfoundation.org>
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

commit 4fe2c13d59d849be3b45371e3913ec5dc77fc0fb upstream.

If the length in the CDAT header is larger than the concatenation of the
header and all table entries, then the CDAT exposed to user space
contains trailing null bytes.

Not every consumer may be able to handle that.  Per Postel's robustness
principle, "be liberal in what you accept" and silently reduce the
cached length to avoid exposing those null bytes.

Fixes: c97006046c79 ("cxl/port: Read CDAT table")
Tested-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: stable@vger.kernel.org # v6.0+
Link: https://lore.kernel.org/r/6d98b3c7da5343172bd3ccabfabbc1f31c079d74.1678543498.git.lukas@wunner.de
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cxl/core/pci.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/cxl/core/pci.c
+++ b/drivers/cxl/core/pci.c
@@ -585,6 +585,9 @@ static int cxl_cdat_read_table(struct de
 		}
 	} while (entry_handle != CXL_DOE_TABLE_ACCESS_LAST_ENTRY);
 
+	/* Length in CDAT header may exceed concatenation of CDAT entries */
+	cdat->length -= length;
+
 	return 0;
 }
 


