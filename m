Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E465C389104;
	Tue, 13 Oct 2026 11:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892486; cv=none; b=Gx5yLUMXbtGWbkgWmCSJJNptx9SUdSasUj3Jk0dOv9DrrcACDjlfDKmECMCCLvDB0UQMUqNrBQ5T2ZqDfEujo8ntLgJtgDk7kC1Ev8AAO9NHr9CZmkDqNe1Sag+ISPzNw9uLuFn+gMM92/umQk76T4H8rSSrdtWCi51K4A2ine4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892486; c=relaxed/simple;
	bh=WDPfADuhVYkW/OJnODZsL6H4X8QSiUmW0h2g8atuaLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C3hvzhLDeItiWXFRBUiwbHEH/sUWVEvuv/0LlhkJX6KLfQpml6+HbybPlUMfywCagq90IfeQceV1iLD9PJOEAjrju1oeZFZ1kedzuTqBMJz7s7wPPSf8y2lIqb1zBqfPrTr1KD0XJG7JVduDPtvd3S1YxXvGOyMwAbIl66N0OQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o0Mv0YNE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o0Mv0YNE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 393801F000FF;
	Tue, 13 Oct 2026 11:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892485;
	bh=6X2o8+IypYjx1NlIqNRXxTlZ1pnZs3hGrnAXvN+guD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o0Mv0YNEo9Tstz1jbb8YKXU2AgNrHvseRh1JajGuRGFPXcGXaKMDKURdCaCu8yiVL
	 oc+O5QcsLDekHhpEaWW8WdziT+xlWQhEWQLDdcxO2nEMp1rHNR6kNcANm1/A0Cq5bF
	 bNl25yX/8o3182P5rFMa9oJ2fLb8sryXhGMxWjAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	=?UTF-8?q?Robin=20R=C3=A4ber?= <robin.raebi@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	Igor Paunovic <royalnet026@gmail.com>
Subject: [PATCH 7.2 189/281] drm/bridge: Fix unlocked list_del in drm_bridge_add()
Date: Tue, 13 Oct 2026 13:38:25 +0200
Message-ID: <20261013112859.750614362@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit b62e3db8cdc1680e1c3390591e872f485148541a ]

When re-adding a bridge that was previously removed, drm_bridge_add()
drops it from bridge_lingering_list without holding bridge_lock.

Both bridge_list and bridge_lingering_list are protected by bridge_lock,
as they are concurrently modified by drm_bridge_remove() and
__drm_bridge_free(), and walked by the debugfs 'bridges' file.  Running
the list_empty() test and the list_del_init() outside of the lock may
therefore corrupt either list.

Perform both under bridge_lock.

Fixes: 17805a15d175 ("drm/bridge: add list of removed refcounted bridges")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260723015004.1F5711F000E9@smtp.kernel.org/
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Tested-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Tested-by: Igor Paunovic <royalnet026@gmail.com> # RK3588 Orange Pi 5 Plus, dual HDMI
Tested-by: Robin Räber <robin.raebi@gmail.com>
Link: https://patch.msgid.link/20260901-dw-hdmi-qp-scramb-v11-12-bc12954a0688@collabora.com
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_bridge.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/drm_bridge.c b/drivers/gpu/drm/drm_bridge.c
index 687b36eea0c70..3618cb12483e2 100644
--- a/drivers/gpu/drm/drm_bridge.c
+++ b/drivers/gpu/drm/drm_bridge.c
@@ -414,8 +414,10 @@ void drm_bridge_add(struct drm_bridge *bridge)
 	 * in bridge_lingering_list. Remove it or bridge_lingering_list will be
 	 * corrupted when adding this bridge to bridge_list below.
 	 */
+	mutex_lock(&bridge_lock);
 	if (!list_empty(&bridge->list))
 		list_del_init(&bridge->list);
+	mutex_unlock(&bridge_lock);
 
 	mutex_init(&bridge->hpd_mutex);
 
-- 
2.53.0



