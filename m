Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FDB382495;
	Wed, 19 Jun 2024 13:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803344; cv=none; b=OsvvtkrhzdZVbwlDIKXyg85ze70vmLsJ/XJhl9+BL3DVgbvxfihP0S8t1/eZDiNgqKki+aEfE4iwO4GlN5QmPU0KA3VsL3teKxrAb+sNLH0eAdnykVvAkfs1kYSAtqGdKWVTcPKsKcHtQTCW3oUw+GKtBzBqY0HKtaDPRqwE9Tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803344; c=relaxed/simple;
	bh=V27GcatRuOtzbQOpXqezeAV+CPKueo2ESzT0esBc/+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Deq0/F21+U57DqY9B/ILgcKqswea4pZyB9vTv+j21vk/AvCt7TFUdpt0i3AlKSSOWVlWXR/Rd4gIGzzEVBIBRN8V0r8tL6XqxumXO57QjsZSv45TmlU5SDtJcMOxAtFKdVelX1vVCp+h/M/ImiTwwPiAhKLS1gKBX3UzaCftU/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EAyUxBj9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EAyUxBj9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF185C2BBFC;
	Wed, 19 Jun 2024 13:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803344;
	bh=V27GcatRuOtzbQOpXqezeAV+CPKueo2ESzT0esBc/+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EAyUxBj9aNuLEoTW8GEoQvlal0RdsOLnWSw3LArBmq8afqsmTksuXvwdwT1CiMZ3e
	 6pvdfSDDTr0/mUP1JYEw808PhzgNidhIvvBT5ZF+n4qLNWpuzuGjGON9Dl3lCcNP6B
	 qrkkr7OJ/bV4S1CoZQ9WDPg2BQSY9nt7qU1eaxcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vamshi Gajjela <vamshigajjela@google.com>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 6.9 235/281] spmi: hisi-spmi-controller: Do not override device identifier
Date: Wed, 19 Jun 2024 14:56:34 +0200
Message-ID: <20240619125619.004051042@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vamshi Gajjela <vamshigajjela@google.com>

commit eda4923d78d634482227c0b189d9b7ca18824146 upstream.

'nr' member of struct spmi_controller, which serves as an identifier
for the controller/bus. This value is a dynamic ID assigned in
spmi_controller_alloc, and overriding it from the driver results in an
ida_free error "ida_free called for id=xx which is not allocated".

Signed-off-by: Vamshi Gajjela <vamshigajjela@google.com>
Fixes: 70f59c90c819 ("staging: spmi: add Hikey 970 SPMI controller driver")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240228185116.1269-1-vamshigajjela@google.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Link: https://lore.kernel.org/r/20240507210809.3479953-5-sboyd@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spmi/hisi-spmi-controller.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/spmi/hisi-spmi-controller.c
+++ b/drivers/spmi/hisi-spmi-controller.c
@@ -300,7 +300,6 @@ static int spmi_controller_probe(struct
 
 	spin_lock_init(&spmi_controller->lock);
 
-	ctrl->nr = spmi_controller->channel;
 	ctrl->dev.parent = pdev->dev.parent;
 	ctrl->dev.of_node = of_node_get(pdev->dev.of_node);
 


