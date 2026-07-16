Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F13427F97;
	Thu, 16 Jul 2026 14:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211407; cv=none; b=JW9o9imhTiVF2wLLQhkrQaygrHxELG/ZGTool57r3AJfsV/XpkN5ehIlXiwAwAS8HpMh+z47rBlCd0AZHfOtFETr32lk7L2w2lKEm/0NFplFaUn7cDMsmMnLabJgRN/ZBo6BHoWA82+9wBWGYgHTvPzvvO5uKF0JKHDeh/KD0SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211407; c=relaxed/simple;
	bh=R7VbqjDlh/auHTrk88PJZdtPkL6/iuBC9BOpRrIHzzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Im1YVeGNpcSFNF64hPbsb2Wz+Tv9BTTYVQhg7siomiSL6+uBzdV0su/OxxjQL3zhh6dIV4hBsUqnN1n3r3Nad3Dwc01xTJbUGYNFT7JjueyVULMpnB7mJxUyDPshUWmfLdwYf2yYAqBFlEo45bz0xTVTT6jFa2SbIbDQCP9vL4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ImX7fI7r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ImX7fI7r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1465E1F000E9;
	Thu, 16 Jul 2026 14:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211406;
	bh=T+eaL1NBS+wyqtQzmzWkXSqO3aUDoh2N4GqDRiJadTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ImX7fI7rDcJGTwtVa/jB26X5rWbsUDV0lkoA0Ram1daJdwXrhNgEuKDH5sf8ZCFxS
	 otcGYlPwcVvMcb4viUNdLm0o6Nl6SdqAi5WzHPrSdA82tMrl+2nnu0qcJstynN+jMi
	 t6til3SktWzpYj96qEHIJSrp6/HNim8UONhKl1zs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pranjal Shrivastava <praan@google.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.18 414/480] iommufd: Break the loop on failure in iommufd_fault_fops_read()
Date: Thu, 16 Jul 2026 15:32:41 +0200
Message-ID: <20260716133053.770025342@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolin Chen <nicolinc@nvidia.com>

commit 172fc8b19825a0f5884c38f2289188284e2d45ee upstream.

On a copy_to_user() failure inside the inner list_for_each_entry, only the
inner loop breaks; the outer while re-fetches the just-restored fault group
and retries the failing copy_to_user() forever, spinning the reader at 100%
CPU with fault->mutex held.

Check rc after the inner loop and break the outer while as well.

Fixes: 07838f7fd529 ("iommufd: Add iommufd fault object")
Link: https://patch.msgid.link/r/336a9b6e44fe66a24199d3be777c405c85c98622.1780343944.git.nicolinc@nvidia.com
Cc: stable@vger.kernel.org
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/eventq.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iommu/iommufd/eventq.c
+++ b/drivers/iommu/iommufd/eventq.c
@@ -168,6 +168,8 @@ static ssize_t iommufd_fault_fops_read(s
 			}
 			done += fault_size;
 		}
+		if (rc)
+			break;
 	}
 	mutex_unlock(&fault->mutex);
 


