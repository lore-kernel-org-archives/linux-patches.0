Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE1D3F9D2;
	Tue, 12 Aug 2025 18:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023062; cv=none; b=ak0Z5sg0Hj62YsStnW4bXQ93PdfC3Dd7ZsGzUNL940riqQEJ8oiU0z8UOc+fiLPErWY3FzbpE9CyJLOiqDgbmEx2h/xlv5TyREVBS03Ru26VUqk09xK2nMk3sULuEkXAt8ylfO3jABmS2x5zgfYL4J0t+ao5iFV+EYBW1VshcRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023062; c=relaxed/simple;
	bh=7fewWUUi+N4kS5awfbJyJKVZYRNr489XMg8Du9WeWf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=as03r2uD6FoOCy57b0aG6NH8/2FoTeV1DVtAV03CVZYI64nD6UFFBSrgU6Q4uWIuHXSVX2ZN6P57W5OdAoIejT8CbPaajaHY8T02pPIPELMgHFHVkD7HN7KO1/QBmULviSD1VDlBqxJahIu51lWVS9lEQQdGKLnyi6d8fqft8kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r5/wwuuz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r5/wwuuz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD6F3C4CEF1;
	Tue, 12 Aug 2025 18:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023062;
	bh=7fewWUUi+N4kS5awfbJyJKVZYRNr489XMg8Du9WeWf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r5/wwuuzlqOpjnzmQ2O4ylRu9nNB6NHk4P5nOZQrDoZosxdKBmij0S9XJPCgC4dea
	 KNThdIsjvH4ND0pZ2B2Ny2QFoaR8Qw186/iyCZ1XjTNzHAW+Sb3fuxNQChOlxhdWYN
	 59wvFIaCpjH98kDXVzKx1g/YMSPj5/far2YZxDLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Ville Syrjala <ville.syrjala@linux.intel.com>,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.12 338/369] drm/i915/ddi: gracefully handle errors from intel_ddi_init_hdmi_connector()
Date: Tue, 12 Aug 2025 19:30:35 +0200
Message-ID: <20250812173029.415065551@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

From: Jani Nikula <jani.nikula@intel.com>

commit 8ea07e294ea2d046e16fa98e37007edcd4b9525d upstream.

Errors from intel_ddi_init_hdmi_connector() can just mean "there's no
HDMI" while we'll still want to continue with DP only. Handle the errors
gracefully, but don't propagate. Clear the hdmi_reg which is used as a
proxy to indicate the HDMI is initialized.

v2: Gracefully handle but do not propagate

Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Ville Syrjala <ville.syrjala@linux.intel.com>
Reported-and-tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Closes: https://lore.kernel.org/r/20241031105145.2140590-1-senozhatsky@chromium.org
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org> # v1
Reviewed-by: Suraj Kandpal <suraj.kandpal@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/d72cb54ac7cc5ca29b3b9d70e4d368ea41643b08.1735568047.git.jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_ddi.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_ddi.c
+++ b/drivers/gpu/drm/i915/display/intel_ddi.c
@@ -4632,7 +4632,16 @@ static int intel_ddi_init_hdmi_connector
 		return -ENOMEM;
 
 	dig_port->hdmi.hdmi_reg = DDI_BUF_CTL(port);
-	intel_hdmi_init_connector(dig_port, connector);
+
+	if (!intel_hdmi_init_connector(dig_port, connector)) {
+		/*
+		 * HDMI connector init failures may just mean conflicting DDC
+		 * pins or not having enough lanes. Handle them gracefully, but
+		 * don't fail the entire DDI init.
+		 */
+		dig_port->hdmi.hdmi_reg = INVALID_MMIO_REG;
+		kfree(connector);
+	}
 
 	return 0;
 }


