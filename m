Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4087E149DFA;
	Tue, 17 Dec 2024 17:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455370; cv=none; b=GV/ZxVPiZvj9aS+Fd/e5PaHbSDKx+88Pt9QaDgFdS94jZrcHyKuGBd4J94G0j/JbhiQJewDhcYC0w9YsYjJyG1WAZbt9X+wJiBCakGZUI2cLw1WNiB1/5Ul0gxyFaVXMZDYLsR+ixKdjtiJGODGQ5LWaVeqinp4cUHg9KN764KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455370; c=relaxed/simple;
	bh=jAQcOdGFt8UrWHp/kUyDQEtoRV5clhAFEuhuP/qjfeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mDLH7uEdW3dKkbzhfQ1jgyo/ddWFHYNNOuv2rUW5D5y5ILNIZVlvps7JYYBKzhUTHu4iMKJqIp5d/tTKdtNYgv+osHGEYwKIRNUO1HNZLcVP2ocWvBAL3ox6Oqk16c2wsCvvHgEnxb+yws0v9u4DfnCtbL30y42Tqj3In5u8Jww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EuIZkP4Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EuIZkP4Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F709C4CED3;
	Tue, 17 Dec 2024 17:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455369;
	bh=jAQcOdGFt8UrWHp/kUyDQEtoRV5clhAFEuhuP/qjfeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EuIZkP4QVFIa9i1bM+SApwbWqJ8aFGIR/RzgjY2H2mOfqS7yC84yAfqSrnhoSJMTJ
	 5aDLChmF7uIRiVntJZNS+kOxBA4JAsRN8a4WYfPelktuF7ubWAJw4aGYQxkIPgXrgH
	 AkYlIA/AjFBv/Dlgy4K/qA++JnTN1TEJJSgEJ3Jo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 13/24] ACPI: resource: Fix memory resource type union access
Date: Tue, 17 Dec 2024 18:07:11 +0100
Message-ID: <20241217170519.546547191@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170519.006786596@linuxfoundation.org>
References: <20241217170519.006786596@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 5e59344270ba..65567f26d7bd 100644
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



