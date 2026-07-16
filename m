Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46DE2DF137;
	Thu, 16 Jul 2026 13:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209130; cv=none; b=L9JmWlGslS02mo+Z7tgyUNaBeNf7w5YldOB6F+0dVRP7s4E6cli22ZF8DZ8/GnwOibrM8F041jkgpzgf8CT8UvYmki8vOti/pC/MKtJvIHI+6waksB/R31N9T97XM8dG5doWiD/UmpJeBpsjaeSbJeJB+28/oWYdS+fPI90jUN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209130; c=relaxed/simple;
	bh=1nYMseNE6Xq3SvNS3fozHDG1Myh9M6u6SkLui3Mb6wA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qJqN2ob+9XZNYgFE2NxgT/XwMxm9L4Z+9/LBPiJeLVjj0rJY9diR4o9v1z8q1ImheU2NAY01GMJfEAbxW4+Xou5PjwW+myWg9wcBwUZylPx1hSI/TRXG/kgJuPkztt62cYEESzLdTEBUyDeUNPVYN5r5XFJBrLMF63Mi+PobssE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MNwuNSVy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MNwuNSVy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C55191F000E9;
	Thu, 16 Jul 2026 13:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209129;
	bh=Ff5nfTLY/euw7IdiXZSDdpuHFoNmk49e/UDZ7nSbPG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MNwuNSVyjdprB8vsFpuR9vq+lFEgzW/GoiD/WrfUJag1lhfOZv7rAHFK+RejPHaJv
	 SXR4X5pkZMVCNYvdz5kKm3iwxvR4gdo3qnwhQpVUquitJX0cTBXq9ed7Gfk6bWs89t
	 yR5DmYds4z7obL73NfYR4xuPx8Xfn7XXzTHdAhGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biren Pandya <birenpandya@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 7.1 066/518] iio: light: gp2ap002: fix runtime PM leak on read error
Date: Thu, 16 Jul 2026 15:25:34 +0200
Message-ID: <20260716133049.230000231@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biren Pandya <birenpandya@gmail.com>

commit 38b72267b7e22768a1f26d9935de4e1752a1dc85 upstream.

gp2ap002_read_raw() calls pm_runtime_get_sync() before reading the
lux value, but if gp2ap002_get_lux() fails, it returns directly. This
skips the pm_runtime_put_autosuspend() call at the "out" label,
permanently leaking a runtime PM reference and preventing the device
from autosuspending.

Replace the direct return with a "goto out" to ensure the reference
is properly dropped on the error path.

Fixes: f6dbf83c17cb ("iio: light: gp2ap002: Take runtime PM reference on light read")
Signed-off-by: Biren Pandya <birenpandya@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/gp2ap002.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/light/gp2ap002.c
+++ b/drivers/iio/light/gp2ap002.c
@@ -258,7 +258,7 @@ static int gp2ap002_read_raw(struct iio_
 		case IIO_LIGHT:
 			ret = gp2ap002_get_lux(gp2ap002);
 			if (ret < 0)
-				return ret;
+				goto out;
 			*val = ret;
 			ret = IIO_VAL_INT;
 			goto out;


