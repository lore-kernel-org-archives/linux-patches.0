Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05D85336EF1;
	Tue, 17 Mar 2026 17:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768427; cv=none; b=YWeMbykZvYToHp89HmO8IC1V7M8d/BmzcgMuolimPFtkVSfaQPaY95wJtLzEjPxUKlVkI3PpZ+xiOgLuS3sWgzITZb0JOhauRPdmFGHeygC46pRwC20fl9D29GzdfG+MFG5ATMUA6bgPbfP6H3Mx/YSC36GKlVzJdwENHTAKKoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768427; c=relaxed/simple;
	bh=iqLfbxTLfyxp8z01K9ijVNn119m99wfMgxr9gZZfpNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t+6cc0DYMPiXqG9eGgPYVT8o63JUi+COfKtYyemRsZ7NpkYGZ6qdxJUzJ86wKmOWYv+wBgTVcCAAZKYFedVOZJfaGMYoSLQtduBw2qmMSPyPtBSPzp1daxu+dvoGaKCtPwtlcEojYcx2fuyTFDEW/UKUCtUgQw77vhSlTsV/u6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m5fyTngr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m5fyTngr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11016C19424;
	Tue, 17 Mar 2026 17:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768426;
	bh=iqLfbxTLfyxp8z01K9ijVNn119m99wfMgxr9gZZfpNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m5fyTngrC1W+aMVmzQGHH9IDkkUXon3Mq4eY09721AgkHiWVbNZ6pQYmQIf2ZlZId
	 8BoM6Bbiq/dKW763vF37uTRe0wBRxlgxrN/igQGhvDzch0alA5hD9uvnqlYcB3Pf7A
	 CK/40Tkv9KP9lL4t2sa1wlDWe7m6JLD8iLivRtKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yasin Lee <yasin.lee.x@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.18 306/333] iio: proximity: hx9023s: fix assignment order for __counted_by
Date: Tue, 17 Mar 2026 17:35:35 +0100
Message-ID: <20260317163010.737212460@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

From: Yasin Lee <yasin.lee.x@gmail.com>

commit 585b90c0161ab77416fe3acdbdc55b978e33e16c upstream.

Initialize fw_size before copying firmware data into the flexible
array member to match the __counted_by() annotation. This fixes the
incorrect assignment order that triggers runtime safety checks.

Fixes: e9ed97be4fcc ("iio: proximity: hx9023s: Added firmware file parsing functionality")
Signed-off-by: Yasin Lee <yasin.lee.x@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/proximity/hx9023s.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/iio/proximity/hx9023s.c
+++ b/drivers/iio/proximity/hx9023s.c
@@ -1034,9 +1034,8 @@ static int hx9023s_send_cfg(const struct
 	if (!bin)
 		return -ENOMEM;
 
-	memcpy(bin->data, fw->data, fw->size);
-
 	bin->fw_size = fw->size;
+	memcpy(bin->data, fw->data, bin->fw_size);
 	bin->fw_ver = bin->data[FW_VER_OFFSET];
 	bin->reg_count = get_unaligned_le16(bin->data + FW_REG_CNT_OFFSET);
 


