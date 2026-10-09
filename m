Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F804C6507;
	Fri,  9 Oct 2026 14:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557433; cv=none; b=K3IFzvEbvZ9sskNBMWWcbbKZZQvlUnlSTZPynVWQjpDBTBJfkbjtKhoX1GUogsYKOFbz6EUdjcASNrf+mRc6g1QHH+m9o5YJOALpR2nDUNFc34qxul+pduTUwPUOABTDAH1gsdRXosTFqotperTKwXfln0HVjEtzCVtQZVO7c3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557433; c=relaxed/simple;
	bh=1xjt78oxAPY5c+rBLp+3zypKW9BUNexK2+9ZmUQDMQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PyJ/Wsc0I6g6dV5w0cWJQJvYOfPed74adrBajHWByQw8mQ3TZZm/KMx7lWU1JY4qtNMyT8X7iJHvDLYovKTP7jeaAhadexblIN7h0imXyAesQvIvReMiDaSsaC0Y2AVMNxcRp9ZChvSRvJmxl/tMpL5ZOW7t23gBKVB4EX9/u5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bao9T4n3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bao9T4n3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 810101F000FF;
	Fri,  9 Oct 2026 14:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557432;
	bh=422sv3UIX06Tgag5buucm1FKprq0cDBVKNTj4o088sc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bao9T4n3xdFZswZgz4gYLRlKLSOpg4MGAXBqbw+l7LI26+4Z+dBXvtZHH0N0S2/WQ
	 WHjP0Y9tONaM07znxNBn9y0XFoKIcHO5stMDPz1G3z4yi5iQvBAxvoz8DdmW9k6Jjp
	 rZ8shjINQ9HejQ8BRGnRrDvHSDN960nDBipKhEMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Janani Sunil <janani.sunil@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 403/403] iio: adc: adi-axi-adc: Initialize state mutex
Date: Fri,  9 Oct 2026 16:12:44 +0200
Message-ID: <20261009141001.789700681@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Janani Sunil <janani.sunil@analog.com>

[ Upstream commit 549b71ce050637dd32678371ad76c445a2f8c9aa ]

The AXI ADC register access paths serialize transactions with st->lock,
but probe does not initialize it. Initialize the mutex before registering
the backend.

Fixes: 7ecb8ee5c93b ("iio: adc: adi-axi-adc: support digital interface calibration")
Signed-off-by: Janani Sunil <janani.sunil@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/adi-axi-adc.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/iio/adc/adi-axi-adc.c
+++ b/drivers/iio/adc/adi-axi-adc.c
@@ -715,6 +715,10 @@ static int adi_axi_adc_probe(struct plat
 	if (!st)
 		return -ENOMEM;
 
+	ret = devm_mutex_init(dev, &st->lock);
+	if (ret)
+		return ret;
+
 	base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(base))
 		return PTR_ERR(base);


