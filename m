Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEBB64315A;
	Sun,  7 Sep 2025 20:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277458; cv=none; b=o9hIsRbgHgBWh9fKXkSDO0FqQaFO30AU+EjO17BM2+ZG98aCQcD9vLTe6gsm8s6mJo8v3zuKPdXrYjcoog4NpXiTDosWKnLyavDXiRyhlxJwNPhXgDPObq0G5zTYEmYHEbQTuiXgpv/X1WV6++AGkUsP+FDWjwAzwy2rD1e4LS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277458; c=relaxed/simple;
	bh=vAfsfHB6CxO6GJbx1c0jaBNQjtT2hNkALQpCr2Ilayo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ee78Lel9R2hUn4EXytnG3wx52s3Lc3yp0XhHbmjlVJa8BnqAdNAKi+1xVAdAibSLmE21adU5xN9qoNJQdxOFtSBB/fVF24pYsrL0hQ2ORlLWeMkZHbNoKJZXwNq4qY5B3y8TGjkfhROgNVujNaAM1WAuHWhXZ7ALqZK/QHih6To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NQ7ZjG/C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NQ7ZjG/C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50908C4CEF0;
	Sun,  7 Sep 2025 20:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277458;
	bh=vAfsfHB6CxO6GJbx1c0jaBNQjtT2hNkALQpCr2Ilayo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NQ7ZjG/CpmcqNw2EcJSypUSVskjRgLHrnxEGVJ/R6Ft9fk/ceHObuwIF7I7Vz228L
	 NfjYfA0EV0EyXaqv7Mo7o1xloyZDK8y5YWRwg2+56JBKRJAESQXPoe4pyo2ZZHoISS
	 CzONKQFFQ0LMJqcMiSlZguelTJD6uDzLQBqh2TS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?J . =20Neusch=C3=A4fer?=" <j.ne@posteo.net>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	=?UTF-8?q?Ond=C5=99ej=20Jirman?= <megi@xff.cz>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 004/183] ASoC: soc-core: care NULL dirver name on snd_soc_lookup_component_nolocked()
Date: Sun,  7 Sep 2025 21:57:11 +0200
Message-ID: <20250907195615.906978729@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit 168873ca1799d3f23442b9e79eae55f907b9b126 ]

soc-generic-dmaengine-pcm.c uses same dev for both CPU and Platform.
In such case, CPU component driver might not have driver->name, then
snd_soc_lookup_component_nolocked() will be NULL pointer access error.
Care NULL driver name.

	Call trace:
	 strcmp from snd_soc_lookup_component_nolocked+0x64/0xa4
	 snd_soc_lookup_component_nolocked from snd_soc_unregister_component_by_driver+0x2c/0x44
	 snd_soc_unregister_component_by_driver from snd_dmaengine_pcm_unregister+0x28/0x64
	 snd_dmaengine_pcm_unregister from devres_release_all+0x98/0xfc
	 devres_release_all from device_unbind_cleanup+0xc/0x60
	 device_unbind_cleanup from really_probe+0x220/0x2c8
	 really_probe from __driver_probe_device+0x88/0x1a0
	 __driver_probe_device from driver_probe_device+0x30/0x110
	driver_probe_device from __driver_attach+0x90/0x178
	__driver_attach from bus_for_each_dev+0x7c/0xcc
	bus_for_each_dev from bus_add_driver+0xcc/0x1ec
	bus_add_driver from driver_register+0x80/0x11c
	driver_register from do_one_initcall+0x58/0x23c
	do_one_initcall from kernel_init_freeable+0x198/0x1f4
	kernel_init_freeable from kernel_init+0x1c/0x12c
	kernel_init from ret_from_fork+0x14/0x28

Fixes: 144d6dfc7482 ("ASoC: soc-core: merge snd_soc_unregister_component() and snd_soc_unregister_component_by_driver()")
Reported-by: J. Neuschäfer <j.ne@posteo.net>
Closes: https://lore.kernel.org/r/aJb311bMDc9x-dpW@probook
Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Reported-by: Ondřej Jirman <megi@xff.cz>
Closes: https://lore.kernel.org/r/arxpwzu6nzgjxvsndct65ww2wz4aezb5gjdzlgr24gfx7xvyih@natjg6dg2pj6
Tested-by: J. Neuschäfer <j.ne@posteo.net>
Message-ID: <87ect8ysv8.wl-kuninori.morimoto.gx@renesas.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index 16bbc074dc5f6..d31ee6e9abefc 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -375,8 +375,9 @@ struct snd_soc_component
 	for_each_component(component) {
 		if ((dev == component->dev) &&
 		    (!driver_name ||
-		     (driver_name == component->driver->name) ||
-		     (strcmp(component->driver->name, driver_name) == 0))) {
+		     (component->driver->name &&
+		      ((component->driver->name == driver_name) ||
+		       (strcmp(component->driver->name, driver_name) == 0))))) {
 			found_component = component;
 			break;
 		}
-- 
2.50.1



