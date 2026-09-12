Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403841DC198;
	Sat, 12 Sep 2026 08:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202109; cv=none; b=JFYrj8FFbQGOsabCnluDwyIA89FYwWtvQ4WmXUsvfBMYkc4sJjOKI/fUEsTjLtvw5sstaB8owW0xAndKNx5SmfF/kaXWnfY0YgypweuqnJktJJSQH3tl0KiSy76fkJrCzKKU534kgoBAMGIq43/70QFY7GlGXOza2lf5OWWTPPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202109; c=relaxed/simple;
	bh=3H8TQWjNAro0lIHwfrLHZyp5ew4Qzur8XjGW9TGJ/dA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hbp1Y4ENeYLCR7mse2Gb6h1qKdWrBcPbgppiG/dbQQspjeqI03k3bX9wJ/eFbo+RDxWsWtNBFpRh9wSf9NfAP/o0z8tlKIkYOVrAzx6Kh+SDeGLZM1rN1fmQRkrPwVbgCL2HpykY6dVNtLSrdhi3C1PyJI/9IYmqT/slgGf+pD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ptfNoycC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ptfNoycC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E18B1F000FF;
	Sat, 12 Sep 2026 08:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202108;
	bh=UH78sp/0J9qhMP53fU3aCPNHpQVoPOwkjYDYM4YH+Kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ptfNoycCm/Qugx8lBXrebnn0I3STplJbxg1ALnIUIO7r4WiXs64GbZ/wkhAnw8AF2
	 QFoYIXA1J5NiFZSe/CRTncgF/E5Ry0/sJK4l1fosY2dJ/7qeGJs8niGKiphQLlA5bo
	 GOL8sfAsw9iDiKKr5Jn+giUiqM51yUtRIcbVkRZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1098/1815] xen/xenbus: check otherend_id only after it has been initialized
Date: Sat, 12 Sep 2026 08:47:28 +0200
Message-ID: <20260912065714.794878937@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>

[ Upstream commit c76cbf348c7df077f93fa99a1225a527ce64cfa1 ]

When device just got initialized (for example on module load), the
otherend_id field is initialized only after
xenbus_read_otherend_details() gets called. If xenstore watch triggers
xenbus_dev_changed() before that, it might consider still zeroed
otherend_id field (not matching actual xenstore content) as a sign of
device state reset. It can happen because xenstore watch are handled in
another thread (xenwatch), which can run in parallel to the initial
device probe running at module load. In that case, it would call
device_unregister(), which would deadlock against device probe from
module init.

Fix this by considering dev->otherend_id change only after dev->otherend
is set (which happen after otherend_id is initialized).

Fixes: e2dcf9065536 "xen/xenbus: better handle backend crash"
Signed-off-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20260803030822.4104093-2-marmarek@invisiblethingslab.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/xenbus/xenbus_probe.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index fafb2b84fa5c4..9371f88ac5588 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -681,7 +681,8 @@ void xenbus_dev_changed(const char *node, struct xen_bus_type *bus)
 							    dev->otherend_id);
 
 		if (state == XenbusStateInitialising &&
-		    (state != dev->state || backend != dev->otherend_id)) {
+		    (state != dev->state ||
+		     (dev->otherend && backend != dev->otherend_id))) {
 			/*
 			 * State has been reset, assume the old one vanished
 			 * and new one needs to be probed.
-- 
2.53.0



