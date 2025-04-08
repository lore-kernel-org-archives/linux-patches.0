Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E182686B1;
	Tue,  8 Apr 2025 11:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111663; cv=none; b=I2ZgE4H7qzxpxabqUtoZF00KLjrCYeq8i3nnu4RutEaaihGMvh1wXKeMt9YNP3SsrZZQkAy2aFKKTKO4/TXnPEcTxtwsU6FKZQxFcY+D+HtcT3Plg6fmvqBGvMfCe2mFLNlg4aW99AHaaOgKR+W+95vIZVDx3z7bTDZG1srS47E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111663; c=relaxed/simple;
	bh=DeFqJGqUD0I4cxqoEpqG/+JoqrzQd6un3ezyJYggyFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hN0Of+5EeGfeEu+gEcwOl525NeCXCdwL/UvF0OUkQmI6+82RuE1HTZO8PvUYEYp4X+fEkDqO8gyfZbdzMOSdLFI6Y2cq9JHAxAjlvI8hvuY4PQEyedv1iniZf4SFHdbt3hE6Mhmyp6QA6iDoqkJ6jxpKOw2OeK4ZqxFg1DienyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WietZowC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WietZowC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D955C4CEE7;
	Tue,  8 Apr 2025 11:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111662;
	bh=DeFqJGqUD0I4cxqoEpqG/+JoqrzQd6un3ezyJYggyFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WietZowCW2GPp9SWrmPmxT20xUrVhYng4H5G6GQF4OAmVCQSx97+lYWiWpVC95uU7
	 /KODFVm5VRsddnxgVdVwD7uSrIAjD3WEFpE5HFdz0CiVpNbMUa7YFe7r3ddx9tm/oo
	 RFWzdnLNVQEh65YQ/YDSojyQ1laMu78kc01d1HC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 473/731] iio: backend: make sure to NULL terminate stack buffer
Date: Tue,  8 Apr 2025 12:46:10 +0200
Message-ID: <20250408104925.281432258@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 3632812720352..aa2b8b38ab587 100644
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



