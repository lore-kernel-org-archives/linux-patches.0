Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC0A47D94B;
	Thu, 20 Aug 2026 17:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247901; cv=none; b=LnQo9YklNoQWTO2XzjSUOrPLKMcmFV2rbeApDuMZxLhubXRb0++y4Wncq53Qvrn5JeAG/3LaK3qFbAtJ6s7hH//xEkD62UQE6GxG+wGgOI6EbLqVb16gtQ23C9HBIrKZlIirrDJSIRh+cBzvwXHBXb34tkbK7eXLa4tFV0x12WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247901; c=relaxed/simple;
	bh=o0+S+ZyIQ0vJBBsE0oK5veBQVJCTPwwLSfrncypv/XY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=geetGmG+W+dvGqdbqpPctqfmVyRKWAFJmDJ6VU7WfoOqHLeLd6wU0U6dyaZ9r+mGp+rFqvpqFyyVCyzh7DtmDEMRithbkIjkm2R+gl/AOVvoOcSusrp1Pxem6gmWIPsQk2/T/MtfZBMoL/B0j/VjjqMUazz7TM9ZifHftBScev4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OSzML88w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OSzML88w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C371F00A3A;
	Thu, 20 Aug 2026 17:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247900;
	bh=DkNV6jvoyxkFJbGWcpMU/8MPYOR6GJEGOggnQcq7uns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OSzML88wFJLMH1ctfR58ZGewJE1e57rzzE9XjmEUe5X4ip2NV29ePul3gepheqIk7
	 tZmNCaGbNuLiS3l2m80xI706JjPMqoJZ63LN2ThU+DFU6iVYUnepKfkpBb6ATG4Kel
	 DVVfFni2DqaFiujS1cMAFiXc4uTCz8M20y/ilsf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haibo Chen <haibo.chen@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.1 041/303] mmc: sdhci: make tuning_err a signed int
Date: Thu, 20 Aug 2026 16:52:57 +0200
Message-ID: <20260820145254.415239251@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

From: Haibo Chen <haibo.chen@nxp.com>

commit ae31bcc92bb42502bb7c9029e6dc7a824cf6cd14 upstream.

Coverity report INTEGER_OVERFLOW for host->tuning_err.
The tuning_err field in struct sdhci_host is used to store an error
code for re-tuning, but it was declared as unsigned int. Several call
sites store negative error codes into it and later compare against
negative values:

  - sdhci.c, sdhci-of-dwcmshc.c and sdhci-pci-gli.c assign it the
    return value of __sdhci_execute_tuning()/__sdhci_execute_tuning_9750(),
    both of which return a signed int (possibly a negative errno);
  - sdhci-of-esdhc.c assigns host->tuning_err = -EAGAIN and later does
    "ret = host->tuning_err; if (ret == -EAGAIN ...)";
  - sdhci-of-dwcmshc.c prints it with the %d (signed) conversion.

Storing a negative errno in an unsigned int and reading it back as a
signed int only happens to work because of two's-complement, same-width
integer conversions. It is misleading and triggers sign-conversion
warnings. All users treat the value either as a signed error code or as
a boolean (zero / non-zero), so changing the type to a signed int is
safe and makes the intent explicit.

Fixes: 7d8bb1f46e13 ("mmc: sdhci: add tuning error codes")
Assisted-by: Cline:claude-sonnet [read_file, search_files, git]
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -601,7 +601,7 @@ struct sdhci_host {
 
 	unsigned int		tuning_count;	/* Timer count for re-tuning */
 	unsigned int		tuning_mode;	/* Re-tuning mode supported by host */
-	unsigned int		tuning_err;	/* Error code for re-tuning */
+	int			tuning_err;	/* Error code for re-tuning */
 #define SDHCI_TUNING_MODE_1	0
 #define SDHCI_TUNING_MODE_2	1
 #define SDHCI_TUNING_MODE_3	2


