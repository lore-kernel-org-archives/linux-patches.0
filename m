Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A9B18595E;
	Tue, 10 Sep 2024 10:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725965025; cv=none; b=JNrxYZ8WQ6Bg9D+RR/OWIzPgXPHCGRd9lWI7469AVZ15xSkYUz7AWEpx6svD0M6DP/wzN+BHnzTt43qlBO19f9q/QPEvdNe6IEz3tCSb7F9i3wPYpQFtBC0hIj9g3mdgqCYOLlnDBthI4I83gNhinAeGH59mM+nWqZp/i6hVoxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725965025; c=relaxed/simple;
	bh=fsKdGrdnfocywnN7N2elFK00djXwPbsincLN5hvmPZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QLraE1ytaQRPVX+J5f/xbyuvLzJgbizZ+5mT8+PDkF90LeD6/58FqnTyYtEWyY+FEuk25qg7L+4gXylKQixaakmkh+6AHJaVcaww2i8Cg9zK9ZzQ6M32/4Xvrh3lC93aYl+9ySKPD8A/ebR2W0qhcEnFlJzWm5kSDehexWYGv9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HBlz4Wbg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HBlz4Wbg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D143C4CEC3;
	Tue, 10 Sep 2024 10:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725965025;
	bh=fsKdGrdnfocywnN7N2elFK00djXwPbsincLN5hvmPZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HBlz4Wbg7EMH0r5Wjs+T5xbDH+IwJ2q7hlhdzj8QteYAqFQuIlsgoVvwWI6mOZCW+
	 13caOQwgvUQewmk0RgSGdsP5m42G/3KyUYVmdPikPrLjPrQpmmhzO4qqJxh9UnnGhI
	 nkqbjhRZfrqFs+uqFi3h0tr522SU5O3f6C0El3Z0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jules Irenge <jbi.octave@gmail.com>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 111/186] pcmcia: Use resource_size function on resource object
Date: Tue, 10 Sep 2024 11:33:26 +0200
Message-ID: <20240910092559.097813626@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jules Irenge <jbi.octave@gmail.com>

[ Upstream commit 24a025497e7e883bd2adef5d0ece1e9b9268009f ]

Cocinnele reports a warning

WARNING: Suspicious code. resource_size is maybe missing with root

The root cause is the function resource_size is not used when needed

Use resource_size() on variable "root" of type resource

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pcmcia/yenta_socket.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pcmcia/yenta_socket.c b/drivers/pcmcia/yenta_socket.c
index 84bfc0e85d6b..f15b72c6e57e 100644
--- a/drivers/pcmcia/yenta_socket.c
+++ b/drivers/pcmcia/yenta_socket.c
@@ -636,11 +636,11 @@ static int yenta_search_one_res(struct resource *root, struct resource *res,
 		start = PCIBIOS_MIN_CARDBUS_IO;
 		end = ~0U;
 	} else {
-		unsigned long avail = root->end - root->start;
+		unsigned long avail = resource_size(root);
 		int i;
 		size = BRIDGE_MEM_MAX;
-		if (size > avail/8) {
-			size = (avail+1)/8;
+		if (size > (avail - 1) / 8) {
+			size = avail / 8;
 			/* round size down to next power of 2 */
 			i = 0;
 			while ((size /= 2) != 0)
-- 
2.43.0



