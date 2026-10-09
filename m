Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7657A3D9DDB;
	Fri,  9 Oct 2026 14:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557513; cv=none; b=ODGQ9YnPlnINFrcBg9JTlJp5wTTjeDyfZwqTuggfjb8wFF/3lrmtT0PnnRiyFEy1GY4YRer/79EjRAfPxVVAqHFCM4TIk0iPD1Z+MNYLEjbgQ9DxCs5fuEQ7Iur2hQbfaRu9rOzlnTR3rZKHNAvTRE/wSs7gQk8GSfiEBZmwLvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557513; c=relaxed/simple;
	bh=sNX2dLM9wP4kjZrIaZzKIX0UJQco/lYSwY6RlA13vNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hLnrMgqdAmX1CkLRS0/NbiD2/2Odbr+MILtE5BIu6QfSI4lqYWeAocXYl9FmYIg1P4Q3tUVxzsaNaBUCWMrSFCd6MUryAlPZSONKuviR/yGKFTrtwnKJ+SgRQgjKjiCynwNMgXE3g67QE15f/4ub6t7pmNbVnRarD0y6hoMc8jA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XQw0w9RS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XQw0w9RS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D52F71F00893;
	Fri,  9 Oct 2026 14:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557512;
	bh=Ip+HM3nI8rSytreBjiiCYQldNtJeaDLOMyL5dAZx9H8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XQw0w9RS/8o1oJ+g5iDEq9IH0skqJU85X8C4lohKZMhw3FxnnI2u8fUWbTr3dswMj
	 jhU+Hc6AIzK6qE7daE+5pbzv8b8dUct4WrvcMPCPDH54A7W1HWbkCw8pill/ev/YNH
	 RfY8JnJdG1oLjsfPKD3S+7JEvCbBj+BVd5uSmmYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slavin Liu <bolin.liu@seu.edu.cn>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 384/428] iio: adc: pac1934: check ACPI label duplication
Date: Fri,  9 Oct 2026 16:12:01 +0200
Message-ID: <20261009140954.630087465@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Slavin Liu <bolin.liu@seu.edu.cn>

commit 64c82e7bd9c82b0c9276297df34a3579e8658f55 upstream.

A label duplication failure currently reaches the terminating-byte
write. Release the ACPI result and abort before accessing the missing
label; earlier labels are managed by devres.

Detected by static analysis and reviewed with AI-assisted source auditing.

Fixes: 0fb528c8255b ("iio: adc: adding support for PAC193x")
Assisted-by: LLM
Signed-off-by: Slavin Liu <bolin.liu@seu.edu.cn>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/pac1934.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/iio/adc/pac1934.c
+++ b/drivers/iio/adc/pac1934.c
@@ -1108,6 +1108,10 @@ static int pac1934_acpi_parse_channel_co
 			devm_kmemdup(dev, rez->package.elements[i].string.pointer,
 				     (size_t)rez->package.elements[i].string.length + 1,
 				     GFP_KERNEL);
+		if (!info->labels[idx]) {
+			ACPI_FREE(rez);
+			return -ENOMEM;
+		}
 		info->labels[idx][rez->package.elements[i].string.length] = '\0';
 		info->shunts[idx] = rez->package.elements[i + 1].integer.value * 1000;
 		info->active_channels[idx] = (info->shunts[idx] != 0);


