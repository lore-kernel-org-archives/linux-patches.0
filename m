Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4738F23C8C7;
	Mon, 13 Apr 2026 17:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099648; cv=none; b=rLlzgwOLypyfqn4SLnC0qCekeq3wX+5wK2Ja1gw04C+kDlCp7drS/M6TYWjuCV1XA1nV/W3l48Kxko0VkSUzp0D6TRMVDvru88739ohanafAaTEQ/YPt9CMRGbQXblj7tima2WJyv9/hTm5s4Y7DDtwXIOIUrki7o7fcnEVYBro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099648; c=relaxed/simple;
	bh=skZMOsw5Wu/i8Rq4Et0Sx8j3//lRIrnqJ9YnEYJqjfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hDZ6lTr9JRbG0t7NRyQI9lBLRXSkhSQ0zl83ZQ76yXYfPhRmAQ3HxEvbLFmWnpyFvZ9VrjBCPsOe3pTcEZtAQTdMo//GFm1bYHvHcd6X1nWDPlEnzkjF3SkQamVXW1Cl1BQqyRfMAAbkRKb/0zbhErBDevvVSGRzP3lWUZ71x6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0emkXWAZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0emkXWAZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2BEDC2BCAF;
	Mon, 13 Apr 2026 17:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099648;
	bh=skZMOsw5Wu/i8Rq4Et0Sx8j3//lRIrnqJ9YnEYJqjfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0emkXWAZ04YDTXoORnNL61VHsBZcSoTRlzwwNWmV+nrB74NamjvFQCUUV2/Cg8DaP
	 Nv8g3UW10+QPpx/HceOXRs1dT8SpuzsLNevw6tlPqKynwvxqcQk47jQsRr+x9TEXsc
	 Zlm/1p66s0Gm5v6bSpg2ZT8hGvaZ6RenC4u4Jp58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.10 388/491] usb: ulpi: fix double free in ulpi_register_interface() error path
Date: Mon, 13 Apr 2026 18:00:33 +0200
Message-ID: <20260413155833.561801258@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit 01af542392b5d41fd659d487015a71f627accce3 upstream.

When device_register() fails, ulpi_register() calls put_device() on
ulpi->dev.

The device release callback ulpi_dev_release() drops the OF node
reference and frees ulpi, but the current error path in
ulpi_register_interface() then calls kfree(ulpi) again, causing a
double free.

Let put_device() handle the cleanup through ulpi_dev_release() and
avoid freeing ulpi again in ulpi_register_interface().

Fixes: 289fcff4bcdb1 ("usb: add bus type for USB ULPI")
Cc: stable <stable@kernel.org>
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260401025142.1398996-1-lgs201920130244@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/common/ulpi.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/usb/common/ulpi.c
+++ b/drivers/usb/common/ulpi.c
@@ -288,10 +288,9 @@ struct ulpi *ulpi_register_interface(str
 	ulpi->ops = ops;
 
 	ret = ulpi_register(dev, ulpi);
-	if (ret) {
-		kfree(ulpi);
+	if (ret)
 		return ERR_PTR(ret);
-	}
+
 
 	return ulpi;
 }


