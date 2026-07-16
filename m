Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C7822301;
	Thu, 16 Jul 2026 13:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210115; cv=none; b=l45EmXyYQTH0fdfNw3rggto4rJ5LqIsMRLAuiSRbXEsaGIPiUOVn7ZUjpV0cKnDR1EgVCxNCgTfdubaphOLm3BaUXQbpr6ctyjKePKCxTvxrbgzEFe1Trqo7KILh4YR2tI6KP/cXRz5XYXe6YWPsBYxgbkSnZltXIDeTvUGI8cU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210115; c=relaxed/simple;
	bh=kXC7j6alYjYdCgrevk7cvbBSZYPaO1BbD5Bch/nmCII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uY1B2k64Rd0O0RG88nfYQdImuXq6pXisjoWK1ea/ONv49o8wsWrrMwFNtKeUYza93JxYiEv+Bk6blnoW8fDoxOBNaLPsubozMsMNcNsFp581wk7716H2KIZtLw+SrCp7kb1FtIUrzuu0gsrFknSHug3w8S8HVpJpOlNjIZ4xIx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cfl/PQtJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cfl/PQtJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D71F1F000E9;
	Thu, 16 Jul 2026 13:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210114;
	bh=8Tw39mtRVOxgMbCd/GGP4Xps0wP+uesOGKwRHWmaRyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cfl/PQtJ8zMYT3+J0MlU1thzIDhFkUYnormqMWOT8A5gJGIWEHAyW4QtddpV+VeZ/
	 kWdvcpikFVEdEZhAYxC8uidE4mO4d38AgmpUnrQF4AJT0mWwi7fBSQVJGawlpCZyHc
	 9MDgYjYav+w/eYDLoOETVDtTk3TZfcH/4WIz1424=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pranjal Shrivastava <praan@google.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 7.1 441/518] iommufd: Break the loop on failure in iommufd_fault_fops_read()
Date: Thu, 16 Jul 2026 15:31:49 +0200
Message-ID: <20260716133057.489174071@linuxfoundation.org>
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
 


