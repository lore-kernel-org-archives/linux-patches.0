Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B3D13644AD;
	Tue,  6 Jan 2026 17:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722014; cv=none; b=pA9TZXz9Msq8/XfdW+qpa/4uiEPVwKZLFOHFrsQERtFqzRffs0m9cUxW10XlG7YOzw8+XDuFcyu/8UicH1GC5M4K5XDN2u87P7o+E252liSFtVzYCh/UXWaNw3T4Qmd07x1GttyZQKoP5RQ2z+zckjLdDM2DQI48jFkmZBmGn1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722014; c=relaxed/simple;
	bh=7/3bJL4vdnCaxqwQK1HtezW2nINNZCcVFSEvn2nXjs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ChdVXFQjNucxrlWN7/U58scJpJHvqJMNxa/2QGnkqPnewL1nKw+2YRgzqp9Hb7SxwYaViNEQ2pTpeVnDyDfonlELomSKdogZ3BlHn+4oT+2rN86ABwzBDS0kaZm0+sPGLnogDFefaV9i0yNgwae5TOGBYdYvLdjrRRtKwtEXOZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PdvEN4TR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PdvEN4TR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D189DC116C6;
	Tue,  6 Jan 2026 17:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722014;
	bh=7/3bJL4vdnCaxqwQK1HtezW2nINNZCcVFSEvn2nXjs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PdvEN4TR7+dUIFd+2z0Jge287pcwx7r6GemcUYmUsa5Qpy9mGiwEER/HSgNj5LaOt
	 HmDZ8bUY5kyXs0S5odRoOPCCPci9HFtWFgoM9Ij3AygvAeXd4WbwbS1XfQZ92MllH7
	 EiVgVjE7jX1EmdoxmHhUh0GKbsX9hwtgTjVA1GJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.18 140/312] mfd: altera-sysmgr: Fix device leak on sysmgr regmap lookup
Date: Tue,  6 Jan 2026 18:03:34 +0100
Message-ID: <20260106170552.906748071@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit ccb7cd3218e48665f3c7e19eede0da5f069c323d upstream.

Make sure to drop the reference taken to the sysmgr platform device when
retrieving its driver data.

Note that holding a reference to a device does not prevent its driver
data from going away.

Fixes: f36e789a1f8d ("mfd: altera-sysmgr: Add SOCFPGA System Manager")
Cc: stable@vger.kernel.org	# 5.2
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mfd/altera-sysmgr.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/mfd/altera-sysmgr.c
+++ b/drivers/mfd/altera-sysmgr.c
@@ -117,6 +117,8 @@ struct regmap *altr_sysmgr_regmap_lookup
 
 	sysmgr = dev_get_drvdata(dev);
 
+	put_device(dev);
+
 	return sysmgr->regmap;
 }
 EXPORT_SYMBOL_GPL(altr_sysmgr_regmap_lookup_by_phandle);


