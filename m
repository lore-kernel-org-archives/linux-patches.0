Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C4518FC8F;
	Wed,  3 Jul 2024 11:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005880; cv=none; b=deHmJfQXx36BlVgvegMVYWxdPSsguqcD+LikXU/nF0zYRLzIRmnFg0Jw7r2HblVmoBtDAD9Mu1jGHTQvv2P0mYkHuXbf1xmzhXwmz1VRu8AyZ1ceHv2T+3sXly+4e8gjriarZ1xE4AvqDKXPnhjhL6GWnnVkRjg6GP34f0LHSvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005880; c=relaxed/simple;
	bh=SADyX61874o3SQgdW/MTBr9oQ53w2fMhFyLF8WchG5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ujv0QLSdHO4ajbEa1NGaRkIOFiGjrGGqTN/CaQdkZKwweaCW+aG0p8caV/Hr7xwLN77tAhZF8ALzm872b+LA7cQDjrKlaE0qEBoTAJj7fnY//no5Qmh7gNw6ViQMZxFwQgOVXSfWxncYvQdIuNPPznO8DZ+rv1hXpMO7EzcGwi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lsMCJ3ac; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lsMCJ3ac"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C152C2BD10;
	Wed,  3 Jul 2024 11:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005880;
	bh=SADyX61874o3SQgdW/MTBr9oQ53w2fMhFyLF8WchG5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lsMCJ3acsOWyRg0eX5qw1GYXCUwzUTdwxgCiJ28ihGxqsOfAXZJ1u/O6kyaPpuc4c
	 /iGkvwvX3w0pvWcJJW5XbhXDjSmIovypFdRXGoGx5C3fBB86iOh/BodMhoe+3M36td
	 HKO6CAq3n+XKQB/KyuVeE7wOZuHohChifOtwRJA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Grygorii Tertychnyi <grygorii.tertychnyi@leica-geosystems.com>,
	Peter Korsgaard <peter@korsgaard.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 5.15 228/356] i2c: ocores: set IACK bit after core is enabled
Date: Wed,  3 Jul 2024 12:39:24 +0200
Message-ID: <20240703102921.738941752@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

From: Grygorii Tertychnyi <grembeter@gmail.com>

commit 5a72477273066b5b357801ab2d315ef14949d402 upstream.

Setting IACK bit when core is disabled does not clear the "Interrupt Flag"
bit in the status register, and the interrupt remains pending.

Sometimes it causes failure for the very first message transfer, that is
usually a device probe.

Hence, set IACK bit after core is enabled to clear pending interrupt.

Fixes: 18f98b1e3147 ("[PATCH] i2c: New bus driver for the OpenCores I2C controller")
Signed-off-by: Grygorii Tertychnyi <grygorii.tertychnyi@leica-geosystems.com>
Acked-by: Peter Korsgaard <peter@korsgaard.com>
Cc: stable@vger.kernel.org
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-ocores.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-ocores.c
+++ b/drivers/i2c/busses/i2c-ocores.c
@@ -442,8 +442,8 @@ static int ocores_init(struct device *de
 	oc_setreg(i2c, OCI2C_PREHIGH, prescale >> 8);
 
 	/* Init the device */
-	oc_setreg(i2c, OCI2C_CMD, OCI2C_CMD_IACK);
 	oc_setreg(i2c, OCI2C_CONTROL, ctrl | OCI2C_CTRL_EN);
+	oc_setreg(i2c, OCI2C_CMD, OCI2C_CMD_IACK);
 
 	return 0;
 }


