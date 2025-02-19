Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 235EF1E0E0A;
	Wed, 19 Feb 2025 09:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957115; cv=none; b=Y4RsIjTlwZqrPyhygy3H5bMw2Atxv5bXl7NWUwSJ6OSekCE0scJUnh4qXW1u57k5l6tT3KcAHqd8ZG8ITTlu0EYvuhwJ2enagmkc8fjnsc29jjI+EIpIa95ai2/CRvt6B5dMZcEa3buXR1ZstnKgZGxzsglU1vW3QjbIYKVdcfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957115; c=relaxed/simple;
	bh=xZNWRzP0SbkrnMtqOc4zkV9w83NI+TpwGXQsKKDh3Sk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=anNIveitITw7IZfGqZM/fw8Z4N67fPsRnj93gVUJeFw8es1sHCQIgwFv52fQ3UtCs8l0LQ6792Re+BdLCpeEKYp5TMTR9XIHYm8AbpPIOtixN5pNq7IKfUxZRt3TVYKOoArNQrVl98HZCB9qHlaAe7rPRManW+FyjsEjlc7zyBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aKLcy0sk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aKLcy0sk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D39DC4CEE6;
	Wed, 19 Feb 2025 09:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957115;
	bh=xZNWRzP0SbkrnMtqOc4zkV9w83NI+TpwGXQsKKDh3Sk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aKLcy0skKYcrWGkmHVC+jKyOZ2S7whls10jnJ4Ssq5hr0xmbpEa2t74TXl//kvdcS
	 UJlvgNL7QSM1dFVwBixsV0zY4KrTJKiq2JLybhEXEyHJaf2qBIbKZI4xuZDI3jzsK6
	 AJwDMg7gDKVCx3RNcG7FtrdoHVRe6uqXtCgJRqNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.1 412/578] media: ccs: Fix CCS static data parsing for large block sizes
Date: Wed, 19 Feb 2025 09:26:56 +0100
Message-ID: <20250219082709.229505560@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


