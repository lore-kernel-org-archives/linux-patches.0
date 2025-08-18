Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 515D43218C0;
	Mon, 18 Aug 2025 13:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522655; cv=none; b=BqdWJ4QmbtlvYRN8AMaRCdtOI0ar7d+6SF+paqJCSA68bupjTsTw3QqvVIuBjPaV+Ndz0VeeboQ0JEqMrTz99C2KSddOSfDXgAUF/n07uVPPNUmVSkovro6dLvtJTHVbKk1cGeCbHDHlypaf97uLJt0+Y1SkGaBbxmCrC+f2W3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522655; c=relaxed/simple;
	bh=GfiKsblZCmgnsxfbr+wr11VTmvKHpXa1uixi5oD7dkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R3rxOJAYRVIv2UO1+d8gRgivWG89sdJULqph6OWttrTS7adTrcAqA3PTgTTkQ+DWuyCNwr5BEo6HzPbmSa+cJpeMr1MC4E0GAgPC/g/1g255BEJOEhwQ/Zmim7PBuDZ22v0B3I/4DNUjWwuu7uDYZBsZGv+rcgxYlN5GV+W0kpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uzCgsHsa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uzCgsHsa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAD57C4CEEB;
	Mon, 18 Aug 2025 13:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522655;
	bh=GfiKsblZCmgnsxfbr+wr11VTmvKHpXa1uixi5oD7dkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uzCgsHsaWiguIvDF0EvB4NYYH5RR2h6c9et0gyMUjujPmYSmqUDsKEvRZVBiows5+
	 A2DKLSyJV66qhkkRgqCPuuGvlcR6zgpQRp758TM8YIjryOo9z2kicvF/LV7+owUatx
	 HqJzViGwiY43uay1W3VjbrvdsbzW4iVkZ9Zgmipo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Nicolin Chen <nicolinc@nvidia.com>
Subject: [PATCH 6.12 380/444] iommufd: Report unmapped bytes in the error path of iopt_unmap_iova_range
Date: Mon, 18 Aug 2025 14:46:46 +0200
Message-ID: <20250818124503.134167102@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolin Chen <nicolinc@nvidia.com>

commit b23e09f9997771b4b739c1c694fa832b5fa2de02 upstream.

There are callers that read the unmapped bytes even when rc != 0. Thus, do
not forget to report it in the error path too.

Fixes: 8d40205f6093 ("iommufd: Add kAPI toward external drivers for kernel access")
Link: https://patch.msgid.link/r/e2b61303bbc008ba1a4e2d7c2a2894749b59fdac.1752126748.git.nicolinc@nvidia.com
Cc: stable@vger.kernel.org
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/io_pagetable.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/iommu/iommufd/io_pagetable.c
+++ b/drivers/iommu/iommufd/io_pagetable.c
@@ -696,8 +696,10 @@ again:
 			iommufd_access_notify_unmap(iopt, area_first, length);
 			/* Something is not responding to unmap requests. */
 			tries++;
-			if (WARN_ON(tries > 100))
-				return -EDEADLOCK;
+			if (WARN_ON(tries > 100)) {
+				rc = -EDEADLOCK;
+				goto out_unmapped;
+			}
 			goto again;
 		}
 
@@ -719,6 +721,7 @@ again:
 out_unlock_iova:
 	up_write(&iopt->iova_rwsem);
 	up_read(&iopt->domains_rwsem);
+out_unmapped:
 	if (unmapped)
 		*unmapped = unmapped_bytes;
 	return rc;


