Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B063FD4;
	Mon, 23 Jun 2025 21:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715289; cv=none; b=n6UeIemV1HihTdNGqWLvNkrcsFgY9HWYkfW5+XOrD5Z+nMGNz8n9Hhxq9hAXfdYXlxXIWf0AoxBIhrsGeJxq2ErVyQNCMO9kkLw/w72uYNZG0lzeTwIsnJjU4b2gw4873WZmBazcLV88GJRVJlwgJSbE40bnXbGTp6YEMycTBCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715289; c=relaxed/simple;
	bh=wGklmCljeo8MTlxqtWQcOtLUG+TTNMbXKkaqhrgHUis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ROnlYUeiCz6NXMJieFreQdSJ12ubDB3TyOGd8mTxso2K2idA561HRWVtz//n5WEeZ1tGJGgC5EYRTmdV9ohQ6PJBHb8ylKpTh9TVQWs2rVQAGaMYhh1Ae3hFz4l2ngMH5tojS3qgh/E0e8newFMUGLU8GqeDxM30M+E01F8Xj9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dix/akcU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dix/akcU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DCF1C4CEEA;
	Mon, 23 Jun 2025 21:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715289;
	bh=wGklmCljeo8MTlxqtWQcOtLUG+TTNMbXKkaqhrgHUis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dix/akcUi2AIX6Url5t29d7mnZqjU9eSyv5B7fRicyjD9tQKnMpwFdM7Olcd4QcFj
	 z4vBia57vO/ycuaNZSwrCJWO/aT5KdVo1SJF06+NLlSoRvPmrpvZRx3B5Lkc3eFScz
	 1NaoqyLLWMl1/sxqqaRc26xToO229HfgCuCwKGc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Zi <ziyao@disroot.org>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.15 449/592] platform/loongarch: laptop: Unregister generic_sub_drivers on exit
Date: Mon, 23 Jun 2025 15:06:47 +0200
Message-ID: <20250623130711.109167169@linuxfoundation.org>
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

From: Yao Zi <ziyao@disroot.org>

commit f78fb2576f22b0ba5297412a9aa7691920666c41 upstream.

Without correct unregisteration, ACPI notify handlers and the platform
drivers installed by generic_subdriver_init() will become dangling
references after removing the loongson_laptop module, triggering various
kernel faults when a hotkey is sent or at kernel shutdown.

Cc: stable@vger.kernel.org
Fixes: 6246ed09111f ("LoongArch: Add ACPI-based generic laptop driver")
Signed-off-by: Yao Zi <ziyao@disroot.org>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/loongarch/loongson-laptop.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/platform/loongarch/loongson-laptop.c
+++ b/drivers/platform/loongarch/loongson-laptop.c
@@ -611,11 +611,17 @@ static int __init generic_acpi_laptop_in
 
 static void __exit generic_acpi_laptop_exit(void)
 {
+	int i;
+
 	if (generic_inputdev) {
-		if (input_device_registered)
-			input_unregister_device(generic_inputdev);
-		else
+		if (!input_device_registered) {
 			input_free_device(generic_inputdev);
+		} else {
+			input_unregister_device(generic_inputdev);
+
+			for (i = 0; i < ARRAY_SIZE(generic_sub_drivers); i++)
+				generic_subdriver_exit(&generic_sub_drivers[i]);
+		}
 	}
 }
 


