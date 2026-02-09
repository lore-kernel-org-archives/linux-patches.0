Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE8D36828A;
	Mon,  9 Feb 2026 14:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648227; cv=none; b=ecmkYG7gqfHnXtGVZEVI7yx8bKyTxZ2EwP3sDtDQ1uNDVFcoID4uphPMi3QQMmS7EGB+EHFJ/AsnkWoLZnzuIzP6bWIFSgdzTzJ7OGOSvVHewVr9idh8UgP58vvIQ6f/P66yW7B4Fd1TQ8INv+pze/dkipxkit5SyqaX/m9k/UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648227; c=relaxed/simple;
	bh=g1gErmHZf4fr7WkRMrBVLkp5zxVIdS2OoTUKWAPCe0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fWnJZRFKrZFbryFpUF2wzpakqGrIsa+vATbM2av5ba3m6Qp0MZN4m3Xpwect5ti+LGnAsi3xeYgcuSDkcn00ioyGTd4Ao5/mTQn6d8LnA9onbywHEWQ4yjcLOLMymj+rOYWvz0xfCRwbg1V8RZeFRBrLoee0472LxRiJhjtnof8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E/5B1LGr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E/5B1LGr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE6DEC116C6;
	Mon,  9 Feb 2026 14:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648227;
	bh=g1gErmHZf4fr7WkRMrBVLkp5zxVIdS2OoTUKWAPCe0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E/5B1LGrFxa9DuRAuK0tx5DVYdxAJ2iawPZV22y9EjqlLqTDoEYYk10fZ/kTgorcE
	 YTjDK/+hXP9do3Zspzl4//EUpvaMq3s06H2uTrFi3ncTiF7z1tMVZF9hEoNNiQ7RyI
	 Wfp+g+jc7vi3VzZFFdl+eNbk6UJBQFGn/oVtERXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 45/69] platform/x86: toshiba_haps: Fix memory leaks in add/remove routines
Date: Mon,  9 Feb 2026 15:24:13 +0100
Message-ID: <20260209142303.544995907@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142301.913348974@linuxfoundation.org>
References: <20260209142301.913348974@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 49e84095bb010..8a53f6119fed1 100644
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



