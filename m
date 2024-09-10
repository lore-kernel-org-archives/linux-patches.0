Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED96417BEAD;
	Tue, 10 Sep 2024 10:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964256; cv=none; b=NncGPRUThu+S4ZQjPXyPe5WJI2/rNutSuQ3iap2To4p578Fsb1FuL24LaoIdA/wGBpq2JoUszRjzj41iEiCqn0s/n2zrHVPY2EEyB4Vla4ORdzshcs0JswoiABLw5mH/lWvHC3wD/wuN58Y3BLbJtn+sNkJsWeINDOHRwEBUupQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964256; c=relaxed/simple;
	bh=19L8JuHsOlvMHTqOCalNPn0fdQV0KCZ0c+ThuTRuqT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fmco/+TJ0JK7oseSinZDzHd6ilmYtnzbFEBfnuEyjekMyi/7YjB9vVSbxS3S4/K+KxG1eSvqhRS8ad9cvd6OBVOOwC19zInsc251QccJboUBUUI+OsArIzcVxeMuMzMV/RVHKj7VYhAOAPARPFVzYB/5RIfm5OeHuDTvM/WLjzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oMGlltr8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oMGlltr8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69ED3C4CEC3;
	Tue, 10 Sep 2024 10:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964255;
	bh=19L8JuHsOlvMHTqOCalNPn0fdQV0KCZ0c+ThuTRuqT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oMGlltr8w2+PuOgTQid2LUOLfWkOQ+NuQU2JwT4RvGw6VNH96JC/bBIDp7OgjVrV6
	 oVyXjTgj+mjmlzwbPnRHQ+aXmX2Jx3ACJI+UWF6aF3bBtCnTSVo8ksFUlg70t4oY/d
	 E+gxPvu4yuOjzM8W7rgYoMXB4PW+cNmyz8ZdhqAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jules Irenge <jbi.octave@gmail.com>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 093/269] pcmcia: Use resource_size function on resource object
Date: Tue, 10 Sep 2024 11:31:20 +0200
Message-ID: <20240910092611.530162446@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



