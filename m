Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B900183CCA;
	Sun,  1 Sep 2024 16:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209105; cv=none; b=s4aQrX9Af0ptSOTcoiHuZOgTPQwiKdC57NG9wNUOQ0AZ1JktY94RyVTMWr5NeRkUctWezkrpgX/UqFxrcbtJkZtw5hLe2hloFiD6KRd8bgazEl9E/yawhN1sFWu36xjOsIG6Dr+6CtAhtNi5SVu6rIY8KTRB8TTrso/twc9E2wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209105; c=relaxed/simple;
	bh=rvyB60pX/FK6L1DGsRGLlvjeHQxz9zMV8QoPhYeZouU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IMVDI7yHaMMG6OD3a0PChbD9d0OCBiPC4Ae6AkOs3RpbH8gXH284u5zNXLQMZGyR/oJsKXFiQUCHHqmgmLrbkhU97E7rkwAH+IzJl1Fzu9h1E0fQZPzGWZ3zBixBugUYKVaCgBNsRfO0ubLzWNwLhJvn8G4SkyB4HFoup8cDGZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SJeZ3CdT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SJeZ3CdT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C876C4CEC3;
	Sun,  1 Sep 2024 16:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209105;
	bh=rvyB60pX/FK6L1DGsRGLlvjeHQxz9zMV8QoPhYeZouU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SJeZ3CdTguYHKki4lRJ3verhsrU0ltiwnajsO4VgE0mueos3OjMjtglJv1NXEzPoi
	 G90O5KNehD6pLVUCtvo/UXKch2mgw2wGeId+Un/eSaPdwmBSmJVfiaKlcPIJ6awUx0
	 d1NcZFqyqDY0WpMOd4IaF++PmOpioPP0J1EkLijs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 124/134] nfc: pn533: Add poll mod list filling check
Date: Sun,  1 Sep 2024 18:17:50 +0200
Message-ID: <20240901160814.746594437@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

From: Aleksandr Mishin <amishin@t-argos.ru>

[ Upstream commit febccb39255f9df35527b88c953b2e0deae50e53 ]

In case of im_protocols value is 1 and tm_protocols value is 0 this
combination successfully passes the check
'if (!im_protocols && !tm_protocols)' in the nfc_start_poll().
But then after pn533_poll_create_mod_list() call in pn533_start_poll()
poll mod list will remain empty and dev->poll_mod_count will remain 0
which lead to division by zero.

Normally no im protocol has value 1 in the mask, so this combination is
not expected by driver. But these protocol values actually come from
userspace via Netlink interface (NFC_CMD_START_POLL operation). So a
broken or malicious program may pass a message containing a "bad"
combination of protocol parameter values so that dev->poll_mod_count
is not incremented inside pn533_poll_create_mod_list(), thus leading
to division by zero.
Call trace looks like:
nfc_genl_start_poll()
  nfc_start_poll()
    ->start_poll()
    pn533_start_poll()

Add poll mod list filling check.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: dfccd0f58044 ("NFC: pn533: Add some polling entropy")
Signed-off-by: Aleksandr Mishin <amishin@t-argos.ru>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://patch.msgid.link/20240827084822.18785-1-amishin@t-argos.ru
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/pn533/pn533.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/nfc/pn533/pn533.c b/drivers/nfc/pn533/pn533.c
index 1c3da3675d7df..9610a9b1929f1 100644
--- a/drivers/nfc/pn533/pn533.c
+++ b/drivers/nfc/pn533/pn533.c
@@ -1751,6 +1751,11 @@ static int pn533_start_poll(struct nfc_dev *nfc_dev,
 	}
 
 	pn533_poll_create_mod_list(dev, im_protocols, tm_protocols);
+	if (!dev->poll_mod_count) {
+		nfc_err(dev->dev,
+			"Poll mod list is empty\n");
+		return -EINVAL;
+	}
 
 	/* Do not always start polling from the same modulation */
 	get_random_bytes(&rand_mod, sizeof(rand_mod));
-- 
2.43.0



