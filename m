Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E78D1946A1;
	Tue, 10 Sep 2024 10:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962893; cv=none; b=BZAjRcj5Y05icMlnwTX5qmdPTG0/HgFPCKr89l1fsLGMK7bkELdLCpWfizjQxIyfZQmY/GQP03ZPEAE/0duwd8We8x9sLbDHBBj8QSKHg5wJNYseE9DW1L0L+Syx+XFmP4VCWb7JseEMaYYS4nLbk+8gScAt2rfFtf32r3vciM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962893; c=relaxed/simple;
	bh=2PT95Zio2CQ/2ynSY83n1hkPQMAeY+gmo82HxPKREOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xy/r8RtU72606r8jxLI9+nWMmc4irIT36wZRmPvHDWydPFZXdUsmM0MzmlMLPegk/CsO/tqlXGU4173zgJyLSxEWJGSYFij1d+M6OFDxjiHeJF4CO5jhHMlom8o5Uw40Um06KX9kJbyYwHCLdhDmkEmhrw4XgfJ0rUt0PH9JpSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H79dcDDn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H79dcDDn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8778FC4CECD;
	Tue, 10 Sep 2024 10:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962892;
	bh=2PT95Zio2CQ/2ynSY83n1hkPQMAeY+gmo82HxPKREOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H79dcDDn0sxNY4xkPAnAtFfKeTQg6rcPUvjKnDuEFPeaaMDG+yzAz6i5F5hU1WBNa
	 dPDahOwPsc0OhvjGHDS8jzxdsQXcbDus4HwU4eW+6E0zqvz/P9WCRniwj8fN6BDAlH
	 nWcikuxjOYsUI4XlFYT+HOozoL1hTaylB0pyYQLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jules Irenge <jbi.octave@gmail.com>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 065/192] pcmcia: Use resource_size function on resource object
Date: Tue, 10 Sep 2024 11:31:29 +0200
Message-ID: <20240910092600.668690794@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3966a6ceb1ac..a1c16352c01c 100644
--- a/drivers/pcmcia/yenta_socket.c
+++ b/drivers/pcmcia/yenta_socket.c
@@ -638,11 +638,11 @@ static int yenta_search_one_res(struct resource *root, struct resource *res,
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



