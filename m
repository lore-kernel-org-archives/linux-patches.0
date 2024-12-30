Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51BB15E8B;
	Mon, 30 Dec 2024 15:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574313; cv=none; b=NPZqiftQARTRLci4LW+7WAaLIrGaBXudm0IwwG+jh6/urFg4sTcZ8SV0sxYNAN0fpmebu2vAqnp7tsmSRy6g1jhfonoMnZKss7rsL7Ckyzjr5DfPc5uov5KFCIfe/fhI7HbWLjfr44r5ZHHg11TNPpLanNduguDO3oUhq8Kht0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574313; c=relaxed/simple;
	bh=1dFCWzORWHWPFKb3+WMe3G+hW81+AyPj+sCoN2JoT44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NUQgQHCUkJtC4XKUpP2uzrYnPifbYfFkHF4ArtSNjmrP/r8XTfBKzx9VXh2Oe/1Y4iaCikFkFf5hnjgfEi/oo7hN+uoNhdwIBuyfSTDjRGvUF8XrbOrJq9b6VeMXa+1N+oLZUx5bbrzlLy/6vcEfmwqMdydfPaHGTarioOOrYm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fEH3Rrb/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fEH3Rrb/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 179DAC4CED0;
	Mon, 30 Dec 2024 15:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574313;
	bh=1dFCWzORWHWPFKb3+WMe3G+hW81+AyPj+sCoN2JoT44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fEH3Rrb/9/RjBdOXrUD1ESs+FNmXD9Jf8HFZCzPnklEWSlLc4aMuzSLiBFVqvQvt2
	 /IXeC2vqQBwqkFd5aLUCM3rIB3BJqYZLYG2uaOuzO/EZ2IEWYL5bOKg+l2F5qX4tsP
	 6rjYm/6CyRrLzlgyieRNWIi48ijWCo6CMpSgC/P8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dimitri Fedrau <dimitri.fedrau@liebherr.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.12 100/114] power: supply: gpio-charger: Fix set charge current limits
Date: Mon, 30 Dec 2024 16:43:37 +0100
Message-ID: <20241230154221.963161410@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dimitri Fedrau <dimitri.fedrau@liebherr.com>

commit afc6e39e824ad0e44b2af50a97885caec8d213d1 upstream.

Fix set charge current limits for devices which allow to set the lowest
charge current limit to be greater zero. If requested charge current limit
is below lowest limit, the index equals current_limit_map_size which leads
to accessing memory beyond allocated memory.

Fixes: be2919d8355e ("power: supply: gpio-charger: add charge-current-limit feature")
Cc: stable@vger.kernel.org
Signed-off-by: Dimitri Fedrau <dimitri.fedrau@liebherr.com>
Link: https://lore.kernel.org/r/20241209-fix-charge-current-limit-v1-1-760d9b8f2af3@liebherr.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/gpio-charger.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/power/supply/gpio-charger.c
+++ b/drivers/power/supply/gpio-charger.c
@@ -67,6 +67,14 @@ static int set_charge_current_limit(stru
 		if (gpio_charger->current_limit_map[i].limit_ua <= val)
 			break;
 	}
+
+	/*
+	 * If a valid charge current limit isn't found, default to smallest
+	 * current limitation for safety reasons.
+	 */
+	if (i >= gpio_charger->current_limit_map_size)
+		i = gpio_charger->current_limit_map_size - 1;
+
 	mapping = gpio_charger->current_limit_map[i];
 
 	for (i = 0; i < ndescs; i++) {


