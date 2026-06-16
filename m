Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD1C632E728;
	Tue, 16 Jun 2026 17:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631251; cv=none; b=R1zA6mCf6mnXNnfi1ZtnWyLViQ6F2szspr4aXAmvYU16k51tqftbpEjEKJC/hnesENW0j8P65EDdAFuMkGq5Ly3UflYub9UHCdscNovBxpnxxnW30gDzZh+FbcssiEvUjhmW0azGGaAOgmIi55qrB68z8uoccXdXQKlR4OChOsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631251; c=relaxed/simple;
	bh=1SkdFKfAlCeGK1TrQocwYu3BVK1rqo2H1Pim8n+YrYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pxBE6XrrkUxKbmbTffB/fqI97y+qQTc33MJtMSXZKpZpq2qTtgtvNH98rridrOm/Q5KQLDgcHLHBu7dRP3dj/Z55qM8B4PIq2Q+foV0CQvDec/xu1Ccc+E9PiMkb+pGIuh6AsIE5EQ2MzA/7VwGmIHyzPrU1glUu8ObyKZ7IffM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CB7Q5RNr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CB7Q5RNr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0EF31F000E9;
	Tue, 16 Jun 2026 17:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631250;
	bh=aYuSC2ykn2oEAZjfrVl332FEc/qhisQjTX+eVxGeZSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CB7Q5RNrfscPSb49aVppOH2Mv6s9Ag0Z/GhIDVISSWzsFp/00XBTVJxc1E/0v6Nyt
	 aVst0f+dtsCWpi7qIXBrTz9s/elA3I1ESKqrLMvQJfRYlv/9vnlB7BkpYiobs4o6Wl
	 y/8HLKZJZ+CYisZpnjSQX1gOpuOl8SvcJBxZ58jA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 186/522] USB: serial: cypress_m8: fix memory corruption with small endpoint
Date: Tue, 16 Jun 2026 20:25:33 +0530
Message-ID: <20260616145134.816000690@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit e1a9d791fd66ab2431b9e6f6f835823809869047 upstream.

Make sure that the interrupt-out endpoint max packet size is at least
eight bytes to avoid user-controlled slab corruption or NULL-pointer
dereference should a malicious device report a smaller size.

Fixes: 3416eaa1f8f8 ("USB: cypress_m8: Packet format is separate from characteristic size")
Cc: stable@vger.kernel.org	# 2.6.26
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
[ johan: adjust context for 6.18 ]
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/serial/cypress_m8.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/usb/serial/cypress_m8.c b/drivers/usb/serial/cypress_m8.c
index 4c625e77da3a8f..f567617c8f2314 100644
--- a/drivers/usb/serial/cypress_m8.c
+++ b/drivers/usb/serial/cypress_m8.c
@@ -448,6 +448,14 @@ static int cypress_generic_port_probe(struct usb_serial_port *port)
 		return -ENODEV;
 	}
 
+	/*
+	 * The buffer must be large enough for the one or two-byte header (and
+	 * following data), but assume anything smaller than eight bytes is
+	 * broken.
+	 */
+	if (port->interrupt_out_size < 8)
+		return -EINVAL;
+
 	priv = kzalloc(sizeof(struct cypress_private), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
-- 
2.53.0



