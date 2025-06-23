Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7297022156B;
	Mon, 23 Jun 2025 21:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714228; cv=none; b=jjoOkD7fdCJF5SrNxUfFMTFcQ9GsKrt39SlqPbKeHDJxg4sJFpbeCoSXmF+4PRTYh0aI0XoRgMQkKkPLGH/+k9N6wySz01OOtOtPh1lO/QVIUWkVRlqYv7RZtmckJPyNoJNegsb/4raX0Rf0BQtIphA3XRZ2UPafn39K4Fim6t4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714228; c=relaxed/simple;
	bh=T301ESbOih4yi2wHzSfIP/HE1C9qAlWtyqhG8l/vi1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OzvzsJRvMlyDhRa+7WM6cZANcc1pYA7Iru4xsf105MBbtUlX4mB5hVCo7WdqhreSpY7PvJLFulWhbyyfi1lwd/ErHJ+RA0sRvuE24zqrHWttLhl1vTtGMLArXu7D5nOK3OseQh0f49TEzGLwo802a6S5hgyjbMtsBkI0MK/dUo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FGl5Yz75; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FGl5Yz75"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A6DC4CEEA;
	Mon, 23 Jun 2025 21:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714228;
	bh=T301ESbOih4yi2wHzSfIP/HE1C9qAlWtyqhG8l/vi1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FGl5Yz75hgh+LLi2JBTZZiUjSyn9N/nIl7GKs4/jyZYDKbdADPqu3n490DdbHF5+g
	 BsSF5BJtLIfUyho4s9iXwLxIunOEHd1yweZP88XeV03Ay6BO8C1QEeCX4r3jNOfip/
	 sUoPnQ9ZOAMeh5MIPhMnxgJ4HetUHYV0bP8nlAvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Winchenbach <swinchenbach@arka.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 159/508] iio: filter: admv8818: fix integer overflow
Date: Mon, 23 Jun 2025 15:03:24 +0200
Message-ID: <20250623130649.190566248@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

From: Sam Winchenbach <swinchenbach@arka.org>

[ Upstream commit fb6009a28d77edec4eb548b5875dae8c79b88467 ]

HZ_PER_MHZ is only unsigned long. This math overflows, leading to
incorrect results.

Fixes: f34fe888ad05 ("iio:filter:admv8818: add support for ADMV8818")
Signed-off-by: Sam Winchenbach <swinchenbach@arka.org>
Link: https://patch.msgid.link/20250328174831.227202-4-sam.winchenbach@framepointer.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/filter/admv8818.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/filter/admv8818.c b/drivers/iio/filter/admv8818.c
index a50a8ea2f8dda..831427aa89d83 100644
--- a/drivers/iio/filter/admv8818.c
+++ b/drivers/iio/filter/admv8818.c
@@ -152,7 +152,7 @@ static int __admv8818_hpf_select(struct admv8818_state *st, u64 freq)
 	}
 
 	/* Close HPF frequency gap between 12 and 12.5 GHz */
-	if (freq >= 12000 * HZ_PER_MHZ && freq <= 12500 * HZ_PER_MHZ) {
+	if (freq >= 12000ULL * HZ_PER_MHZ && freq < 12500ULL * HZ_PER_MHZ) {
 		hpf_band = 3;
 		hpf_step = 15;
 	}
-- 
2.39.5



