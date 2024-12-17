Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8426B1F8ACE;
	Tue, 17 Dec 2024 17:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455924; cv=none; b=n6da7+F6z0jyVwRqP41mmpUoRcg8A6Bt/kkj+PgDbuOeTCd0ATN7K0WtnbqBBIljyAr4gEXaAnnteI3E/hwx2ZIma91H7+Mxo6BxCk8jc9o4zbGG8gqh2MgifM+MqOebvfXD4n2T4JVrWSZTOjEWJh3aJLCUDoF9kanJww0WCEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455924; c=relaxed/simple;
	bh=VX/4dt8R2mA1mzN5xhBsHStVEhOqdafWRfsiYkMkTkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fwzYMpQMnlWMR0P8I7qDGo8Gw8zgq80sbHHFNB5Zkb6//VuSl1qfVAE2m0n2YkZv6Y/0EmS2yhdSDzqFej6GmeUZh18D71rnj3z724in3fOxnJ5nnouc4UKJrHWQCzf/P+riDkrX8DdaxRlYP21KSgJbkJGa/xaCdzbQkYrV5so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tEkGL/VM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tEkGL/VM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 096F6C4CED3;
	Tue, 17 Dec 2024 17:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455924;
	bh=VX/4dt8R2mA1mzN5xhBsHStVEhOqdafWRfsiYkMkTkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tEkGL/VMLt5ue1kmTK48zu/0zx2AcI2SJI2JxqiTe8FIyPZ5Z8VzoQhEYnn7X2zpr
	 PQz+XJMJlB4OyK+xzPIc9YbjCOLZyfaDjz3xeVmkZdgU8IST/3sUy0+zRTshRMzyYY
	 BTG8RkCzBcKvs7PeGt7vWC73bXiDUbn/eZy9I9sE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 52/76] ACPI: resource: Fix memory resource type union access
Date: Tue, 17 Dec 2024 18:07:32 +0100
Message-ID: <20241217170528.427059305@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170526.232803729@linuxfoundation.org>
References: <20241217170526.232803729@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 7899ca9f3bd2b008e9a7c41f2a9f1986052d7e96 ]

In acpi_decode_space() addr->info.mem.caching is checked on main level
for any resource type but addr->info.mem is part of union and thus
valid only if the resource type is memory range.

Move the check inside the preceeding switch/case to only execute it
when the union is of correct type.

Fixes: fcb29bbcd540 ("ACPI: Add prefetch decoding to the address space parser")
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://patch.msgid.link/20241202100614.20731-1-ilpo.jarvinen@linux.intel.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/resource.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index d57bc814dec4..b36b8592667d 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -250,6 +250,9 @@ static bool acpi_decode_space(struct resource_win *win,
 	switch (addr->resource_type) {
 	case ACPI_MEMORY_RANGE:
 		acpi_dev_memresource_flags(res, len, wp);
+
+		if (addr->info.mem.caching == ACPI_PREFETCHABLE_MEMORY)
+			res->flags |= IORESOURCE_PREFETCH;
 		break;
 	case ACPI_IO_RANGE:
 		acpi_dev_ioresource_flags(res, len, iodec,
@@ -265,9 +268,6 @@ static bool acpi_decode_space(struct resource_win *win,
 	if (addr->producer_consumer == ACPI_PRODUCER)
 		res->flags |= IORESOURCE_WINDOW;
 
-	if (addr->info.mem.caching == ACPI_PREFETCHABLE_MEMORY)
-		res->flags |= IORESOURCE_PREFETCH;
-
 	return !(res->flags & IORESOURCE_DISABLED);
 }
 
-- 
2.39.5



