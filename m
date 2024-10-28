Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D154418EFEB;
	Mon, 28 Oct 2024 06:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098251; cv=none; b=jP005ejFkMRLFYdvCoThJJBmxkWS9e9VYaIwg2Iue4gXSRGJLfY6Xt94aaMgfHAYcN4OPOwOdAo8z4NAUeN2k8pN2Xoo+m0u/JbrIiS10JjHjfE8gWjSk78A2TfoHWxbDQG0YS58990LAemu9/NXQEDEMLWDlvMqe5i7g0CAujM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098251; c=relaxed/simple;
	bh=1Oie/kzVbXHtEDXHaZGLeevzTIJwsWWma02i9FQvjC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P8vVrIwUCkPFusxMdmdSD0bj0UG9yAKp4p5UgqRqhMHs3FowEYE/2TFxlbP0b5gbpQyE4dHDvmOG8d9nWdp8uxMy/iNLgIuQMiKXCQ/Z2/IC02MB1PHKp+I3Y2h4sy1bL4EkERwITNdV5kC+wfZzp8zOz8AI9MhlHhjSekjS6No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cy5HKxhq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cy5HKxhq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72DE6C4CEC3;
	Mon, 28 Oct 2024 06:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098251;
	bh=1Oie/kzVbXHtEDXHaZGLeevzTIJwsWWma02i9FQvjC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cy5HKxhqZ3Y6tNQq+Ak6kBt++k+E09XCInLDXsEOwxKA8S+LLjkueeSxIZHudmIjX
	 MWQoyxOrtVRvH5pWzSMLJ2ZKYloujdJ5guL10TzrKnF1WpvdLHdgSWEvAeU+uj2hBB
	 GKfbkBMWGbrSiiH1epZMTVpAQDBjrPjiNf3vfx7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kory Maincent <kory.maincent@bootlin.com>,
	Simon Horman <horms@kernel.org>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Andrew Lunn <andrew@lunn.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 145/261] net: pse-pd: Fix out of bound for loop
Date: Mon, 28 Oct 2024 07:24:47 +0100
Message-ID: <20241028062315.678055234@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kory Maincent <kory.maincent@bootlin.com>

[ Upstream commit f2767a41959e60763949c73ee180e40c686e807e ]

Adjust the loop limit to prevent out-of-bounds access when iterating over
PI structures. The loop should not reach the index pcdev->nr_lines since
we allocate exactly pcdev->nr_lines number of PI structures. This fix
ensures proper bounds are maintained during iterations.

Fixes: 9be9567a7c59 ("net: pse-pd: Add support for PSE PIs")
Signed-off-by: Kory Maincent <kory.maincent@bootlin.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Message-ID: <20241015130255.125508-1-kory.maincent@bootlin.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/pse-pd/pse_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/pse-pd/pse_core.c b/drivers/net/pse-pd/pse_core.c
index f8e6854781e6e..2906ce173f66c 100644
--- a/drivers/net/pse-pd/pse_core.c
+++ b/drivers/net/pse-pd/pse_core.c
@@ -113,7 +113,7 @@ static void pse_release_pis(struct pse_controller_dev *pcdev)
 {
 	int i;
 
-	for (i = 0; i <= pcdev->nr_lines; i++) {
+	for (i = 0; i < pcdev->nr_lines; i++) {
 		of_node_put(pcdev->pi[i].pairset[0].np);
 		of_node_put(pcdev->pi[i].pairset[1].np);
 		of_node_put(pcdev->pi[i].np);
@@ -647,7 +647,7 @@ static int of_pse_match_pi(struct pse_controller_dev *pcdev,
 {
 	int i;
 
-	for (i = 0; i <= pcdev->nr_lines; i++) {
+	for (i = 0; i < pcdev->nr_lines; i++) {
 		if (pcdev->pi[i].np == np)
 			return i;
 	}
-- 
2.43.0



