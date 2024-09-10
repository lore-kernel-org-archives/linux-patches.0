Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5941F18C340;
	Tue, 10 Sep 2024 10:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962496; cv=none; b=qK4+67u0XgtGTPy3gcEOmTMk2qVt+L2RcnRAWXoeUQ/ql2NA4h7jiSsFr6ig9iQFAg+6jtDZqFhq0xv3vDqsBaFOoIfu+xEAXDSMW+HG5dYAp4/9LA8t4yBGQ9HRiPZGZD8JelSmQscYxejVShqDTb25Uri/Uh3d+nr/s70tQ/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962496; c=relaxed/simple;
	bh=3XW8U4pzn8dr3qMSdfFXOBcA0ud8uepUQdekkutipDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=daEHV3Ijc3yHjCRaMzxhS3a9XyRy53laEw1/s401fSSrCSxtzg1V4QPxhb8iN7dmP7rJEmXtWZlCUJWi6UDBGBh9mZiHDFHZDzTqSlbJYmVYAK/OJ2HhR4kJwNN7JOr7goi+aWB6NvFNt5oFOanP1QjU0WmsuSGPCcq0AEokvOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ly8fAZCz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ly8fAZCz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7090C4CEC3;
	Tue, 10 Sep 2024 10:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962496;
	bh=3XW8U4pzn8dr3qMSdfFXOBcA0ud8uepUQdekkutipDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ly8fAZCzA07o6z+ak/OPwjUt7IfEre2RJuu7+LyLq23Jv63e0zh2RDVm05eR3Psko
	 CB8B9fWnUtuhyWExmm89eIrlaCMgYXErx/td5pGrx+z0g6B3GyoD+7gVkQom/r0ZtZ
	 nJaXN5GO5EBh+l/BwRKHT1uC0skhmjPMz3WvRJX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jules Irenge <jbi.octave@gmail.com>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 053/121] pcmcia: Use resource_size function on resource object
Date: Tue, 10 Sep 2024 11:32:08 +0200
Message-ID: <20240910092548.305987341@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 810761ab8e9d..ba82ccb40db7 100644
--- a/drivers/pcmcia/yenta_socket.c
+++ b/drivers/pcmcia/yenta_socket.c
@@ -637,11 +637,11 @@ static int yenta_search_one_res(struct resource *root, struct resource *res,
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



