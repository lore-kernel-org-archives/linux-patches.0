Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A4630EF6D;
	Mon, 13 Oct 2025 15:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367810; cv=none; b=XQ5nkkBGsOO4ZmcOk21TXh3/pT6/atZR7/A5b2x3XHRjFqKoHEUmRicPONWjwGyKT8AfmuLtF2vzgddt9ifetMXPeKWPU4GBn7rg+TDN5hSxNFjomLwWRvLqJeuqimQdRoGgwHVFlAfgdaG5YLy+GKlzCGaw/a53a1U36nJloQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367810; c=relaxed/simple;
	bh=ZUhEa3hiRqvHATtGWxXIfG/Y1oTa+pQZ/MdT0Ju86Zs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d/okyGm27uo30ZOzED72rOVOHU5vVUDFfKkphOTgjtbVVVLOcabZUo4fiFFdde+03vb0XDyQEgwwYCewqxQXkrGXyXUn7iRB1SgkEoVX5+TJ8t+RMvYxTLm+i1lAOeadzuK0l1JKtaj65V/fi0qSjkeKNiwp3OB0QZD135dOcAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dO96JG0l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dO96JG0l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0706CC4CEE7;
	Mon, 13 Oct 2025 15:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367809;
	bh=ZUhEa3hiRqvHATtGWxXIfG/Y1oTa+pQZ/MdT0Ju86Zs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dO96JG0l/i34zHmh+eGmgaKtAunPtmTjHhrUO+yQDDa1hTTxTJgvX6S71VC1Oxy6L
	 Z33Rl0iHRLbxMA98fVFMxM5Q+0cSNNKsPXjxKb8oWDyVRWqpD1/D4YNPeOAod9VWOr
	 tHSV4jQan0r73Cfum/qrm7i3O47SV3hVFRww/2Go=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liam Beguin <liambeguin@gmail.com>,
	Andy Shevchenko <andy@kernel.org>,
	Hans de Goede <hansg@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 108/196] iio: consumers: Fix offset handling in iio_convert_raw_to_processed()
Date: Mon, 13 Oct 2025 16:44:59 +0200
Message-ID: <20251013144319.220696194@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

From: Hans de Goede <hansg@kernel.org>

[ Upstream commit 33f5c69c4daff39c010b3ea6da8ebab285f4277b ]

Fix iio_convert_raw_to_processed() offset handling for channels without
a scale attribute.

The offset has been applied to the raw64 value not to the original raw
value. Use the raw64 value so that the offset is taken into account.

Fixes: 14b457fdde38 ("iio: inkern: apply consumer scale when no channel scale is available")
Cc: Liam Beguin <liambeguin@gmail.com>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Signed-off-by: Hans de Goede <hansg@kernel.org>
Link: https://patch.msgid.link/20250831104825.15097-3-hansg@kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/inkern.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/inkern.c b/drivers/iio/inkern.c
index 34abbf46916cc..c7b2ab7870993 100644
--- a/drivers/iio/inkern.c
+++ b/drivers/iio/inkern.c
@@ -671,7 +671,7 @@ static int iio_convert_raw_to_processed_unlocked(struct iio_channel *chan,
 		 * If no channel scaling is available apply consumer scale to
 		 * raw value and return.
 		 */
-		*processed = raw * scale;
+		*processed = raw64 * scale;
 		return 0;
 	}
 
-- 
2.51.0



