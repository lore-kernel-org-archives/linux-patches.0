Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 761A147A0A9;
	Tue, 16 Jun 2026 18:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633731; cv=none; b=WbMMtpK5/Gs6j3CcKC0tOGY3oyKX4k4h7TT6i8Nl6+Br4QIDgfGYg3Ryvpuubilbs1viDXssENmipGEbrspOl8dFLNgTzc3wRYyAaCIYSA20dtnt3xAtgDEapXIe9BWoItDfABJd3Obnd4NYKJObg13nGSGjfm87rMhl/+zqf4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633731; c=relaxed/simple;
	bh=HMYuAiu3yPAl6ggnVaMs8Ym68zFqfKTDt7+v0iA5SAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QceZy23VohYex5AamieTYWPu+KNWryKl7sjtr90QK849vI7ytzT9uPPhS6Q5SXECrKDRoi0aovFhg/5XEUlcekEbEJDsnU7Wn/JL1En1bAtD803zN+f5a+JgKOHg2WlJSTVC4JB86vZsnGZT2F/5IGLvufjaZsjc3ykaDQh57QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bGFqUqJ7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bGFqUqJ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58D3C1F000E9;
	Tue, 16 Jun 2026 18:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633730;
	bh=9RT6iHLxo/ZsKXsVSO8qUzNTF1aEH3Lw8Y/s4V9d+9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bGFqUqJ76CW5xgYIXyFvgTk5k3wkOKl3Z7/Qyx85w8YMIpBZrH15UiSa/baPW+A2w
	 R4sKMfrXYfyRLiCnsCl1PJOKjY/EgXU7I4jsmGGlY4Hok0Uyx8ZbgU8Mjgzjw4lOG2
	 dyPl3Od7VFO3HF/br9at8BXyK30mElItsBdGtyJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 135/411] USB: serial: cypress_m8: fix memory corruption with small endpoint
Date: Tue, 16 Jun 2026 20:26:13 +0530
Message-ID: <20260616145107.529162631@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 115e2df92132d3..2ca7e7af714fdb 100644
--- a/drivers/usb/serial/cypress_m8.c
+++ b/drivers/usb/serial/cypress_m8.c
@@ -447,6 +447,14 @@ static int cypress_generic_port_probe(struct usb_serial_port *port)
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



