Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ACA028D8DB;
	Wed, 28 Jan 2026 16:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769616156; cv=none; b=cAhyupJMARySSoNJB8XtC2HcPmbMYGu2KCcxJd0W0+aTzEupRXrqA0sWjg0/nVQWWOPy14KFixH3p81MpAcMyE/UIPRXbZsUlhc5ybiRV6403kR6DegaI9b1022JgybNbR1VUsK1AjfrTbw3OqOLVM0l4+8H8IR9pjgI9nrtTGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769616156; c=relaxed/simple;
	bh=sEfuu5oGBO7SHBixBmEzj15A4nT/Femq/xOcjrs8Quw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ElgcMzNrjAWtucs906ctS3L0P2MJjriGxQTpg7t5mqMsEqDuYpncpQ2O2byq+u8BJuciS9rxxOctZXtWwrtZJ5+CIN4Z9r4iEq+ccLmjvWReMgWLOJrNPliHKdgCGkWLZqhs9UV+wxBiQMbn4I+xzvnp9/EU3FIi73MK7l7i+dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=osKwGYm6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="osKwGYm6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BF6FC4CEF7;
	Wed, 28 Jan 2026 16:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769616156;
	bh=sEfuu5oGBO7SHBixBmEzj15A4nT/Femq/xOcjrs8Quw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=osKwGYm6+XIaKJwg8QQmMUCMHdTatyxrLl5RY2k8YMXNDTVmRJTnM1ZfG+PkYOg4O
	 fzFiIoRK1kkp15y+KP/mcl65O8TOQMtVVUwgmR9c5pGSKDh/ynO5RbSAkUhvAzHQ3x
	 Zgc0QFdgHzJCGGA5PgkMALTGwlx27sL4voH4ET0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 222/227] iio: core: Replace lockdep_set_class() + mutex_init() by combined call
Date: Wed, 28 Jan 2026 16:24:27 +0100
Message-ID: <20260128145352.422467257@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit c76ba4b2644424b8dbacee80bb40991eac29d39e ]

Replace lockdep_set_class() + mutex_init() by combined call
mutex_init_with_key().

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 9910159f0659 ("iio: core: add separate lockdep class for info_exist_lock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-core.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -1717,9 +1717,8 @@ struct iio_dev *iio_device_alloc(struct
 	INIT_LIST_HEAD(&iio_dev_opaque->ioctl_handlers);
 
 	lockdep_register_key(&iio_dev_opaque->mlock_key);
-	lockdep_set_class(&iio_dev_opaque->mlock, &iio_dev_opaque->mlock_key);
 
-	mutex_init(&iio_dev_opaque->mlock);
+	mutex_init_with_key(&iio_dev_opaque->mlock, &iio_dev_opaque->mlock_key);
 	mutex_init(&iio_dev_opaque->info_exist_lock);
 
 	indio_dev->dev.parent = parent;


