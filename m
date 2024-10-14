Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0432E1AD3E5;
	Mon, 14 Oct 2024 15:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918839; cv=none; b=iRK2liUgEFTdriYK4293wvZuxNjq6dh7v6s9PJdR4fzx41xLxCuTl89keFZeiJnpeUNe4kEmXOxG1ie01Pyyzo9UziSd0a1wI5p/09JGP12uyqs7bUNICtj8mxCrLbISBnRHw/7p5duPHpB5kDkJbk7f18gvyfh3DLgN+eFjYAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918839; c=relaxed/simple;
	bh=x4ZuMnTh/01UQ3VnciBM3F2ygHXZkgsU6cBhHjnKewM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zy+tUCRE3waa+REYBBTcZTwJGoWmroKY6a+P5iJCDVu0G3+UKW2COS3Vj/EyQTn+TIwa/ysUY0n8Eawg6xStaQEZocWVuEy1U3cbZTbUXPERgxGR0+8Vg9C4pithMpxE/yY/LiabFHRall5/XL1v+gUhNzU2nIT0bWEXDv6A1zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sx0tp+OV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sx0tp+OV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 148C1C4CED0;
	Mon, 14 Oct 2024 15:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918838;
	bh=x4ZuMnTh/01UQ3VnciBM3F2ygHXZkgsU6cBhHjnKewM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sx0tp+OVueY6lRADoQUDtVdvhtqdhlPA7NLLfxDiU+vWguClLxVbt6xURpYICiQcM
	 +YmXIxPAMUugb0V5ZHtpz5FtLLCpM4nIf+SxlhpillhBXek9aTP4UP5FXWssLxTwoH
	 F1iTo3H3qKU3hCj21sm8mwvhR7U8qGtZkJbGJu74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 438/798] ACPICA: check null return of ACPI_ALLOCATE_ZEROED() in acpi_db_convert_to_package()
Date: Mon, 14 Oct 2024 16:16:32 +0200
Message-ID: <20241014141235.170659687@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pei Xiao <xiaopei01@kylinos.cn>

[ Upstream commit a5242874488eba2b9062985bf13743c029821330 ]

ACPICA commit 4d4547cf13cca820ff7e0f859ba83e1a610b9fd0

ACPI_ALLOCATE_ZEROED() may fail, elements might be NULL and will cause
NULL pointer dereference later.

Link: https://github.com/acpica/acpica/commit/4d4547cf
Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Link: https://patch.msgid.link/tencent_4A21A2865B8B0A0D12CAEBEB84708EDDB505@qq.com
[ rjw: Subject and changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/dbconvert.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/acpi/acpica/dbconvert.c b/drivers/acpi/acpica/dbconvert.c
index 2b84ac093698a..8dbab69320499 100644
--- a/drivers/acpi/acpica/dbconvert.c
+++ b/drivers/acpi/acpica/dbconvert.c
@@ -174,6 +174,8 @@ acpi_status acpi_db_convert_to_package(char *string, union acpi_object *object)
 	elements =
 	    ACPI_ALLOCATE_ZEROED(DB_DEFAULT_PKG_ELEMENTS *
 				 sizeof(union acpi_object));
+	if (!elements)
+		return (AE_NO_MEMORY);
 
 	this = string;
 	for (i = 0; i < (DB_DEFAULT_PKG_ELEMENTS - 1); i++) {
-- 
2.43.0



