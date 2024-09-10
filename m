Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC02E190056;
	Tue, 10 Sep 2024 10:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964600; cv=none; b=oInjqypsWWbGjkCtGCspXt2WzcY8ThTTMTcmX11vrOaitD1hV3vl9Tsig8jZfm8Q/wIbkjcmAHX8zQTOJxzbxDrR/7vZXZJWiYo6px4JlAvizZdyg4IkMAeLvAFnTlx8JJbdhqE2JoP10FzH69Rdq8KqNSDjCkyT5wtCxMExIWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964600; c=relaxed/simple;
	bh=8mkKRW92D3VcBti5yddysPtJpuHqDG0VF0y4v6Byiiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AOkZaQXqPjuiL802dqQyXfxRP6xfNzMLY3MbgE8vJRIxVnvkrQqqXBvj5jhhWUGSTDD3a/dRl8pKbbJ+0+/uPy2ccLbyhT61y1WN4Y14svj15Y+kmDxWxYaWHMOXplIJkZKPWGI54dgyurG8rwr+szbYU1PqzoG9Jnstgao2RcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y/qwRDqI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y/qwRDqI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39EDBC4CEC3;
	Tue, 10 Sep 2024 10:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964600;
	bh=8mkKRW92D3VcBti5yddysPtJpuHqDG0VF0y4v6Byiiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y/qwRDqI26ddSlc+cyq0XXZyN3wOI+chDXrMEc/h8jC0DfXjYzChqd3fABrFZpy7u
	 umm2S316uMQvXDRQnffsiYY38LTy1VtbUHC/8IspI4jZ+PHPcdknaY49PU/kxI3BwW
	 fFGRCBYiTXllXV1jXuQa6RIzRUEFLwWIVYQoZ0UU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dumitru Ceclan <dumitru.ceclan@analog.com>,
	Nuno Sa <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 210/269] iio: adc: ad7124: fix chip ID mismatch
Date: Tue, 10 Sep 2024 11:33:17 +0200
Message-ID: <20240910092615.514080133@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dumitru Ceclan <mitrutzceclan@gmail.com>

commit 96f9ab0d5933c1c00142dd052f259fce0bc3ced2 upstream.

The ad7124_soft_reset() function has the assumption that the chip will
assert the "power-on reset" bit in the STATUS register after a software
reset without any delay. The POR bit =0 is used to check if the chip
initialization is done.

A chip ID mismatch probe error appears intermittently when the probe
continues too soon and the ID register does not contain the expected
value.

Fix by adding a 200us delay after the software reset command is issued.

Fixes: b3af341bbd96 ("iio: adc: Add ad7124 support")
Signed-off-by: Dumitru Ceclan <dumitru.ceclan@analog.com>
Reviewed-by: Nuno Sa <nuno.sa@analog.com>
Link: https://patch.msgid.link/20240731-ad7124-fix-v1-1-46a76aa4b9be@analog.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7124.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/adc/ad7124.c
+++ b/drivers/iio/adc/ad7124.c
@@ -765,6 +765,7 @@ static int ad7124_soft_reset(struct ad71
 	if (ret < 0)
 		return ret;
 
+	fsleep(200);
 	timeout = 100;
 	do {
 		ret = ad_sd_read_reg(&st->sd, AD7124_STATUS, 1, &readval);


