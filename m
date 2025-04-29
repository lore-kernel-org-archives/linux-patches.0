Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C77247280;
	Tue, 29 Apr 2025 17:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947457; cv=none; b=IHIaVh2Bk6An/hdcAdl5a5LX+zOfzcTWIr16aVeKFJ4UoCnZb789YaBJacTU9Iisu8ZJV88XIaDUpv4tZibXi1wnO8l1tjXEOxIQJDZo7amOHx/mNU01/ioSXctrqDV010MMpK1opt+LIifRGHrS+fTzYPUJ0cxgArCWFCuJoLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947457; c=relaxed/simple;
	bh=pUhAbxFBNvVFKpeeY7PadJDHBxLVdnHDwpjMcMMauwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S5sZulgFInqBY/sQDawHd5epKq6m4a6te/24T7GtalSiXkdr+ccPdYpsb1Wh2YhFllHkZ7/v326yXUCDJsxZySFewxtIOlxG3wlO5gS987KRI5pLRfIJ7c9jVWMxKX9ug+6+BBeuuH3KG/huJtk10cNpJOHGcnFOx5o0iCyAEko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XEsZdQCq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XEsZdQCq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20597C4CEE3;
	Tue, 29 Apr 2025 17:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947456;
	bh=pUhAbxFBNvVFKpeeY7PadJDHBxLVdnHDwpjMcMMauwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XEsZdQCq+tiTfTfi9Fswi/0F0EYdWZjWT9VqdumJju6uyPMTqK4RhfhjseNCreQfz
	 +hhiDkCTGVpPgZb3AtS4dpnCKrQL64e2L9aGY5a33GAvNpmlVmZJyBZaeRXIsbiT/3
	 RzrzOMz45lHaX7HaOCNL/qzqs2gDSoo/dc0Fo3Tc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanimir Varbanov <stanimir.varbanov@linaro.org>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.10 286/286] media: venus: hfi_parser: Check for instance after hfi platform get
Date: Tue, 29 Apr 2025 18:43:10 +0200
Message-ID: <20250429161119.675569512@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanimir Varbanov <stanimir.varbanov@linaro.org>

commit 9b5d8fd580caa898c6e1b8605c774f2517f786ab upstream.

The inst function argument is != NULL only for Venus v1 and
we did not migrate v1 to a hfi_platform abstraction yet. So
check for instance != NULL only after hfi_platform_get returns
no error.

Fixes: e29929266be1 ("media: venus: Get codecs and capabilities from hfi platform")
Cc: stable@vger.kernel.org # v5.12
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Tested-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/venus/hfi_parser.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/media/platform/qcom/venus/hfi_parser.c
+++ b/drivers/media/platform/qcom/venus/hfi_parser.c
@@ -269,13 +269,13 @@ static int hfi_platform_parser(struct ve
 	u32 enc_codecs, dec_codecs, count = 0;
 	unsigned int entries;
 
-	if (inst)
-		return 0;
-
 	plat = hfi_platform_get(core->res->hfi_version);
 	if (!plat)
 		return -EINVAL;
 
+	if (inst)
+		return 0;
+
 	if (plat->codecs)
 		plat->codecs(&enc_codecs, &dec_codecs, &count);
 


