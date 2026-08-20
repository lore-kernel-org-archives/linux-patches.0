Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D424480953;
	Thu, 20 Aug 2026 17:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787246971; cv=none; b=pWy+tgcBVfJa4RNjE7fjxwQGoE9mlBnCb8P1ojMEHTXtosCOLyboCq3uwND8jUXidmT254+f8MauIxJ5jGfO8D5z4wiJHFpnssmufioPr9dE4FLEhMb/4V6Z87tK08gq13uj/W0ImKVOYD9GmHb3RO/7pQRiSxNENdBHwBTmC9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787246971; c=relaxed/simple;
	bh=3kWWYA+shw7C5HK6AhAj2DALFCnBFdQ9J5roW2u/2mY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fw5M45qDg1hykE3kW1emN4NR8Ruc7tIR5NNmOIVAksqN8wDrijd/zJ8VBNlaaK5DlZJtq5GF0eYwJ+bFmW9s32EfQA/R869eFu50nMiSG8TkvUO7vQiic8sbqlcxQycMWsMSOps//5SqsqvTnCA3RTBXFZIYpn7e2m/aHgU7OGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YFSAfIR6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YFSAfIR6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 701921F000E9;
	Thu, 20 Aug 2026 17:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787246970;
	bh=WuBgbaq7y5QvggoP4efgFYzR6ygEST2K5msuUu87xVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YFSAfIR6Jw1Ro8rfqNZgPPFc9MLdfJpRAzvqqgxC6kHMSWk3H3yOfiBcebXU/dWkH
	 V0q86W3kDNY+NcmOLGCtNKeG7d8BZmjwxtmUC8UjgmazrMcDnK9RZh9sOlSVnuXSqJ
	 7vKbeh0oKHJmmqVPPv11opK+MQEa0wtv/pJiN22A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haibo Chen <haibo.chen@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.12 065/220] mmc: sdhci: make tuning_err a signed int
Date: Thu, 20 Aug 2026 16:54:15 +0200
Message-ID: <20260820145225.440311661@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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
@@ -604,7 +604,7 @@ struct sdhci_host {
 
 	unsigned int		tuning_count;	/* Timer count for re-tuning */
 	unsigned int		tuning_mode;	/* Re-tuning mode supported by host */
-	unsigned int		tuning_err;	/* Error code for re-tuning */
+	int			tuning_err;	/* Error code for re-tuning */
 #define SDHCI_TUNING_MODE_1	0
 #define SDHCI_TUNING_MODE_2	1
 #define SDHCI_TUNING_MODE_3	2


