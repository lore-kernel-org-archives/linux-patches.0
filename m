Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 413B5242D86;
	Wed, 28 Jan 2026 15:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614458; cv=none; b=uEgVn0HrFjajd+VgreEY3UxvkTPiWx20XSezmB2HQWebVSNv4LJH4ZZ7aw/o6XISTWDzlEmDceYFacEUWQvVGi7xpR3ip1vcCoFK7k4h0u3P5nyPUBWGgjWmgd2EY4sR4BA3EJZQxa9W3kBbs1Rqg7i2FBJ/7SvipceH94InTyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614458; c=relaxed/simple;
	bh=8xTecCyNw9NfiV2wW9ACDcEt5n8T3UjJXMtfFTq7dLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GSg6knfrsV4Ou217mpm4DQjdjoaZ+IoljoIC1OwCXo6N9fWNcR18idULDJ8d8eZU5YX4lPq8E5ewwwVVaUsSigSFE9CRYOMz/486k3AdL48i/otooEvm/3nxNtbVOQQTFhQyWJfxxNUGYswBA0aaTC+B/Ghdxdo+PHJHJH0E/G4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tHthGLHs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tHthGLHs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A246AC4CEF1;
	Wed, 28 Jan 2026 15:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614458;
	bh=8xTecCyNw9NfiV2wW9ACDcEt5n8T3UjJXMtfFTq7dLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tHthGLHsKjIuhTiaMOg/fLg9EfTSYi9bzFS9UyGtg8mEAjGvHZXBENWHlJKy4fXJZ
	 MVSOSWcZOPRdp3TSTzNqSwywBbQ3DDqpEFRYWiYSfH+5n4nVrzOdhrFTr7HbSQLWDE
	 ATBsjJGH6pnrzGQeu2bpfG2ZvHYQKW/TVWXsJHSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Wolf <wolf@yoxt.cc>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 111/254] ata: libata: Add cpr_log to ata_dev_print_features() early return
Date: Wed, 28 Jan 2026 16:21:27 +0100
Message-ID: <20260128145348.818546454@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit a6bee5e5243ad02cae575becc4c83df66fc29573 ]

ata_dev_print_features() is supposed to return early and not print anything
if there are no features supported.

However, commit fe22e1c2f705 ("libata: support concurrent positioning
ranges log") added another feature to ata_dev_print_features() without
updating the early return conditional.

Add the missing feature to the early return conditional.

Fixes: fe22e1c2f705 ("libata: support concurrent positioning ranges log")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Tested-by: Wolf <wolf@yoxt.cc>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index f627753519b97..f332835156dbc 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2782,7 +2782,7 @@ static void ata_dev_config_cpr(struct ata_device *dev)
 
 static void ata_dev_print_features(struct ata_device *dev)
 {
-	if (!(dev->flags & ATA_DFLAG_FEATURES_MASK))
+	if (!(dev->flags & ATA_DFLAG_FEATURES_MASK) && !dev->cpr_log)
 		return;
 
 	ata_dev_info(dev,
-- 
2.51.0



