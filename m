Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B6C18C331;
	Tue, 10 Sep 2024 09:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961095; cv=none; b=S9ii8xQ9f592ndUDebNzCl760CeDMaR3V35ajE+jZML23cCtZfYiUWVykcaszXVCsw5V8szJksUjeA/CMTeMT+3O9U7eNGfRX3DR/WuhMKrdEjI0PkkdWlO0XnCCDKCrT/dBclxC+zdF2tP1X67W/O6lCfoR3ua6VbVEmCR4g20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961095; c=relaxed/simple;
	bh=gLVg1aSuOmJTRoWitdSZjipeIGmXRHqKiFxDe7LdfhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ua2ZbnjTWglUSqpORWWVYUbFbZsDGQuDvo3a9QPZHVvdq+1KR7xq3mlCVwK3FlKx41OJcN6f0sMHndafbLwU5MnsW2DTvS5QaNBtfNN79FUvWrJBkX6JwOW030Ijg7XASKAqk9jcWMtKtUxSZLuOM2vhDGWmTWdF+q1rFIrCHhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pJQuHWyb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pJQuHWyb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0633C4CEC3;
	Tue, 10 Sep 2024 09:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961095;
	bh=gLVg1aSuOmJTRoWitdSZjipeIGmXRHqKiFxDe7LdfhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pJQuHWybYFekedIJdxxgBNjteek+8zAsRy6/XK8NKO5paV0vnFhvjf7lDHYdvikzQ
	 Nz/zD48EGzZa2TNPMk88m1g0GSkfLHb7TdK0+kJlGMxX/Bvb/ePaAB9aMAB/bgDrO1
	 v2vMi6ijzVSHDjgdTMjEpHNB659zC6wS3W94LfxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jules Irenge <jbi.octave@gmail.com>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 34/96] pcmcia: Use resource_size function on resource object
Date: Tue, 10 Sep 2024 11:31:36 +0200
Message-ID: <20240910092543.010992146@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092541.383432924@linuxfoundation.org>
References: <20240910092541.383432924@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index ac6a3f46b1e6..738660002ef3 100644
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



