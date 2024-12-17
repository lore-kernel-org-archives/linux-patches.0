Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD761F8AD4;
	Tue, 17 Dec 2024 17:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456698; cv=none; b=q+AzTcWaG2zkDerYh7jeca7dpV47ZQZnH1LcOd8OzfwF2gupzie/xFtq4cToS33SJndrQg+JNwxiHRgkeZZcCFWElLnoDhuGYDccg9zYx6fRjiZtFiiqSimi5YdH3pTcvq4mCeOwjG3lfD7WsgA1IKPlq0c7bcL0QDoZKswyNr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456698; c=relaxed/simple;
	bh=NJdHcj7r4fSwKJ391Z9vceFa6cTsNDgVG1cDZUWyowY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WyVkQF425uFpNbmno7XwFRYGtN3TT/3jy+HB8fRJY1kNN6w/FKgwPtwugl8mDWs4PfBi0jgSjCfnNXvc3GuR6JrVgG4pSKKSeziRHazUtonYyJCgaFmG9TqTVBFZcFvBmbKQm4nyAaX1KoII5CIEkvhyDchsMUChgZMylAf84y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dRALHy6y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dRALHy6y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24EFFC4CED3;
	Tue, 17 Dec 2024 17:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456698;
	bh=NJdHcj7r4fSwKJ391Z9vceFa6cTsNDgVG1cDZUWyowY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dRALHy6yj0PctF9yipZIh1/+afihB8XOliNoD3c23X6oFrC6OAs9kYhrHdHhPbIge
	 u4mbgufiGZGBtYcNg6fzBTl0AKzMUkQ1EHbRLExTCZo1GFh6PAckqlCoiDE1Qak3tm
	 Vzt1X+VoGD/JB76tdP0FVmZpJv1nfl/SoHqj2NqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 112/172] ACPI: resource: Fix memory resource type union access
Date: Tue, 17 Dec 2024 18:07:48 +0100
Message-ID: <20241217170550.969360686@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7fe842dae1ec..821867de43be 100644
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



