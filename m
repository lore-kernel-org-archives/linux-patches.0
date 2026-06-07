Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E33312CDA5;
	Sun,  7 Jun 2026 10:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829889; cv=none; b=TLK6IPqcFR3ajM/RDE9+3anaD2+vwo65SKDDeZiSj2H5uZKRCEimUScWUiZfktArKsTb7jU+ipPlkeLbKu9NIRv1NfT36rPFY42RhSF1MVK84sQaJysr8hiXx5xEewGDZ8wLUbVM1voX6uRK/qIpucpPHMyyeC1i4vauBDfRexY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829889; c=relaxed/simple;
	bh=Qmblrcb2bwwv4lRfnOeNeKmPMXYlzl5ewlluWfNgs74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T/GGoGy0CpXq8ju76gKkqXF6QlJT9yWOuunRLB1BXcBCACQ3GNkjHirMraKO+TS/fbkujjeZFPMu+LhlPlMFrsXIm6+EKYruThkzV4x02JKT6f+rO+UAce9js5ieF+QEmjtXUKC84RkHxSYdvMoKAIHfmrPdTCUaeCHzpV0lzeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cpu2h2mK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cpu2h2mK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51B511F00893;
	Sun,  7 Jun 2026 10:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829887;
	bh=EdDTL58b9rVff4RzFSvngndDZcQFNPS7M8MuO4rkBP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cpu2h2mK/wZ5G+WBmAeWw+G0neAv5WdyYqcD7dIqz1AoluKLTdkgQ6f2AoxE3EPex
	 elZKBx+uR1CeXYAmkr0Xi2L7hh2bO5cAUVat1TD5BNhWaEGf+Y7AYc5oYQ+HsMk9aq
	 miqfy9wuDkZZaJqtpmHbsCQpmU7Q5txIK4BiJapw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 262/307] USB: serial: cypress_m8: fix memory corruption with small endpoint
Date: Sun,  7 Jun 2026 12:00:59 +0200
Message-ID: <20260607095737.326262384@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index eb47f35aab0ced..905f6a560e0455 100644
--- a/drivers/usb/serial/cypress_m8.c
+++ b/drivers/usb/serial/cypress_m8.c
@@ -445,6 +445,14 @@ static int cypress_generic_port_probe(struct usb_serial_port *port)
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



