Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 596D72BCF4C;
	Mon,  9 Feb 2026 14:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648676; cv=none; b=JKVi+yb8TcLk/a+cdGbxoPyglTSeJ5GdxEGXTnH0i5b51X0Jt9Jlj+Dkc8LkVyX0W/M4zWJydo5s/Mwh45EQzJO+L1SSAHwAcFKfE4eiWEMDSvmOIafnYj8K5vzN/Td0l8B+HKFrh+9cv4nSdvaZ8FDEGX+Bb6vhqpfl5nb6htc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648676; c=relaxed/simple;
	bh=XovpWE0tRgvjuUg9tmAnjEFlL0r8Fu0/0sEdq24i7vk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GCPNugBK9d8bK+yZGYcWtdFpog1D3A9AaZtNi5ONDcycHh9SvyIna0XSYCbu/KWxN3BKwXnxMuJIV7buwEgAyxnocW/GBMD91jFve9asfmi25as8U/lXBEmLLkQ5W39tHy6vWz3Ww5w54LxuoOgqnB6DW3ugy2A93FA2IUCj2+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dSNyR2GB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dSNyR2GB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0747C116C6;
	Mon,  9 Feb 2026 14:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648676;
	bh=XovpWE0tRgvjuUg9tmAnjEFlL0r8Fu0/0sEdq24i7vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dSNyR2GB6Se/FuC1wL2HMHWqiLQaw32Pn4iiFcWBMkdRfsF89KCht3IeJunBg2IC3
	 wn3ktGBcss7rjcXh58EgogEzeca4VHlhWLBHsKZpuc+DCYLIewcUGJU/JQCt0Tu9dg
	 gTVHI8OONJoqI1YP2u3jRzq7NPXrphjh328QJkUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 23/41] platform/x86: toshiba_haps: Fix memory leaks in add/remove routines
Date: Mon,  9 Feb 2026 15:24:44 +0100
Message-ID: <20260209142257.647697991@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142256.797267956@linuxfoundation.org>
References: <20260209142256.797267956@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 128497456756e1b952bd5a912cd073836465109d ]

toshiba_haps_add() leaks the haps object allocated by it if it returns
an error after allocating that object successfully.

toshiba_haps_remove() does not free the object pointed to by
toshiba_haps before clearing that pointer, so it becomes unreachable
allocated memory.

Address these memory leaks by using devm_kzalloc() for allocating
the memory in question.

Fixes: 23d0ba0c908a ("platform/x86: Toshiba HDD Active Protection Sensor")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/toshiba_haps.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/toshiba_haps.c b/drivers/platform/x86/toshiba_haps.c
index b237bd6b1ee54..e9ae102c0bfd7 100644
--- a/drivers/platform/x86/toshiba_haps.c
+++ b/drivers/platform/x86/toshiba_haps.c
@@ -185,7 +185,7 @@ static int toshiba_haps_add(struct acpi_device *acpi_dev)
 
 	pr_info("Toshiba HDD Active Protection Sensor device\n");
 
-	haps = kzalloc(sizeof(struct toshiba_haps_dev), GFP_KERNEL);
+	haps = devm_kzalloc(&acpi_dev->dev, sizeof(*haps), GFP_KERNEL);
 	if (!haps)
 		return -ENOMEM;
 
-- 
2.51.0



