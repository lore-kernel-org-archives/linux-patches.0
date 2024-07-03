Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E04174EFF;
	Wed,  3 Jul 2024 10:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004273; cv=none; b=fF6pWnXHHRW5sDuSjeDaCyyBcRNhRjQOLypQq++fJas83ud5b2q4zc1XGJd5LmDQu5v6VlVGG0q1ZYHFPskF0UTJYHN1pkWEfKsCLXp2EWfnWC3jZCQsbm2Ilc8SrvNfRI6ZOsChS3wWa7CDqBXsrU3N5y5Ov5PmyL8AxZfDC1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004273; c=relaxed/simple;
	bh=ijMBnOcDz+qcS7AC9DucLFxg9+KNZEZVoow9YQmqEcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IjaCAwbiIn5ZgxicA84vgm7odIUDEEtk+JPhBBy/MXFjxwGUAGfVCNae1jMN2AIraf07OlEm1f2qmEJ9jlXM97o4weDNYKNrTgY3aFvRYA//zGjxLfOPTzfF2szQBmIL1E7mG6uUk1EUkBEX0gWJgea1Sxu3zo+lKY//lz9OK7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yG50d+yn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yG50d+yn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94AB9C2BD10;
	Wed,  3 Jul 2024 10:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004273;
	bh=ijMBnOcDz+qcS7AC9DucLFxg9+KNZEZVoow9YQmqEcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yG50d+ynyNP7f6+G5RKFa8CID6G8aalA8CymtV95xVGmiE9A1tw8BZWWepIoOqxZm
	 m8YB/zm+lifSZSt/NWp3Mc2TEOvAvcTuSQWWzI12gz0ZXVcFRosRuclYXwzLbaf6Cs
	 mwLQbwBihzIVu57dnYvhmWZsmtzEKxM23Ke/AeZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Yang <hagisf@usp.br>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 160/189] iio: adc: ad7266: Fix variable checking bug
Date: Wed,  3 Jul 2024 12:40:21 +0200
Message-ID: <20240703102847.508406336@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fernando Yang <hagisf@usp.br>

commit a2b86132955268b2a1703082fbc2d4832fc001b8 upstream.

The ret variable was not checked after iio_device_release_direct_mode(),
which could possibly cause errors

Fixes: c70df20e3159 ("iio: adc: ad7266: claim direct mode during sensor read")
Signed-off-by: Fernando Yang <hagisf@usp.br>
Link: https://lore.kernel.org/r/20240603180757.8560-1-hagisf@usp.br
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7266.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/adc/ad7266.c
+++ b/drivers/iio/adc/ad7266.c
@@ -159,6 +159,8 @@ static int ad7266_read_raw(struct iio_de
 		ret = ad7266_read_single(st, val, chan->address);
 		iio_device_release_direct_mode(indio_dev);
 
+		if (ret < 0)
+			return ret;
 		*val = (*val >> 2) & 0xfff;
 		if (chan->scan_type.sign == 's')
 			*val = sign_extend32(*val, 11);


