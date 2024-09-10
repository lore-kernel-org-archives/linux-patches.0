Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B92B19068E;
	Tue, 10 Sep 2024 10:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963697; cv=none; b=thTchLcqWW7KlwU47plP7cHT/A8S+gMcnsnJ00ARuRUl2zPgce45XwqtV8j+uXb1Sl9kTcdrg6L83J1s3hbLcRTynaqwTrvxRSBD3pq1qxY2ibabur/3VYwOQ3RcFQHPFx1IJpRYYLuTW1vdQuWiQpt3spTdNTq8T7GS8864UMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963697; c=relaxed/simple;
	bh=VwQTZor4UEVuO51Lt0nVD1NnOhi5/vX0Ck4dJglq10Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pWc19F8ei4sBbtwVFaU84bYWJqv9KnE0G/7kkkH61rjy+uVGHcmLh14UL7+/jg25JmwT/g5GPYWpLjPuWin0+HEjduHII/EFA0pUOdfIWgVwSxuwaOJ/WkuL29m0fQivWPAJWKXLaO1Y3uXZZt9Q8rzPk/exRnYqYPJ21QXNylE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vu/f+XjJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vu/f+XjJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8818C4CEC3;
	Tue, 10 Sep 2024 10:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963697;
	bh=VwQTZor4UEVuO51Lt0nVD1NnOhi5/vX0Ck4dJglq10Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vu/f+XjJx9vXM8kqkeQmjeldniTT7uzmT/2miuRL0UlzNrqsO8lAae9jMbSgl05ZG
	 islxwKDC0dhKDT62eLdsgPWKF9ORnNYi7Zh1temP/FxlnIzo8AQzvCiy1chjOfp9yK
	 iCPgUqxGTHQ0/vVbkq36SsGAdITfPFQGpklv0yOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jules Irenge <jbi.octave@gmail.com>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 118/214] pcmcia: Use resource_size function on resource object
Date: Tue, 10 Sep 2024 11:32:20 +0200
Message-ID: <20240910092603.609822746@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



