Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591370;
	b=ybDXILef6fNZ+2RmFSKCH5WD0bkH+cXUZ4viyzUZeiDVdVQcn443jO1uDQFKCFQ0RnMn
	 5CL17bQEQNMN0DFmvGxHebyjXNYHeiySOC4q/DhNgXqA9J4kqyolrwiogVkkuUsoyATFR
	 i1QBClJ8V02S5Syl8PQACBUojaFlSjYVjuaHOsT6FnB0WAgbyusQtOT4N/I+XZBdCc/0h
	 qlYanu5wWyzXcU7TkpIwKT4rz75g7crSk8xqWKkvTRYiIApfG47Q1+CmxYMm0mk2cxCga
	 UADlxSUn740V8iNDD7X3lO/Qxk5hKlXD0jTlPRJmwOROW3btmwVxtWUjtZtL2REEYpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591370;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Xq1TZTCsTvXrphkkhoI0gLnIhEscB4zbVek/qj9WVNQ=;
	b=K/+8sELLGmFwWD9z7bgHvzMYhagzXn0soo7pBpqN3pCXSJ1RJ37N+4XOq+DK6PBA4FjH
	 DJ0yTV7CNSzT0ocqS+RyOAljw7gZVrhqLapSEPXziNrD/KTXqTScm8mI0ye8CRzi29Sok
	 IIuFDQvZ9+oGzj4U+nPWeH/+iOsVFV7junkFKp+PwP6IDHADvVv15mk/I50YhXnpCize6
	 lYP7EVuT5JSUMJO/zgcKIWQqCWIXHNGJkY2+eogKcSlw8D84FkWCEs10zHs4LDbnbYXko
	 LrVO1UqfZhulvwvaHfUbua6OrzRwfZU2ESTvSoVLoPRXKdjZ53qnfcNiTxMuLEvyxhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FOcwCQoK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588AA606EDA6;
	Fri, 13 Nov 2026 17:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FOcwCQoK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAE3D1F000C4;
	Fri, 13 Nov 2026 17:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591370;
	bh=Xq1TZTCsTvXrphkkhoI0gLnIhEscB4zbVek/qj9WVNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FOcwCQoKCdB7Vo1SOfLpucc6jsNmo6bTStsnHalrH73BvSm2TzerUoACCuzn5GgN5
	 HaVzB0oaZuOyVvi2pDRhM+tPo66lyXfwfzLrOiqgDqjwoSGBWgjqudAKQBEHYwC1Cz
	 qxChJWze812E4/Na/ChIqt/UcDpoKCCBnC0Q25oY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Fabio Cesari <fabio.cesari@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 430/670] iio: light: isl29028: fix runtime PM reference leak on error paths
Date: Fri, 13 Nov 2026 10:49:54 -0500
Message-ID: <20261113153826.317565351@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Cesari <fabio.cesari@gmail.com>

[ Upstream commit 0e30d15b15647df786e60022650613e16dd70645 ]

isl29028_read_raw() and isl29028_write_raw() take a runtime PM reference
with pm_runtime_resume_and_get() but return directly on their error
paths without dropping it. The usage count never balances again and the
device stops entering autosuspend for good. In isl29028_read_raw() this
needs a regmap access to fail; in isl29028_write_raw() one rejected
sysfs write is enough, for example

  echo 200 > in_proximity_sampling_frequency

which is outside the [1:100] range and returns -EINVAL with the
reference still held.

Take the reference with PM_RUNTIME_ACQUIRE_AUTOSUSPEND() instead, so it
is released on every return path.

This also stops the return value of pm_runtime_put_autosuspend() from
reaching userspace. That value only says whether the device could be
suspended right away, so -EAGAIN or -EPERM turns a successful access
into a failure, and with CONFIG_PM=n the stub returns -ENOSYS on every
access.

Fixes: 2db5054ac28d ("staging: iio: isl29028: add runtime power management support")
Suggested-by: Joshua Crofts <joshua.crofts1@gmail.com>
Cc: stable@vger.kernel.org
Assisted-by: LLM coccinelle
Signed-off-by: Fabio Cesari <fabio.cesari@gmail.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
[ sashal: replaced unavailable PM_RUNTIME_ACQUIRE_AUTOSUSPEND() guards with explicit cleanup through the existing isl29028_set_pm_runtime_busy() helper ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/isl29028.c | 23 ++++-------------------
 1 file changed, 4 insertions(+), 19 deletions(-)

diff --git a/drivers/iio/light/isl29028.c b/drivers/iio/light/isl29028.c
index a23b2af287d5e..12708bc351508 100644
--- a/drivers/iio/light/isl29028.c
+++ b/drivers/iio/light/isl29028.c
@@ -407,14 +407,9 @@ static int isl29028_write_raw(struct iio_dev *indio_dev,
 
 	mutex_unlock(&chip->lock);
 
-	if (ret < 0)
-		return ret;
+	isl29028_set_pm_runtime_busy(chip, false);
 
-	ret = isl29028_set_pm_runtime_busy(chip, false);
-	if (ret < 0)
-		return ret;
-
-	return 0;
+	return ret;
 }
 
 static int isl29028_read_raw(struct iio_dev *indio_dev,
@@ -423,7 +418,7 @@ static int isl29028_read_raw(struct iio_dev *indio_dev,
 {
 	struct isl29028_chip *chip = iio_priv(indio_dev);
 	struct device *dev = regmap_get_device(chip->regmap);
-	int ret, pm_ret;
+	int ret;
 
 	ret = isl29028_set_pm_runtime_busy(chip, true);
 	if (ret < 0)
@@ -476,17 +471,7 @@ static int isl29028_read_raw(struct iio_dev *indio_dev,
 
 	mutex_unlock(&chip->lock);
 
-	if (ret < 0)
-		return ret;
-
-	/**
-	 * Preserve the ret variable if the call to
-	 * isl29028_set_pm_runtime_busy() is successful so the reading
-	 * (if applicable) is returned to user space.
-	 */
-	pm_ret = isl29028_set_pm_runtime_busy(chip, false);
-	if (pm_ret < 0)
-		return pm_ret;
+	isl29028_set_pm_runtime_busy(chip, false);
 
 	return ret;
 }
-- 
2.53.0



