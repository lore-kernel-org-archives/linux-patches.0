Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C521EF956;
	Mon, 21 Oct 2024 10:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507645; cv=none; b=YfbAZoSIj5kVCNB82f52yAvM1Kkl0j+YsrNW/3VvYyTo4VDrF6uuM8wfHvl1XuLx+SRzPKD+zFur/3WKohxIUPJ01BQtTNnxey7oB4DgaYSKPncKfRFu+5hF3mSrbw6R5BeAusfWZ2GUw03LCzu8ioBsPgje5gC5ooPgdBeyZNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507645; c=relaxed/simple;
	bh=Jzai1SnUin9rDpQLgBea8ywPQ3xytzN97MwICr8vTRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bd5h9OpJMSx2as8wOc6Vj64y8al99ByUhzqYHUZpa/7jMg97m/MEGFNMiv45skZnngWnTVTQTbCAks6LHWbrBgucjd63wzSTXSAEfLGUM+fwJJ1ZePIrJ+RdlE7t1Y6iJFEwd0gJ+WnyrN9r+FraqojeLmvn7goPETTm6Tms5Bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bmT62oPD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bmT62oPD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22595C4CEC3;
	Mon, 21 Oct 2024 10:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507645;
	bh=Jzai1SnUin9rDpQLgBea8ywPQ3xytzN97MwICr8vTRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bmT62oPDI4Y1bX30C7MVYYHuLWhQmR0bNvZ/pWWdBn82L3/g40NIkkwYkg8Ocqfa7
	 dZHeCO2vUxJ3+ZFguEo4w0n55/MKn08XV08ugl91V6HEuNYtTe18ZiCBAuKPfW5U/D
	 Z4so9mmtUSM/c+oIQzQgXWTyDkoLjCbo4j7lpAl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 55/82] iio: hid-sensors: Fix an error handling path in _hid_sensor_set_report_latency()
Date: Mon, 21 Oct 2024 12:25:36 +0200
Message-ID: <20241021102249.408887117@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102247.209765070@linuxfoundation.org>
References: <20241021102247.209765070@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


