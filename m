Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81374296BCC;
	Sun,  7 Jun 2026 10:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829493; cv=none; b=qNx7ey+72YvdVVmHfTKvlJdYGAhHIJNhLOoyzUUo7ODvTxxIHrqPkdZocADoc2LTcpAdaQqxwmGgGXzTnuQAQOmKQ9OLCYMoxDUYbICtlWF+GvgWYJ053SOCIkrl9dkVGS8KUlm6DlzMJng6OtNxBj41+U7NtcmMDJ/ZBorutpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829493; c=relaxed/simple;
	bh=DJTBxQTG4tNSB4p3N7+KZ9djm4JcMOZ5QqdarkhqvlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QgtPXCnknHMSHghr404i9oGAEd9mEEIFBeS1ovJjYyRaDGK0OurA7FekpkzrDTKFp/tgBQJKid4nbdSPH9Mgs4AytoS2dBw9nbTrlwbIf18r0FD7kx21AWr4wlChqVmcRy7qeRopC7g81c8KNIaeOOhvG4xWIvs17GyFQfKZVhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KkmRCaXd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KkmRCaXd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A986C1F00893;
	Sun,  7 Jun 2026 10:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829492;
	bh=IuNl3B7wwl/KZXJbDwmTS1bpJfXMWlQ9Tj9fENBIuXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KkmRCaXdTaWyQUSnnjAVwYnyvEGT4GwpgRFUytwGUjFmVSZOuKmgAuHYMDvdjpjeZ
	 0eFETa9Y3VhUjeqxmmRw7yr/GqtCZ8tXYDWHfI8MxP/+gFN9xpPWQmDpy45EXkm4WY
	 pdtpLnLSXRjFudI2UiKg/P065HGCR0Y09qRxT6Nk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 229/307] USB: serial: mct_u232: fix missing interrupt-in transfer sanity check
Date: Sun,  7 Jun 2026 12:00:26 +0200
Message-ID: <20260607095736.118592485@linuxfoundation.org>
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

commit 245aba83e3c288e176ed037a1f6b618b09e92ed8 upstream.

Add the missing sanity check on the size of interrupt-in transfers to
avoid parsing stale or uninitialised slab data (and leaking it to user
space).

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/mct_u232.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/serial/mct_u232.c
+++ b/drivers/usb/serial/mct_u232.c
@@ -543,6 +543,11 @@ static void mct_u232_read_int_callback(s
 		goto exit;
 	}
 
+	if (urb->actual_length < 2) {
+		dev_warn_ratelimited(&port->dev, "short interrupt-in packet\n");
+		goto exit;
+	}
+
 	/*
 	 * The interrupt-in pipe signals exceptional conditions (modem line
 	 * signal changes and errors). data[0] holds MSR, data[1] holds LSR.


