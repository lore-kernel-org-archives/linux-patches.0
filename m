Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2592F347BC6;
	Wed,  3 Dec 2025 16:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778328; cv=none; b=DZXX45ASYFp1pghPgIt38C8IyIIU9cI0kaXxK49JpRZNEs78EbY8estHPINpFMQrpv/+BfPGG66d1scC3MAw6bx9V8TV4M0sLma6dsQH51a7DxfKvVNfa0YNTcfoxdYVT+xBWMMfScAYlFLXVhKo8c9d/kH7pYyYKCPTFgAMDLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778328; c=relaxed/simple;
	bh=yyrdTa/NQhJlt7VDjij8D+/coQEZsQVilbSnMIgFeB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n4O/FogFEEVxyjDTrsZk69h5jawnngwCAMLUXyhE2azXpDme1MZ0TEVWaio8HEdsZKy+EXntnbwBfFc0sbJNyPbhOJOpU6HCThrXmGSZ10VoZz2xjioBNxT075RkpCejZglKWim7rVQiOHOHjOIYZQ5shOn62IBfkr9jOyKIeGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DnNsaJ1b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DnNsaJ1b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8518DC4CEF5;
	Wed,  3 Dec 2025 16:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778328;
	bh=yyrdTa/NQhJlt7VDjij8D+/coQEZsQVilbSnMIgFeB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DnNsaJ1bb6iYaQP0AUwmRxU5wkx/Tkm2ya9TqBZuGT08172Qwfm7RsZ5XdwUMXAyA
	 /sbnNnOt/KdTP9piVe8jly3LYO6hb+W8BsqC5bm3m++FvNIvvbN3jCfom7dbCwRHR+
	 Qva5S7VoT0ltJ+v38VnF53x3D/CtPM7aarKPaeVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niravkumar L Rabara <niravkumarlaxmidas.rabara@altera.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 5.15 279/392] EDAC/altera: Use INTTEST register for Ethernet and USB SBE injection
Date: Wed,  3 Dec 2025 16:27:09 +0100
Message-ID: <20251203152424.428045155@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

From: Niravkumar L Rabara <niravkumarlaxmidas.rabara@altera.com>

commit 281326be67252ac5794d1383f67526606b1d6b13 upstream.

The current single-bit error injection mechanism flips bits directly in ECC RAM
by performing write and read operations. When the ECC RAM is actively used by
the Ethernet or USB controller, this approach sometimes trigger a false
double-bit error.

Switch both Ethernet and USB EDAC devices to use the INTTEST register
(altr_edac_a10_device_inject_fops) for single-bit error injection, similar to
the existing double-bit error injection method.

Fixes: 064acbd4f4ab ("EDAC, altera: Add Stratix10 peripheral support")
Signed-off-by: Niravkumar L Rabara <niravkumarlaxmidas.rabara@altera.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Dinh Nguyen <dinguyen@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20251111081333.1279635-1-niravkumarlaxmidas.rabara@altera.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/edac/altera_edac.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/edac/altera_edac.c
+++ b/drivers/edac/altera_edac.c
@@ -1341,7 +1341,7 @@ static const struct edac_device_prv_data
 	.ue_set_mask = ALTR_A10_ECC_TDERRA,
 	.set_err_ofst = ALTR_A10_ECC_INTTEST_OFST,
 	.ecc_irq_handler = altr_edac_a10_ecc_irq,
-	.inject_fops = &altr_edac_a10_device_inject2_fops,
+	.inject_fops = &altr_edac_a10_device_inject_fops,
 };
 
 #endif	/* CONFIG_EDAC_ALTERA_ETHERNET */
@@ -1431,7 +1431,7 @@ static const struct edac_device_prv_data
 	.ue_set_mask = ALTR_A10_ECC_TDERRA,
 	.set_err_ofst = ALTR_A10_ECC_INTTEST_OFST,
 	.ecc_irq_handler = altr_edac_a10_ecc_irq,
-	.inject_fops = &altr_edac_a10_device_inject2_fops,
+	.inject_fops = &altr_edac_a10_device_inject_fops,
 };
 
 #endif	/* CONFIG_EDAC_ALTERA_USB */


