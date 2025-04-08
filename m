Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C1226A095;
	Tue,  8 Apr 2025 12:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116653; cv=none; b=EJAlm8TqXFntlETWNKx3BaclyHt2cgsWwEhtU+GvDcS7twUvmFIo0iLsw+LVBEeMAfbzl7Ida/oCH0z69UxOXhlFO0nFUBcVHupNc5GbRHCYbya6Ob1wSlSA/3R//X/+whiOjMmVh/R1DuJOcnWTk6vdb86AVKTPiXzUa6xrYic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116653; c=relaxed/simple;
	bh=JdwEUuG8J5JlDVR1bZ63sy+7d2CG3ETRBFbG6SskJRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ucMJOedUhcaPU0a15rrGBKdHKQGwhVaJa+KasrPcrHPEn8t+O0XCdyRs8Au8piOgBp9ZK3Hqjr6qINGx48NeuS8U7nW/bihXsRxUulxe8U9hOrYNlxJwCPUOQ5a8C4w4CtRw2nhqiWx6WDq7QEVtxdX+rkiIihlVuC+60BIlrAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ND/Mf1Zy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ND/Mf1Zy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3E49C4CEE5;
	Tue,  8 Apr 2025 12:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116653;
	bh=JdwEUuG8J5JlDVR1bZ63sy+7d2CG3ETRBFbG6SskJRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ND/Mf1ZyMy5i9m9lJbbzYm3Yaue57UfsaWJaTyP8imRqKsBkz5JrKGxo6oOmL5j3F
	 0mK2ZonaoB2IdSPkkeVrAuEbbl8E3oLbdL108Udmic2McvxORiMpu4dqEej98xjRcz
	 VpC4+q/hVnNwErV2tG1LUTC57r5p2EJeVGENip/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 180/423] iio: backend: make sure to NULL terminate stack buffer
Date: Tue,  8 Apr 2025 12:48:26 +0200
Message-ID: <20250408104849.934950927@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Sá <nuno.sa@analog.com>

[ Upstream commit 035b4989211dc1c8626e186d655ae8ca5141bb73 ]

Make sure to NULL terminate the buffer in
iio_backend_debugfs_write_reg() before passing it to sscanf(). It is a
stack variable so we should not assume it will 0 initialized.

Fixes: cdf01e0809a4 ("iio: backend: add debugFs interface")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Link: https://patch.msgid.link/20250218-dev-iio-misc-v1-1-bf72b20a1eb8@analog.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/industrialio-backend.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/industrialio-backend.c b/drivers/iio/industrialio-backend.c
index fb34a8e4d04e7..42e0ee683ef6b 100644
--- a/drivers/iio/industrialio-backend.c
+++ b/drivers/iio/industrialio-backend.c
@@ -155,10 +155,12 @@ static ssize_t iio_backend_debugfs_write_reg(struct file *file,
 	ssize_t rc;
 	int ret;
 
-	rc = simple_write_to_buffer(buf, sizeof(buf), ppos, userbuf, count);
+	rc = simple_write_to_buffer(buf, sizeof(buf) - 1, ppos, userbuf, count);
 	if (rc < 0)
 		return rc;
 
+	buf[count] = '\0';
+
 	ret = sscanf(buf, "%i %i", &back->cached_reg_addr, &val);
 
 	switch (ret) {
-- 
2.39.5



