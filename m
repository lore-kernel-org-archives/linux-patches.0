Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB18156644;
	Wed, 15 Jan 2025 10:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938398; cv=none; b=KcTLA1D6kngb4DRhTb3kuW4CxS+Kpw+YyUVr2mbZyC5lbIKj2t42ZDhFlxw/SSIIOx6ih8dCiPhZRpiveuGDkXO23Nhf1/eh7mas5kLOGObERRyK6j1RV/kiDnhUvb5REounR36eOvl8HlmbknC/BeLrZs4XzGdyLFu/yC9OWks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938398; c=relaxed/simple;
	bh=Xa/C3llAE+j0FPat1/+bMn3UWXpF/EomPRiFWcVYZE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J9qVYYyOlDsem4+1EL9OGUycnuXAEZeXnbInJBvgz1MnL8lbpk74tFwcP3w822BcSmZ7UKzqgdAjJunLFwdflDYvsyFBvumhkhzBOq0g5dHIKU5EARNqg7tkfZ0mqfQyDnXYRZv5eEiFYUqajqKf6GXUvdfFTuYGUuLZbc8ZLrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FD4PovQ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FD4PovQ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DB93C4CEDF;
	Wed, 15 Jan 2025 10:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938397;
	bh=Xa/C3llAE+j0FPat1/+bMn3UWXpF/EomPRiFWcVYZE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FD4PovQ8ZnVe8hy/Vd3LlPdN0l71qBTzV8AIaJ3SJkyUk9XOB8+E10CW+z6VM0UKX
	 d0zMZinf1RMIv3IE9JtuJegn2bUow+TcQYQasRCQ8FYB2aDMck3pAANpRZ1Loo8p2D
	 sbNipz1YWO86M5q+A6Ha13yUEJ0eGK+FvxyWoIY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 171/189] iio: inkern: call iio_device_put() only on mapped devices
Date: Wed, 15 Jan 2025 11:37:47 +0100
Message-ID: <20250115103613.231278101@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

commit 64f43895b4457532a3cc524ab250b7a30739a1b1 upstream.

In the error path of iio_channel_get_all(), iio_device_put() is called
on all IIO devices, which can cause a refcount imbalance. Fix this error
by calling iio_device_put() only on IIO devices whose refcounts were
previously incremented by iio_device_get().

Fixes: 314be14bb893 ("iio: Rename _st_ functions to loose the bit that meant the staging version.")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Link: https://patch.msgid.link/20241204111342.1246706-1-joe@pf.is.s.u-tokyo.ac.jp
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/inkern.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/inkern.c
+++ b/drivers/iio/inkern.c
@@ -499,7 +499,7 @@ struct iio_channel *iio_channel_get_all(
 	return_ptr(chans);
 
 error_free_chans:
-	for (i = 0; i < nummaps; i++)
+	for (i = 0; i < mapind; i++)
 		iio_device_put(chans[i].indio_dev);
 	return ERR_PTR(ret);
 }


