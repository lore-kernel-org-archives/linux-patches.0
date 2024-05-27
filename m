Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2608168C4;
	Mon, 27 May 2024 19:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837952; cv=none; b=iE9H3Ke6x0Sin56tMWJKuWdmlpx9s4W0R9uju5QLaCdWajaK1Y7VTtP6Q/vUftKcvpzoi2of+8Tl6o7+sD3PuZAusMh3UarrOxi9FOVwHsytaVJhALn/AhuzsKcJQtygPVX3fkeZeAB+bzoTjOdDdb5/ydiQA2T7zsGs0X+CG6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837952; c=relaxed/simple;
	bh=2J3DrBeOWC7QOaMwMBOeeOoCy2SCGGYlCCt3RbHzp6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AYZsntBjhruzeWIK5td3YWgI31CUaMj3YWd9mCp3JWgSt3eid3iRzMUkDhq/lJZuPjJId3AgS558Bqov4vzu5TEJP5FDaqXydmlL8ypASkD34QHKxMn3rCMFet+dZxyi3ARXPXY+vP9oderC5WyQCdJYALLc1kBHELa744EqUMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RdrlBk00; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RdrlBk00"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B7E1C2BBFC;
	Mon, 27 May 2024 19:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837952;
	bh=2J3DrBeOWC7QOaMwMBOeeOoCy2SCGGYlCCt3RbHzp6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RdrlBk00jYt3pkV4bPaUc2xvu6me1JkGt81H7Os/5IEsmsf1J6/OuJ8NmvfzdFJun
	 U7rvanYFtOYiTz0nqeTyDqjYhd+UVNVezSpGleimwYtt+kjWJb8iBHByA+XbaGh+vX
	 hO0tFvdfQ85mnLtPgv5JQIon94L8pDyg17LtxsZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 208/493] ACPI: disable -Wstringop-truncation
Date: Mon, 27 May 2024 20:53:30 +0200
Message-ID: <20240527185637.125814316@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit a3403d304708f60565582d60af4316289d0316a0 ]

gcc -Wstringop-truncation warns about copying a string that results in a
missing nul termination:

drivers/acpi/acpica/tbfind.c: In function 'acpi_tb_find_table':
drivers/acpi/acpica/tbfind.c:60:9: error: 'strncpy' specified bound 6 equals destination size [-Werror=stringop-truncation]
   60 |         strncpy(header.oem_id, oem_id, ACPI_OEM_ID_SIZE);
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/acpi/acpica/tbfind.c:61:9: error: 'strncpy' specified bound 8 equals destination size [-Werror=stringop-truncation]
   61 |         strncpy(header.oem_table_id, oem_table_id, ACPI_OEM_TABLE_ID_SIZE);
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The code works as intended, and the warning could be addressed by using
a memcpy(), but turning the warning off for this file works equally well
and may be easier to merge.

Fixes: 47c08729bf1c ("ACPICA: Fix for LoadTable operator, input strings")
Link: https://lore.kernel.org/lkml/CAJZ5v0hoUfv54KW7y4223Mn9E7D4xvR7whRFNLTBqCZMUxT50Q@mail.gmail.com/#t
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/acpi/acpica/Makefile b/drivers/acpi/acpica/Makefile
index 30f3fc13c29d1..8d18af396de92 100644
--- a/drivers/acpi/acpica/Makefile
+++ b/drivers/acpi/acpica/Makefile
@@ -5,6 +5,7 @@
 
 ccflags-y			:= -D_LINUX -DBUILDING_ACPICA
 ccflags-$(CONFIG_ACPI_DEBUG)	+= -DACPI_DEBUG_OUTPUT
+CFLAGS_tbfind.o 		+= $(call cc-disable-warning, stringop-truncation)
 
 # use acpi.o to put all files here into acpi.o modparam namespace
 obj-y	+= acpi.o
-- 
2.43.0



