Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9B9285CA2;
	Tue, 11 Nov 2025 01:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825035; cv=none; b=cbybwFOpxxCePVUNConkCswHPSTHxPO3jjM7d7fjEOXvBf1JuNliXo2wXqkN6F0DTiOOFbUCuPQEQLcUa0s6AU0HL1kvWdqprXDB56Jq98v1WSsFsRJPE/+GNAb+ED2TRKpefyz9XyJ9kGTSKz6VSI5HE6Ct5vLJa4N5N4kByZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825035; c=relaxed/simple;
	bh=Uw426gE+l3+qW6gzJLfB0oJfHa4lBGIMA5W73MnMCrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qFmt+GFDXY5OH/JI+d21/V6j532oeTgR4ymNx2RNDxWEZH7SdthToWiHSvGBia0nFqMqjnrfprolyW5Q3ORXc9HX0jmi6OlVIjWLpFF5RNTwjQGLdfk7yzvZLos3T9T8HQzVX9IwGfadrNncahNOCOgmM6f3gM1yWNxRqk7V7Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X82XS/jU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X82XS/jU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CEA7C2BC86;
	Tue, 11 Nov 2025 01:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825035;
	bh=Uw426gE+l3+qW6gzJLfB0oJfHa4lBGIMA5W73MnMCrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X82XS/jUDRfFKuYOZDoNxs1WXh0VeM6lL+wA4lSNR2KBdCrDJfafpmLYvP9pxgBHO
	 wVgShEiUb3t0KgIdrq2WEbaxThIzDfwDbcGZpPRKpoHAycWd9fx5IIwRKBLFBPlKHe
	 SOO9wQtpTLQvh+vhgsFhYSfDATnC92PrAK9Rfvao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 634/849] scsi: libfc: Fix potential buffer overflow in fc_ct_ms_fill()
Date: Tue, 11 Nov 2025 09:43:24 +0900
Message-ID: <20251111004551.761369026@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit 072fdd4b0be9b9051bdf75f36d0227aa705074ba ]

The fc_ct_ms_fill() helper currently formats the OS name and version
into entry->value using "%s v%s". Since init_utsname()->sysname and
->release are unbounded strings, snprintf() may attempt to write more
than FC_FDMI_HBA_ATTR_OSNAMEVERSION_LEN bytes, triggering a
-Wformat-truncation warning with W=1.

In file included from drivers/scsi/libfc/fc_elsct.c:18:
drivers/scsi/libfc/fc_encode.h: In function ‘fc_ct_ms_fill.constprop’:
drivers/scsi/libfc/fc_encode.h:359:30: error: ‘%s’ directive output may
be truncated writing up to 64 bytes into a region of size between 62
and 126 [-Werror=format-truncation=]
  359 |                         "%s v%s",
      |                              ^~
  360 |                         init_utsname()->sysname,
  361 |                         init_utsname()->release);
      |                         ~~~~~~~~~~~~~~~~~~~~~~~
drivers/scsi/libfc/fc_encode.h:357:17: note: ‘snprintf’ output between
3 and 131 bytes into a destination of size 128
  357 |                 snprintf((char *)&entry->value,
      |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  358 |                         FC_FDMI_HBA_ATTR_OSNAMEVERSION_LEN,
      |                         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  359 |                         "%s v%s",
      |                         ~~~~~~~~~
  360 |                         init_utsname()->sysname,
      |                         ~~~~~~~~~~~~~~~~~~~~~~~~
  361 |                         init_utsname()->release);
      |                         ~~~~~~~~~~~~~~~~~~~~~~~~

Fix this by using "%.62s v%.62s", which ensures sysname and release are
truncated to fit within the 128-byte field defined by
FC_FDMI_HBA_ATTR_OSNAMEVERSION_LEN.

[mkp: clarified commit description]

Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libfc/fc_encode.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libfc/fc_encode.h b/drivers/scsi/libfc/fc_encode.h
index 02e31db31d68e..e046091a549ae 100644
--- a/drivers/scsi/libfc/fc_encode.h
+++ b/drivers/scsi/libfc/fc_encode.h
@@ -356,7 +356,7 @@ static inline int fc_ct_ms_fill(struct fc_lport *lport,
 		put_unaligned_be16(len, &entry->len);
 		snprintf((char *)&entry->value,
 			FC_FDMI_HBA_ATTR_OSNAMEVERSION_LEN,
-			"%s v%s",
+			"%.62s v%.62s",
 			init_utsname()->sysname,
 			init_utsname()->release);
 
-- 
2.51.0



