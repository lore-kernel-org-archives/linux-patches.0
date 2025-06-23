Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DF2D13A265;
	Mon, 23 Jun 2025 13:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684588; cv=none; b=EedV7lt/9BWjMr60mC+3dadLq8DRG86kUBImkIKkuhsNv5pCsEuCF4uqOzu95eoFm/6uBBgE3sizgXmMBx66koNAUDVXDgfhqdO7alzW6KoTBlaDyO7w/eeldqCBxHMZirmHX6M3XTLIE7HusPU6Y6RvPYUoee9epy9gTJxP2sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684588; c=relaxed/simple;
	bh=IZ91mWhp3D9wcUVmzkCgx+QKEkZ/+crSFhwwfwyGGNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fdz1kKppGOyYdrxUonWyWd1sUl6ZPX4yHnH5kodQumHNxsy+/4P+pue3/3wawLQExHVTYPhMWgeTmyQGemZXZ9BXed/AxlFrbD95er+LOLMwQgEuyNUQ50iGFu+ot87NikRF5U9bt0AtKxq74oxxm9NkP2MNlyOh+57ewcjshBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eWSFk8En; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eWSFk8En"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08818C4CEEA;
	Mon, 23 Jun 2025 13:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684588;
	bh=IZ91mWhp3D9wcUVmzkCgx+QKEkZ/+crSFhwwfwyGGNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eWSFk8EnMYvAA2g8ZoKCWwsZ54Fflt4l60bk07oKEtWZSwa9781ic7sTkPGdNc4k8
	 2mwQdeZSL9329+j60t/tJ4CtzwKqsUxSDiohLS5vKigvTTaa5df4RhBfTzF3cjMxni
	 3WPPG+EowOrnCQlwHPBmIjA66Ko6T8J2FlhKDv34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Yao <hao.yao@intel.com>,
	Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.15 072/592] media: ipu6: Remove workaround for Meteor Lake ES2
Date: Mon, 23 Jun 2025 15:00:30 +0200
Message-ID: <20250623130701.977086909@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hao Yao <hao.yao@intel.com>

commit d471fb06b21ae54bf76464731ae1dcb26ef1ca68 upstream.

There was a hardware bug which need IPU6 driver to disable the ATS. This
workaround is not needed anymore as the bug was fixed in hardware level.

Additionally, Arrow Lake has the same IPU6 PCI ID and x86 stepping but
does not have the bug. Removing the Meteor Lake workaround is also
required for the driver to function on Arrow Lake.

Signed-off-by: Hao Yao <hao.yao@intel.com>
Reviewed-by: Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
Fixes: 25fedc021985 ("media: intel/ipu6: add Intel IPU6 PCI device driver")
Cc: stable@vger.kernel.org
[Sakari Ailus: Added tags and explanation of what is fixed.]
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/pci/intel/ipu6/ipu6.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/drivers/media/pci/intel/ipu6/ipu6.c
+++ b/drivers/media/pci/intel/ipu6/ipu6.c
@@ -464,11 +464,6 @@ static int ipu6_pci_config_setup(struct
 {
 	int ret;
 
-	/* disable IPU6 PCI ATS on mtl ES2 */
-	if (is_ipu6ep_mtl(hw_ver) && boot_cpu_data.x86_stepping == 0x2 &&
-	    pci_ats_supported(dev))
-		pci_disable_ats(dev);
-
 	/* No PCI msi capability for IPU6EP */
 	if (is_ipu6ep(hw_ver) || is_ipu6ep_mtl(hw_ver)) {
 		/* likely do nothing as msi not enabled by default */


