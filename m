Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4A036606A;
	Sat, 12 Sep 2026 07:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198629; cv=none; b=XuY0456vAZwXBqixaeNsDa8VZIPxPusdh/XY9c3X5OJEzkcRVnMBMU0Q7uTkAtVBjnbcu0+UpmLHdMyUMpS2XdoD8StLHid7av7fjyKkAutC9r6lqO6tU0Cb/f2fVHa0xZvxaH4AEseb5/s6HV2WrNUtBhjOCH0LY7oB6rlpmJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198629; c=relaxed/simple;
	bh=/RXobPzMcNzsYNe3g1h7xgmlsga5+I4UrXvld8h7i54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=izBKjH4wU9dyIJwcYp22vsM3jRgElowbVxtvoXQb+Z+tP3nr7+AoZmK2CYgpcMe3+Fiq65UTEcAyhB3xxRfK957VWaP0KN5821xXEBdBTCeN1m1XCYQ56QIN4okDlLQSWYKxcjoTqABk5P1xL55WBwpt6bmlRU4zZUWp8BByVu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O9jD5ps3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O9jD5ps3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BE591F000FF;
	Sat, 12 Sep 2026 07:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198627;
	bh=Svkr20E3PzZe2ze1OuYnsktTHiBkUEvC048kw2uEBog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O9jD5ps3utaDMi4Zirm5TZJUcJQ1jt2/K6NMoMyTspGM9RAKEYjJ6DhsHS4wDwI0O
	 dcbN45r7wmnrRIZlksYaJUXyRYCPAYANAQzB5r/triUJne3Y4uU5Jd+0qI8wydEsUo
	 paXZzNGou0apGJSk7V+zB6cVwl2/uj6DWziBziwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	John Groves <john@groves.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0421/1815] dax/fsdev: fail probe on invalid pgmap offset
Date: Sat, 12 Sep 2026 08:36:11 +0200
Message-ID: <20260912065658.778842644@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Groves <John@Groves.net>

[ Upstream commit 755effecd6fc7d8ff18f09135cb5e3cf98c20d55 ]

Convert the WARN_ON to a fatal error when pgmap_phys > phys. This
condition means the remapped region starts after the device's data
region, which is an impossible state. Previously the probe continued
with data_offset=0, leaving virt_addr silently misaligned. Now probe
returns -EINVAL with a diagnostic message.

Fixes: 759455848df0b ("dax: Save the kva from memremap")

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Signed-off-by: John Groves <john@groves.net>
Link: https://patch.msgid.link/0100019ecc0999fa-97574544-8b6b-46cf-9f33-423abdbeee7f-000000@email.amazonses.com
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dax/fsdev.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
index 57c589e19b539..d50891d6dc135 100644
--- a/drivers/dax/fsdev.c
+++ b/drivers/dax/fsdev.c
@@ -342,8 +342,12 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
 		u64 phys = dev_dax->ranges[0].range.start;
 		u64 pgmap_phys = pgmap[0].range.start;
 
-		if (!WARN_ON(pgmap_phys > phys))
-			data_offset = phys - pgmap_phys;
+		if (pgmap_phys > phys) {
+			dev_err(dev, "pgmap start %#llx exceeds data start %#llx\n",
+				pgmap_phys, phys);
+			return -EINVAL;
+		}
+		data_offset = phys - pgmap_phys;
 
 		pr_debug("%s: offset detected phys=%llx pgmap_phys=%llx offset=%llx\n",
 		       __func__, phys, pgmap_phys, data_offset);
-- 
2.53.0



