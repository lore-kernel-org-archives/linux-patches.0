Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E48D72624;
	Mon, 23 Jun 2025 21:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715611; cv=none; b=bNWJ+Yke+OShSLtZ35fhnqPXjll3SMMOGbrJY97CVWzNA0P+sOWVNfKGpcBvawYzTmYurEw2eFbfzOrB/fF91uc4kFP+PLoUPsBMNEd8AQOzL6ive9bQZZ9a5yf1Q6Pz7yxT103sq9tWG/qQGBGuovk4s3znJDICESqF5uf0spU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715611; c=relaxed/simple;
	bh=3pZ7ak7q9tkFeBYNmUx7F4tjdmCfJNZRl3HXZpBPu1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZVi0pssceKAeHJ3WeXxWyCd1Sdg19456/WUlnm56QGIN28e4Zl3xi/Fwvy3D3b6uGJq4TtUQSEXheTT6CThaSVJ+8tGpVOW5pM92lfkahPV3NzDdrovKUsSVUyAJgqZSkcCVjVYEg5fECcjj1oisoERmaV9x6/8NIGPBjzmLBNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mFXML4nK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mFXML4nK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E1B1C4CEF1;
	Mon, 23 Jun 2025 21:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715611;
	bh=3pZ7ak7q9tkFeBYNmUx7F4tjdmCfJNZRl3HXZpBPu1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mFXML4nKzirL5swKMy6Z5wu/BotnfEX1FIZGddq3Kc4cvflv4fQvDfh8WfUOSf7qD
	 4lCOXFG6GO0J2/eKzji7yGHu4FuCOHvRIfYhVLyeyFD/yyqieIRB5W8J27XbGxj8Nj
	 eckAWRje2iOAKxWRxdg9vbt5P+gX374Knr4s3G/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Zi <ziyao@disroot.org>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 210/290] platform/loongarch: laptop: Unregister generic_sub_drivers on exit
Date: Mon, 23 Jun 2025 15:07:51 +0200
Message-ID: <20250623130633.247570124@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


