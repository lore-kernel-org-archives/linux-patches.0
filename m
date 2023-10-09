Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A75E11A5A3
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MSxXr/Ao"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F189C433C9;
	Mon,  9 Oct 2023 13:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696859283;
	bh=iTT4lTfu4dYPhUS4KjM4PXwWkcmIiZd1MDZlsboRFEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MSxXr/AoEIE1HCnknroF4FAK+PF+74xOa6Y1k2iivDwwuuVnGsaBmYQhlSKEecAbZ
	 73hRHqrrRGTO5bmmd2lNl+zH9nKJcsSpwSjElX17F6X11JdZ9oJGaL29i1MDfHFhxj
	 u0eBgAxCrkuHvHSwf60g965wDECQCoUMxrY97T1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Schiffer <mschiffer@universe-factory.net>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 4.14 29/55] ata: libata-sata: increase PMP SRST timeout to 10s
Date: Mon,  9 Oct 2023 15:06:28 +0200
Message-ID: <20231009130108.812594270@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130107.717692466@linuxfoundation.org>
References: <20231009130107.717692466@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthias Schiffer <mschiffer@universe-factory.net>

commit 753a4d531bc518633ea88ac0ed02b25a16823d51 upstream.

On certain SATA controllers, softreset fails after wakeup from S2RAM with
the message "softreset failed (1st FIS failed)", sometimes resulting in
drives not being detected again. With the increased timeout, this issue
is avoided. Instead, "softreset failed (device not ready)" is now
logged 1-2 times; this later failure seems to cause fewer problems
however, and the drives are detected reliably once they've spun up and
the probe is retried.

The issue was observed with the primary SATA controller of the QNAP
TS-453B, which is an "Intel Corporation Celeron/Pentium Silver Processor
SATA Controller [8086:31e3] (rev 06)" integrated in the Celeron J4125 CPU,
and the following drives:

- Seagate IronWolf ST12000VN0008
- Seagate IronWolf ST8000NE0004

The SATA controller seems to be more relevant to this issue than the
drives, as the same drives are always detected reliably on the secondary
SATA controller on the same board (an ASMedia 106x) without any "softreset
failed" errors even without the increased timeout.

Fixes: e7d3ef13d52a ("libata: change drive ready wait after hard reset to 5s")
Cc: stable@vger.kernel.org
Signed-off-by: Matthias Schiffer <mschiffer@universe-factory.net>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/libata.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -312,7 +312,7 @@ enum {
 	 * advised to wait only for the following duration before
 	 * doing SRST.
 	 */
-	ATA_TMOUT_PMP_SRST_WAIT	= 5000,
+	ATA_TMOUT_PMP_SRST_WAIT	= 10000,
 
 	/* When the LPM policy is set to ATA_LPM_MAX_POWER, there might
 	 * be a spurious PHY event, so ignore the first PHY event that


