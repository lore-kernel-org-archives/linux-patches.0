Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C6C46444;
	Tue, 10 Sep 2024 09:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961723; cv=none; b=jHXA6tajDW6NLUm7bDLTtKOgq6vI0jRVEbUHo6jc4PCNg1WjJP8A0NKZsWhCSqkiKYXulpDZvFgzZ/I/2Z7ByLEs9Kdu8rli3vInsUbKFTWhNznKJ5zuQ1lhn9vseOGVvqiErHEeKKXSHfSrIvGXahVCIsapiIOuhLMkkdT2WmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961723; c=relaxed/simple;
	bh=FysTjGnawa2rEOEJiLyOp03E0YluMFCbV5yrYAbLNro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M9vSvtRqhi/NnQGLVj4SlpUiIDN3EFGtQb9Q3VurVFpNnegN4KVlyhMeu/ERWLXcm201c7pmtVIgO4Jv7mEbbaht/KnomV8aUtEvOsN2EMo1C4+HL/4x8ntZ+ssrzPG4aTfDFkEYw+NOzDOIj5uezxsH4zJi5hCuU6k62VYrHuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SDxe0aXc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SDxe0aXc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1E5FC4CEC3;
	Tue, 10 Sep 2024 09:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961723;
	bh=FysTjGnawa2rEOEJiLyOp03E0YluMFCbV5yrYAbLNro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SDxe0aXcy4N11tLbY4wFi8vs73OcW0MRfj/nIYMJMXnr6D6Tkbz06IsAXuFeLBu0i
	 2xDlou2PHytlWg8pSj9gSWG00f5BVEoviBXHWET+4nxPWiGJBx2HSRBrsduAvClFDC
	 yEMbsU36TkzceU6kDRuYH0b5apMfM01rQ8+QzuiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jules Irenge <jbi.octave@gmail.com>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 140/375] pcmcia: Use resource_size function on resource object
Date: Tue, 10 Sep 2024 11:28:57 +0200
Message-ID: <20240910092627.156878284@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1365eaa20ff4..ff169124929c 100644
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



