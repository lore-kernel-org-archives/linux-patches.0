Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4E3439325;
	Tue, 21 Jul 2026 21:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670959; cv=none; b=fYrclnudPl85DkFd7A3mB18gtG28hY1MfRowOBTJWI+XgDUhb2FNp2BqvZUuR30FtWYzSnwbr7UkPy+QCKAqrqVfnTVk4NajjYPWyf/X3iBzPqsmF7UD+WpY8FXlUXxOPoJUmb8QTwapVdkMHstLekgXeaAM7ET9O3ftzqq+YgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670959; c=relaxed/simple;
	bh=hzGVj4D5h6FeJf9ZUNYUdf9UtEhChLJtBwMFqoMeZyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rSy9Mt4UapweL3ZgeelUMiseT0fbVTPH9XgDB8FpPMpKXfmhDoSc0gd/38oGhqVlfXNKYsjq0Bb19EyrZ6YJufbp2fMgMa0+GwSWhWeojsC6+kmkHOYbja6W+I0DBGfUK2OiowMK2IslOry0S44FC10nKqu36RhuqPG25qe1/cQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qAZ2yOjz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qAZ2yOjz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F25F21F000E9;
	Tue, 21 Jul 2026 21:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670958;
	bh=5nI3kyRrqMGb8Ha39eJU7hNtyRymwRdjxZ4CgsuOQDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qAZ2yOjzID1rIr9rkULTdSA/dXWWBL+ChO/x3oeKo9g0cBQdy4eV2CBvuvbgVcu1m
	 bRrE8pDuTRHMph4jK0+zW7MbWEwJ7WLcbgM35qzqeMKZBMjsdVCRX5Y8BdVjsS1lZT
	 q3C1Yz2FZvoGFvU/sxD/c+Zu4FaUrNHEB48nPczI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 5.15 064/843] iio: magnetometer: ak8975: Add missed pm_runtime_put_autosuspend() call
Date: Tue, 21 Jul 2026 17:14:59 +0200
Message-ID: <20260721152407.428519060@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit e94944d7364d3ddb273539492f9bd9c9a622549a upstream.

On the failure in the ak8975_read_axis() the PM runtime gets unbalanced.
Balance it by calling pm_runtime_put_autosuspend() on error path as well.

Fixes: cde4cb5dd422 ("iio: magn: ak8975: deploy runtime and system PM")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260505-magnetometer-fixes-v5-0-831b9b5550fc%40gmail.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/magnetometer/ak8975.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/magnetometer/ak8975.c
+++ b/drivers/iio/magnetometer/ak8975.c
@@ -715,6 +715,7 @@ static int ak8975_read_axis(struct iio_d
 
 exit:
 	mutex_unlock(&data->lock);
+	pm_runtime_put_autosuspend(&data->client->dev);
 	dev_err(&client->dev, "Error in reading axis\n");
 	return ret;
 }


