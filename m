Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22BC31AF15;
	Mon, 18 Aug 2025 12:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521932; cv=none; b=nS5GVYAVq+IpCHUBMB8Qkb29qAJjLt00BKffudS7CuBflL7viwxjiAkdVC2EhYM/qrt9VQQq/7k6/eiNmQGkkoNtj+PA2SJWhciNLwVYGhUTOZuXoI7wQ5OQ+usumD3WOELpYK67RYb5NaKPGlumLK4tp+ccjRBSbQ1jyXS02CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521932; c=relaxed/simple;
	bh=N4TSuidTkhTKye5xphq6GjqOyfl718hWHZQkyAtiVOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OwNmLeKdF6tn9eKjcgqqs8vdXePWmNlrRWXPL7sSrY7vRKYSQQ1u7935amCf+moORts00GQwt1PZt7PZlipOyeG8FMzpG97t4aMAc9oKvgwjYOOdZmvI9VwBrxFKI24TVOQyOhWgJXgvjyiZ1s3MNxG7So0kcn7vq+vmveTP78U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VOMzVBdF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VOMzVBdF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F68BC4CEEB;
	Mon, 18 Aug 2025 12:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521932;
	bh=N4TSuidTkhTKye5xphq6GjqOyfl718hWHZQkyAtiVOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VOMzVBdFRbDbi+Nj6nxNWLmXKrnFz0AH7q9zqyC7GlWDT21IF59lkbjSmY07qQKSA
	 2misYypf+tp1r6QaJUB/R4J/O0SnMNmWYOlc6Nc0eha3qoVw54fIwN4UBYPernKx01
	 hY4szCY4+j8Ivi5VvPyKsjVdFJmKND4GSPa03jh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomasz Michalec <tmichalec@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 148/444] usb: typec: intel_pmc_mux: Defer probe if SCU IPC isnt present
Date: Mon, 18 Aug 2025 14:42:54 +0200
Message-ID: <20250818124454.460534571@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

From: Tomasz Michalec <tmichalec@google.com>

[ Upstream commit df9a825f330e76c72d1985bc9bdc4b8981e3d15f ]

If pmc_usb_probe is called before SCU IPC is registered, pmc_usb_probe
will fail.

Return -EPROBE_DEFER when pmc_usb_probe doesn't get SCU IPC device, so
the probe function can be called again after SCU IPC is initialized.

Signed-off-by: Tomasz Michalec <tmichalec@google.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20250610154058.1859812-1-tmichalec@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/mux/intel_pmc_mux.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/typec/mux/intel_pmc_mux.c b/drivers/usb/typec/mux/intel_pmc_mux.c
index 46b4c5c3a6be..32343f567d44 100644
--- a/drivers/usb/typec/mux/intel_pmc_mux.c
+++ b/drivers/usb/typec/mux/intel_pmc_mux.c
@@ -754,7 +754,7 @@ static int pmc_usb_probe(struct platform_device *pdev)
 
 	pmc->ipc = devm_intel_scu_ipc_dev_get(&pdev->dev);
 	if (!pmc->ipc)
-		return -ENODEV;
+		return -EPROBE_DEFER;
 
 	pmc->dev = &pdev->dev;
 
-- 
2.39.5



