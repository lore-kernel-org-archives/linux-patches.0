Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A86EC4;
	Thu, 13 Jun 2024 12:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281824; cv=none; b=Iqro+m5AxCMqiHQ5SrXVvrOyu5U0VrohXUgzPu8D2HEwNAbYMUCyITXYefiKw79EVvgR6z/5QGLEdm9y7INNh1p+tmFmC4dZYX4n/1VtA0ANI+PcGhET95QvJOYfvTsfG5gDIRcNrlInt/YEc0oi1InzrjXOTKMTx1/xxUYH+JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281824; c=relaxed/simple;
	bh=NgleXaFDBfO+XzwBfYdL7tcMv1REkJW6Xki1h0rhXTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zv8mazdS/rESXBUcOk/XUR+6JC3e/M/XsLgDBMT3fh56ivpNJPj2eSLwqVmflp/oSd+6P0LaP8FDC1KFhgM+s7yqJLo2nfEoAUJFnEyorYT4QGHeYjGIInF46ADOqXCaeuKCnlz5svT4i8ALBD/iyuad6eoKYwYKnt5CJchDqeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GHcp5mEN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GHcp5mEN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BDB9C2BBFC;
	Thu, 13 Jun 2024 12:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281824;
	bh=NgleXaFDBfO+XzwBfYdL7tcMv1REkJW6Xki1h0rhXTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GHcp5mEN41uJDUVLFBxImASETXla00Fsr06EnRPPCM8l8CbJLKc9T/6lLGAYbi5zl
	 IikQznZYApbRg/7D3MQNElMFEf3V+vCNvY+Gz1y0v8m12ftYMIKjMZDI6gZuydboyc
	 j+Opcdb2GqfraVWbKsUu+EebCkSYuIzHkard+0Gk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 068/402] ACPI: disable -Wstringop-truncation
Date: Thu, 13 Jun 2024 13:30:25 +0200
Message-ID: <20240613113304.789300152@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f919811156b1f..b6cf9c9bd6396 100644
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



