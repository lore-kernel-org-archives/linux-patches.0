Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083211DED65;
	Tue,  8 Oct 2024 13:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393214; cv=none; b=A3ebsWTrcRmPnXhizZfrKLIn4ZECFmyo+w7bIrbh+MNAwyzEmLVYe3KgSp2HzP61yiK0Bi9Qi7Y3EYmKh4MFofTYGGU5Bb6N/6PP1yUP0mbOGQA/169gQwClav9wretet725XXgvMaI8O4NKPK32rR6rxdjp6KlFC/hEmRinYhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393214; c=relaxed/simple;
	bh=/ZT8AWy3KasN3poehEsPb7xCSLSMD+CGYsC5hsfjgQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jNTnjWjLo0iHxApAQcaPIaaOqzcIwh6Nxrnzk+YUZmRLpVsYYhwMUhVJ7gjT8cvhqAbTK3oJQI14EX70tP6i1acD+NrkbrZm8D3GKBT/9LPYKPWhnweQBAo6OnLFls4cceFToVEu2CciPxofj9iBmoRPmbYsX/+cEAens6Trv/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gjw3NUZe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gjw3NUZe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B940C4CEC7;
	Tue,  8 Oct 2024 13:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393213;
	bh=/ZT8AWy3KasN3poehEsPb7xCSLSMD+CGYsC5hsfjgQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gjw3NUZeAg9kLoL14cRwOzL0ehaWccqULnZBXprsbFDD0uEAgG6rcte+IqJb8v8Jw
	 +B4MZpvIG8ixwyJL+bBu0vDz8Ng1L+JArzPyBe5SXzvmvYFbaVR/N9BnVYPWIv3xq7
	 x8xns9QJYAFc7Vn/09s+SyIALKuoNQ5ibNd6g89o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 085/386] ACPICA: check null return of ACPI_ALLOCATE_ZEROED() in acpi_db_convert_to_package()
Date: Tue,  8 Oct 2024 14:05:30 +0200
Message-ID: <20241008115632.800971413@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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



