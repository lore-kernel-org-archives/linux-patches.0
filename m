Received: from mxout5.mail.janestreet.com (mxout5.mail.janestreet.com [64.215.233.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A85852F88
	for <patches@lists.linux.dev>; Thu, 11 Sep 2025 14:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=64.215.233.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757602455; cv=none; b=qoqn29VKkggpUljA7mkOCkGZlwAlPnMZtrjeD1ncDTKBv/pfokFrZE/49M6pTATmegBObSYChTV7jezHbv0cs5M8/7VE248QdIub2E4+diZEjGnOntF8tgu5aiGlqj2hFnj/reteoYWSLfitfxnFw1kusPp5ZbrQt0znxsITKBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757602455; c=relaxed/simple;
	bh=0X+qASWWfbtMdtyyu9gb1gPCn4ZDXkJZSYga9dqwO3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CNBAtCQBSZaVi6eI8VGQrbY8oDI4lTpdTKh01bMNejVx99qdlUhgQ3mEEptlsP4TJdHW5UJO8t7rgYvhew8f70Nv6zqZboX5Sasf1QXAC8uvtisNnQ/xXXZXI+reDjFRusvDrZqFCS+u9RUd4kVELGa7Q3W75mOGd+7GF+24d6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=janestreet.com; spf=pass smtp.mailfrom=janestreet.com; dkim=pass (2048-bit key) header.d=janestreet.com header.i=@janestreet.com header.b=whHZBfdb; arc=none smtp.client-ip=64.215.233.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=janestreet.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=janestreet.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=janestreet.com header.i=@janestreet.com header.b="whHZBfdb"
From: Jun Eeo <jeeo@janestreet.com>
To: gregkh@linuxfoundation.org
Cc: hch@lst.de,
 	martin.petersen@oracle.com,
 	patches@lists.linux.dev,
 	riel@surriel.com,
 	sashal@kernel.org,
 	stable@vger.kernel.org,
 	tsi@tuyoix.net
Subject: [PATCH 6.1 035/198] scsi: core: Use GFP_NOIO to avoid circular locking dependency
Date: Thu, 11 Sep 2025 15:54:12 +0100
Message-ID: <20250911145412.537904-1-jeeo@janestreet.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <2025091136-aside-tissue-59a7@gregkh>
References: <2025091136-aside-tissue-59a7@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=janestreet.com;
  s=waixah; t=1757602453;
  bh=0X+qASWWfbtMdtyyu9gb1gPCn4ZDXkJZSYga9dqwO3I=;
  h=From:To:Cc:Subject:Date:In-Reply-To:References;
  b=whHZBfdb8XR2jZTQgU/ZEfd9/qeESuMODZAWhuqmAbrqtUZDtiBte/qNmK3ePPUSn
  USMcAQvJoPQ7qG55BAaFY+9O8JWwqIeA//DvNRzZZv2ATQAG92TakRrd86ziMPj10b
  3Cf/+qha32+sxPLj50PRSP6bTcqZIVgwMnz2dJzk6XuS4I357N3JH+ZdT7oNHRX1oW
  XoM5wNC8bmSucuwrETz82lRidKhlqYiHdrCgidNWlKRNDwEUpmdig9Ppr7sXtGGPLz
  vki4+1SHsgNzRBabrVgtdYJU9CFy5tKIPzrYISgkiWi/HA1x1P7iRWTxKsfUVZE+S2
  PLyMr8ez56eBQ==

> Is this also a problem for you in newer kernels, like 6.16.y?

We haven't tried 6.16.y -- but we couldn't reproduce it on the 6.12
branch (even with this commit) after leaving a couple of them to
reboot repeatedly over ~5 days.

For reference on a 6.1 kernel with this patch, this happens after a
couple of hours of auto rebooting.
