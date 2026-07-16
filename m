Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB9F400981;
	Thu, 16 Jul 2026 14:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211728; cv=none; b=HEb4cJsNr2RGcM1Vu+j8WpPjL56aq+OE6i51oUyJKjWs1tXAjtwqoEtJZnVPd0zQPMHpo+RPdTWjDG7CJpFWTOxxmo10Nqz0K/7+WfjWIyQxbIcieVzG6LaoFlLdWy8JcPhVdVSLpypt0TZKrvq4xzxGBFfyrrvYeBrOs7l9zBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211728; c=relaxed/simple;
	bh=RH/ax2Rsen/aLLlmtQMVW072O8Eo5qzfpw0zm3o/tQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hjJqomfzN6HZLQLX5fpJegHetuSmI5/aeLmBeivH6WRJ0XHpWCvTy84SwuLe9UynmVhGBY5EguPLTBT9gXFqZFJl7i78Gzp+BBHg9QMR/eDHuqukucuzghUrs4BNzPwnTILQ6XCBShKDYUh7n+aV5uLp0UFOAKr4ZZBIogFYQ50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=boFE0e8C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="boFE0e8C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B9BD1F000E9;
	Thu, 16 Jul 2026 14:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211726;
	bh=ldhiiht+I/o0IqSNygteylzXe8rvM8oQ1fjMttAaGNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=boFE0e8CmUd0QRzvOH5BdtDnJk60qy/23pzsXPtssXNo2VjO1SVPJcU62W4/48n6y
	 ZHLr6Y0tJ09lwpVu11VUnEdy2u+ugEqXM3A37yzauwFxuoSv8yXFnxqTPLy7v2XnDV
	 EoIeCp+bO4fi5T85fuNvL55t24asCU/jcXAf1ZD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.12 050/349] iio: backend: fix uninitialized data in debugfs
Date: Thu, 16 Jul 2026 15:29:44 +0200
Message-ID: <20260716133034.443299487@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

From: Dan Carpenter <error27@gmail.com>

commit a6e8b14a4897d0b6df9744f33d0a30e6b92368eb upstream.

If the *ppos value is non-zero then simple_write_to_buffer() will not
initialize the start of the buf[] buffer.  Non-zero ppos values aren't
going to work at all.  Check for that at the start of the function and
return -ENOSPC.

Fixes: cdf01e0809a4 ("iio: backend: add debugFs interface")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-backend.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/industrialio-backend.c
+++ b/drivers/iio/industrialio-backend.c
@@ -155,7 +155,7 @@ static ssize_t iio_backend_debugfs_write
 	ssize_t rc;
 	int ret;
 
-	if (count >= sizeof(buf))
+	if (*ppos != 0 || count >= sizeof(buf))
 		return -ENOSPC;
 
 	rc = simple_write_to_buffer(buf, sizeof(buf) - 1, ppos, userbuf, count);


