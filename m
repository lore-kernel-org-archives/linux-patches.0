Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43AE113D605;
	Thu, 13 Jun 2024 11:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279490; cv=none; b=BlKRlRsYem+nAMt+UG1Ys45PUG9Hr4XZjOGp6zgBRIMAzVFB28sau3eIuA+2viBw7isiKqaVsSzmj8DvcWU54ZAT+v93SCkV6nDrw/kAKRa7uLOc1AJpE+ZUX5XEjClhG+v3THDkHxmM/HXdFsnSPbIHLo2v3R8o9jEaP4oHdUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279490; c=relaxed/simple;
	bh=cXPGiOMVw/xNa8sw5wLsMs1t5fVzXirc2bZP79tt8q0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nYxUAX/fGxZDuh5wHKP8RcsNL8bOil16NpiXQYYboi5nB1Dq/X0N/zQYAZgnDx6bELI+hH0eKdNm/YHdu2xqnH9+W4BiTS++RCZeuWXrijmYFyOGDSkgrbZ4m2lXf+CBAtUR0zFcL1Tf1G5H0TJzHzh/JmXUB3SP1nPaHlhphFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BCugONt9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BCugONt9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 872FFC2BBFC;
	Thu, 13 Jun 2024 11:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279489;
	bh=cXPGiOMVw/xNa8sw5wLsMs1t5fVzXirc2bZP79tt8q0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BCugONt9qxuRL+QG9SltBEuvPuXyngBET0HoX+xsyDSBQS4geHiUkSYB9uoCMdhmM
	 Ue8UE2aUuP4GpXP4C7H5eQsA4+qtK8z8VShJ54Hz0mXeV/Ysm7SQldOIokybC7Qx5b
	 ucwMmPsq1Rc7V/6YSpjPSu7DmjytMCXYOl5QsK6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.9 062/157] LoongArch: Fix built-in DTB detection
Date: Thu, 13 Jun 2024 13:33:07 +0200
Message-ID: <20240613113229.823603963@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

commit b56f67a6c748bb009f313f91651c8020d2338d63 upstream.

fdt_check_header(__dtb_start) will always success because kernel
provides a dummy dtb, and by coincidence __dtb_start clashed with
entry of this dummy dtb. The consequence is fdt passed from firmware
will never be taken.

Fix by trying to utilise __dtb_start only when CONFIG_BUILTIN_DTB is
enabled.

Cc: stable@vger.kernel.org
Fixes: 7b937cc243e5 ("of: Create of_root if no dtb provided by firmware")
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/setup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/loongarch/kernel/setup.c b/arch/loongarch/kernel/setup.c
index 89ad756aeeed..3d048f1be143 100644
--- a/arch/loongarch/kernel/setup.c
+++ b/arch/loongarch/kernel/setup.c
@@ -282,7 +282,7 @@ static void __init fdt_setup(void)
 		return;
 
 	/* Prefer to use built-in dtb, checking its legality first. */
-	if (!fdt_check_header(__dtb_start))
+	if (IS_ENABLED(CONFIG_BUILTIN_DTB) && !fdt_check_header(__dtb_start))
 		fdt_pointer = __dtb_start;
 	else
 		fdt_pointer = efi_fdt_pointer(); /* Fallback to firmware dtb */
-- 
2.45.2



