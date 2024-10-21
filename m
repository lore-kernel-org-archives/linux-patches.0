Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC071E47B4;
	Mon, 21 Oct 2024 10:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506740; cv=none; b=hVQAfktltp0nmJpK9RGs4WN3te4S9Av9tCaOstWXFNc1yPxlokRiFVKXBfVozPWa3jpaFh56ARljaGutnPeGXvCPrvsLaDz+NYrLMUPx9oDKJD1SiKz1gf4D9kW5JYdGEswUOL8k92OY2pSnu9/PtDUP0SsKoPy2yrj59X/Hwjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506740; c=relaxed/simple;
	bh=Y7MJ6nSCaU8o4CB8ZLJ59GGkv7FJ+Z0cfW2eEmTaT5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hpx1TAqaEQzb4EMKS21S4zwtR0jf7PBSgEZGWSgJ4oI6/le8uQvs73enEQwFvmMuQgL9hQXY04lsVot3izFjnkY1dLAsi6S4YyoZWVqEVcjKtG7Q92PxtEGRFbzWh2UQwx0XV3wLweUsQ2r8XLCo7R4V/E4OxJwWIxMspu3c9vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SxxrwIJi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SxxrwIJi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2E68C4CEC3;
	Mon, 21 Oct 2024 10:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506740;
	bh=Y7MJ6nSCaU8o4CB8ZLJ59GGkv7FJ+Z0cfW2eEmTaT5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SxxrwIJiP0InQNIK3UXeQA/oKS2bWjdmHMnbSkf3u0DbZx5Mm2xcuk1cqL7EGeGJc
	 +LI5C8ClnGvhYS4rN4/0djdtyJsrtktU2SeaB5Y1nmJh0AZ1WnzSHbRQWhjqdUD9/m
	 f7lL5bYE/nLicFHKN+8uGzlWpOgFB8xlSqsZqwwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.11 074/135] iio: hid-sensors: Fix an error handling path in _hid_sensor_set_report_latency()
Date: Mon, 21 Oct 2024 12:23:50 +0200
Message-ID: <20241021102302.224335499@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit 3a29b84cf7fbf912a6ab1b9c886746f02b74ea25 upstream.

If hid_sensor_set_report_latency() fails, the error code should be returned
instead of a value likely to be interpreted as 'success'.

Fixes: 138bc7969c24 ("iio: hid-sensor-hub: Implement batch mode")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://patch.msgid.link/c50640665f091a04086e5092cf50f73f2055107a.1727980825.git.christophe.jaillet@wanadoo.fr
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/common/hid-sensors/hid-sensor-trigger.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/common/hid-sensors/hid-sensor-trigger.c
+++ b/drivers/iio/common/hid-sensors/hid-sensor-trigger.c
@@ -32,7 +32,7 @@ static ssize_t _hid_sensor_set_report_la
 	latency = integer * 1000 + fract / 1000;
 	ret = hid_sensor_set_report_latency(attrb, latency);
 	if (ret < 0)
-		return len;
+		return ret;
 
 	attrb->latency_ms = hid_sensor_get_report_latency(attrb);
 


