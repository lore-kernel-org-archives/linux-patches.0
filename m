Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF0D13AA5F;
	Fri,  6 Dec 2024 15:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498032; cv=none; b=eAY8HibaKA1Robge9Q0IpTt6U6tHrf1PfSrCSpSUTvOr2Gk8IPRWFdgtw++v7XWmYMZ6zmphihzs3arhTHkj7tDhCBDFeKuCJDn2D1JFPaG7KsGtQC5QAmCIRQ1rnvPAdrKc1TSrQ5aJJCCeCkA0KwaOiv8cjvXidjOCvzYzxTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498032; c=relaxed/simple;
	bh=h2PfdYUuh2YmnZSItVgC2/5C2TfKK6Hg6eIy8uQAJmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UU/F0LbnkF4wF8Go4VzGZwSAyz5YvX+tXl3YpUO7qcYBaVWUfO6YuDXt22RJj0fMlJdUVE8ZEKnBh/89zq8WGw7qlA8S22J4M3ihrOiWAMUBPruf1Z88uQ2Ah7GsFFLOe3OYAdjeRrAjsX1OZ4/SeWuOHDIEi6f4ppSeuyuQs9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lqMjxGOO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lqMjxGOO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15577C4CED1;
	Fri,  6 Dec 2024 15:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498032;
	bh=h2PfdYUuh2YmnZSItVgC2/5C2TfKK6Hg6eIy8uQAJmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lqMjxGOO2iM3WyRr8MNljWCYXvVnxsqZeHuniVs9s/IcUdchKuGzBQdF+At0W0UfT
	 6JY8yO5NfjvaEDhoFaphvo1g4zhxzJpfCLd/iYQq+oXcJMqQE4uDQA987w4wzfd9j1
	 kzsXFTn2xSZoJ7wdzC9PeDzXxooqBFLOsNpcFTvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 467/676] ASoC: Intel: sst: Fix used of uninitialized ctx to log an error
Date: Fri,  6 Dec 2024 15:34:46 +0100
Message-ID: <20241206143711.611700473@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit c1895ba181e560144601fafe46aeedbafdf4dbc4 upstream.

Fix the new "LPE0F28" code path using the uninitialized ctx variable
to log an error.

Fixes: 6668610b4d8c ("ASoC: Intel: sst: Support LPE0F28 ACPI HID")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202410261106.EBx49ssy-lkp@intel.com/
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patch.msgid.link/20241026143615.171821-1-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/intel/atom/sst/sst_acpi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/intel/atom/sst/sst_acpi.c
+++ b/sound/soc/intel/atom/sst/sst_acpi.c
@@ -308,7 +308,7 @@ static int sst_acpi_probe(struct platfor
 		rsrc = platform_get_resource(pdev, IORESOURCE_MEM,
 					     pdata->res_info->acpi_lpe_res_index);
 		if (!rsrc) {
-			dev_err(ctx->dev, "Invalid SHIM base\n");
+			dev_err(dev, "Invalid SHIM base\n");
 			return -EIO;
 		}
 		rsrc->start -= pdata->res_info->shim_offset;


