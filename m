Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0793264D7;
	Mon, 13 Apr 2026 16:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099545; cv=none; b=oFhRYJwJ5KkuEaprXPRCCEpztLt6BP3LpHZcIP9albcD22WuP1T550HmoMlAUcrbv0Uos3z05hCgmiqQyXXKHlr0riXSu8bvnT4npAAhk+k+qZXyQ5k1Sn27T1DYDOjE2WUCo0jyy0WF6k5+ARdffC79noKSXUtAl5sWbhHWa4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099545; c=relaxed/simple;
	bh=Lo7wLq6umeCZCLcBFNCGiboPeMcdcaVutpAAcpz+l2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uPADRqZw3mG++Qd1nOnvPVQnjE8remh5qTxvLJxnshmo9YH1vdN2JyTjoj90Q/aj1cxIInyhuEs4TCMhY2C1p2icG8VsW2lUzxW1qt6wofVjt5tEXSc0q8WF2ef1DwRk6kJkRK5j//x/Fty/WwbQakvIEIOa+SMO/4lMFlCnB4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b70h4OXC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b70h4OXC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14609C2BCAF;
	Mon, 13 Apr 2026 16:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099545;
	bh=Lo7wLq6umeCZCLcBFNCGiboPeMcdcaVutpAAcpz+l2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b70h4OXCbJmvCU+YA7clMq0F9k0VPFcHB89jHaK2FD6SxekkwH3WeTwrLQhJiptfJ
	 naJ3c2Dqbo98XcVbp099/AVJpbBsjApZEiSWmd93KSEUBMdLxwSqjA4q6C1TlhqZxs
	 6HPC45eeGaZY4JLAhwBp4EwPMdfKCgcOLIPLubfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 380/491] iio: dac: ad5770r: fix error return in ad5770r_read_raw()
Date: Mon, 13 Apr 2026 18:00:25 +0200
Message-ID: <20260413155833.258980739@linuxfoundation.org>
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

From: Antoniu Miclaus <antoniu.miclaus@analog.com>

commit c354521708175d776d896f8bdae44b18711eccb6 upstream.

Return the error code from regmap_bulk_read() instead of 0 so
that I/O failures are properly propagated.

Fixes: cbbb819837f6 ("iio: dac: ad5770r: Add AD5770R support")
Signed-off-by: Antoniu Miclaus <antoniu.miclaus@analog.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/ad5770r.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/dac/ad5770r.c
+++ b/drivers/iio/dac/ad5770r.c
@@ -323,7 +323,7 @@ static int ad5770r_read_raw(struct iio_d
 				       chan->address,
 				       st->transf_buf, 2);
 		if (ret)
-			return 0;
+			return ret;
 
 		buf16 = st->transf_buf[0] + (st->transf_buf[1] << 8);
 		*val = buf16 >> 2;


