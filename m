Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD03F4F93B3;
	Tue, 13 Oct 2026 12:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895447; cv=none; b=HbnapAKGEQVIYc0HbBQMBnPTWgw7NrLMYG1unuK6ngEMMLVqAWM1o8WhYRIkFLXNhtQXD413mytk7y3IpPAPNjZcAOOnh8voybdzwX4ejXgU11OBUlE/1DkinE4n+PPElsSHSKVhVtGJt72vKEQDHMDn2lf8gv0Mbi8NkKTKxP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895447; c=relaxed/simple;
	bh=AfnGAIzMOx7BZcLxwDTFatFANCxqLaeqGCe0T3X9RAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EV18JW8k723QRkZ3r+/tF7Y5XEhFKRcTKww3WcWbltLEcKudwxF6obeLFi/UtrTATGyg8cErlSCE2N+IR2qcmArjTeJJEnd/iqD71oTWSZ1m5EoHZlFK5CQxniRZZykeUTw8lJNDKXDQFb2orPg8w0AAjpYVwqUCY+QV8ipnSoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AIpSB7DE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AIpSB7DE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33AB01F00898;
	Tue, 13 Oct 2026 12:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895444;
	bh=b5i3ncWBN8tjc2P2A+B6FrCZcuH0kO+udKwcNWSXKOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AIpSB7DECkJMcPvo11UUD1gvrDy/Nw1ioVqmj1L66TVv0QW+xdqCGUWOzIH3najzM
	 IX6i8AjA1ci1MlTvQGf+fKKKfNyNYZ++c5CqZFLzwQQVFoHSMT0xHk9id+CTRh6qpJ
	 SBdlpEWmr9IdxU+AdZt25UTMvNadtJyMd4ccR1/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slavin Liu <bolin.liu@seu.edu.cn>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.12 233/497] iio: adc: pac1934: check ACPI label duplication
Date: Tue, 13 Oct 2026 13:36:40 +0200
Message-ID: <20261013112913.429231847@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Slavin Liu <bolin.liu@seu.edu.cn>

commit 64c82e7bd9c82b0c9276297df34a3579e8658f55 upstream.

A label duplication failure currently reaches the terminating-byte
write. Release the ACPI result and abort before accessing the missing
label; earlier labels are managed by devres.

Detected by static analysis and reviewed with AI-assisted source auditing.

Fixes: 0fb528c8255b ("iio: adc: adding support for PAC193x")
Assisted-by: LLM
Signed-off-by: Slavin Liu <bolin.liu@seu.edu.cn>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/pac1934.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/iio/adc/pac1934.c
+++ b/drivers/iio/adc/pac1934.c
@@ -1108,6 +1108,10 @@ static int pac1934_acpi_parse_channel_co
 			devm_kmemdup(dev, rez->package.elements[i].string.pointer,
 				     (size_t)rez->package.elements[i].string.length + 1,
 				     GFP_KERNEL);
+		if (!info->labels[idx]) {
+			ACPI_FREE(rez);
+			return -ENOMEM;
+		}
 		info->labels[idx][rez->package.elements[i].string.length] = '\0';
 		info->shunts[idx] = rez->package.elements[i + 1].integer.value * 1000;
 		info->active_channels[idx] = (info->shunts[idx] != 0);


