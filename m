Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADDB2190685;
	Mon, 24 Feb 2025 15:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409232; cv=none; b=CdgDcE9DmnzjPIHVM5pjwDb132EWSmz7twG/U7fD+hMbCQxAFEB1PlnH1oaj9VwMGZO/ZTSC1bt8XxBcW3Sflxc7M2qpE7G2Clq3Unn8IUY7vgSoY20I2aGEjkFZ4Igjs9iGuKItFSO2kiwnQcaU4NS6K/jBJd2iHU3A7PBytgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409232; c=relaxed/simple;
	bh=G9s9vN6YGak1wag70F0KFKJVl56ueF1k5iIuzZHy26U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TOTKYCWQIHo0XxgBBkgWIYOvRpDTCS+AbWjoxwVOY1hhWLxyLk3gYM59qlUsX4DKxFYlbEBYBxqNSEeNJCydMXTy2kSc3FLdgknFst85gnYklz7SqX9b6sej4ssBhZ+QN0Atzvb1rGMk7QhJc3MwKdUMggkPkY6uhFDR11ZKYqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rUqsiQVR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rUqsiQVR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31EE4C4CEE6;
	Mon, 24 Feb 2025 15:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740409232;
	bh=G9s9vN6YGak1wag70F0KFKJVl56ueF1k5iIuzZHy26U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rUqsiQVR2URDyGLUthqMXR0NnHuFgfYTWxLXZ6q0n+0sjTxTfpf4eGbeSmLMcoVx0
	 fo2unrAYhTRJ5sBCi3FmoVnsIeI6LtaKUEi2VDM/PRjp501QyWN6YQG5ia9yTlKU+n
	 +FyFgKKETxc2pUNurTOB0Sx48fe7zMXBqZ73Dieo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kory Maincent <kory.maincent@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.13 136/138] net: pse-pd: Fix deadlock in current limit functions
Date: Mon, 24 Feb 2025 15:36:06 +0100
Message-ID: <20250224142609.815037544@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kory Maincent <kory.maincent@bootlin.com>

commit 488fb6effe03e20f38d34da7425de77bbd3e2665 upstream.

Fix a deadlock in pse_pi_get_current_limit and pse_pi_set_current_limit
caused by consecutive mutex_lock calls. One in the function itself and
another in pse_pi_get_voltage.

Resolve the issue by using the unlocked version of pse_pi_get_voltage
instead.

Fixes: e0a5e2bba38a ("net: pse-pd: Use power limit at driver side instead of current limit")
Signed-off-by: Kory Maincent <kory.maincent@bootlin.com>
Link: https://patch.msgid.link/20250212151751.1515008-1-kory.maincent@bootlin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/pse-pd/pse_core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/pse-pd/pse_core.c
+++ b/drivers/net/pse-pd/pse_core.c
@@ -309,7 +309,7 @@ static int pse_pi_get_current_limit(stru
 		goto out;
 	mW = ret;
 
-	ret = pse_pi_get_voltage(rdev);
+	ret = _pse_pi_get_voltage(rdev);
 	if (!ret) {
 		dev_err(pcdev->dev, "Voltage null\n");
 		ret = -ERANGE;
@@ -346,7 +346,7 @@ static int pse_pi_set_current_limit(stru
 
 	id = rdev_get_id(rdev);
 	mutex_lock(&pcdev->lock);
-	ret = pse_pi_get_voltage(rdev);
+	ret = _pse_pi_get_voltage(rdev);
 	if (!ret) {
 		dev_err(pcdev->dev, "Voltage null\n");
 		ret = -ERANGE;


