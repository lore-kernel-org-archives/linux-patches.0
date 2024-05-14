Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CD2B1386C2;
	Tue, 14 May 2024 11:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686996; cv=none; b=JCHVy+mwmMKWY/UNOLB3VuH2FB1ta/vc6u3WeyflrPe8N2HodEUTxE0EcvYJdq5SSuoaLlZq7wuwYB8/4x54YY6ymGrkfCekLTzlYUvXhHrUDGnfV6dibMPc6dg1Yaov2JpnXRprJc/rPH04/AITs/wE2LA4RktXrJ2KJhyij14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686996; c=relaxed/simple;
	bh=FYK9EKKQEQ488HHYb+8mUzDHZ8k6hn6tt94QxGl2GqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qM4DCtivVWskcAMyHcwdygabZnSstsFEtoaJvVQM4eVNwgX1rjlnnK/1N3TDeBbhtBjaY2jAsPkAkDQ1YYFWytYbR0nmIKZubyfiqND0TQAn2Cd6BL6zTxa0qWYEvvcYQnVwo/0Cy90kklb1g9AcS3hbOo3jPFaY80ElKzYfFSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zEobRVB4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zEobRVB4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8481BC32782;
	Tue, 14 May 2024 11:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686995;
	bh=FYK9EKKQEQ488HHYb+8mUzDHZ8k6hn6tt94QxGl2GqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zEobRVB4uRsMW4aR6wuscdPeLywMfWgrRzal646wKr1igwbiCGwEMdaF0MWTYWNYw
	 8SoPwO9rqJ7mp/0joFaLpnwA/N4ZefprmINShfVecuzZFL+6TSrLOTpui0Q5bozElO
	 TkIkT/rbG4w1f8DU0TsHIHgmvlNXsPnhJFJXkM3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 04/84] pinctrl: core: delete incorrect free in pinctrl_enable()
Date: Tue, 14 May 2024 12:19:15 +0200
Message-ID: <20240514100951.856881170@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100951.686412426@linuxfoundation.org>
References: <20240514100951.686412426@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 5038a66dad0199de60e5671603ea6623eb9e5c79 ]

The "pctldev" struct is allocated in devm_pinctrl_register_and_init().
It's a devm_ managed pointer that is freed by devm_pinctrl_dev_release(),
so freeing it in pinctrl_enable() will lead to a double free.

The devm_pinctrl_dev_release() function frees the pindescs and destroys
the mutex as well.

Fixes: 6118714275f0 ("pinctrl: core: Fix pinctrl_register_and_init() with pinctrl_enable()")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Message-ID: <578fbe56-44e9-487c-ae95-29b695650f7c@moroto.mountain>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/core.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index a1c2dc304fb10..3947b7064bead 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -2053,13 +2053,7 @@ int pinctrl_enable(struct pinctrl_dev *pctldev)
 
 	error = pinctrl_claim_hogs(pctldev);
 	if (error) {
-		dev_err(pctldev->dev, "could not claim hogs: %i\n",
-			error);
-		pinctrl_free_pindescs(pctldev, pctldev->desc->pins,
-				      pctldev->desc->npins);
-		mutex_destroy(&pctldev->mutex);
-		kfree(pctldev);
-
+		dev_err(pctldev->dev, "could not claim hogs: %i\n", error);
 		return error;
 	}
 
-- 
2.43.0



