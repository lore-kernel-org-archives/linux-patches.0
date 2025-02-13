Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B5C15539A;
	Thu, 13 Feb 2025 14:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458194; cv=none; b=Y672H2x8SMmWh8+TGgswdfaORPAZXTRf7vl1+XgYef2cyn6qHsA/yhtbxYe//vw7MkPK4KzoLI1xNMVRQ8LC6LteTY1P/nqGbZoQBZZi6s1RXaFy07lHVXjffrikyB8/DXv1ztpbBlJtJ4ZJuLLL1yZTNj28C/4txrWOLhgJ2Hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458194; c=relaxed/simple;
	bh=i790yB9Z4m7UEMPNZCvVwRxCrwZPcd7qQ1HXNwauTmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DORJulCUtIc2+/dOPijPG/r2zLoz9d1VdbRUQVAzAkIpJ4h35iBmwAIzXIWM1lgUoBsCmRy26luDDvv9UvulbdFE2X+z+EA58aXOxdHkGpfhaNKuGv/GMISkPUXaGfYk1HqF6jZST+v0yJCx1G0ImqB2Builu/XkUpPmCNH1w4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qp8ARO8S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qp8ARO8S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53CB5C4CED1;
	Thu, 13 Feb 2025 14:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458193;
	bh=i790yB9Z4m7UEMPNZCvVwRxCrwZPcd7qQ1HXNwauTmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qp8ARO8SihQxQQ8wV7I7IgRzSWR6JNbGP4iTzkZMCbVLj2ien6prtkANdhoTCrKQ6
	 odqCQUZ4/XXjopCn31JMvAsvBUE9S3BxigcQ1HGdwm71Gtj10XNHuoHiC1lu4gtne9
	 Elx7ZbX6mbswDGQOc8vk6ZKmU+LkKQeK/K4pP+3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.12 328/422] media: ccs: Fix CCS static data parsing for large block sizes
Date: Thu, 13 Feb 2025 15:27:57 +0100
Message-ID: <20250213142449.213548595@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit 82b696750f0b60e7513082a10ad42786854f59f8 upstream.

The length field of the CCS static data blocks was mishandled, leading to
wrong interpretation of the length header for blocks that are 16 kiB in
size. Such large blocks are very, very rare and so this wasn't found
earlier.

As the length is used as part of input validation, the issue has no
security implications.

Fixes: a6b396f410b1 ("media: ccs: Add CCS static data parser library")
Cc: stable@vger.kernel.org
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ccs/ccs-data.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/i2c/ccs/ccs-data.c
+++ b/drivers/media/i2c/ccs/ccs-data.c
@@ -98,7 +98,7 @@ ccs_data_parse_length_specifier(const st
 		plen = ((size_t)
 			(__len3->length[0] &
 			 ((1 << CCS_DATA_LENGTH_SPECIFIER_SIZE_SHIFT) - 1))
-			<< 16) + (__len3->length[0] << 8) + __len3->length[1];
+			<< 16) + (__len3->length[1] << 8) + __len3->length[2];
 		break;
 	}
 	default:


