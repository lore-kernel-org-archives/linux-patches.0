Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BFC01E47A6;
	Mon, 21 Oct 2024 10:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507900; cv=none; b=gtmNEJFg2MZuzfH2qLmIKlDZYIYRewwlZ1+C+EqJpUQjz0RQM0zlS2ZqSoipYDoVCAWUhw4skmBQ3tLxX6pDtYfOGEt2GwRj2BxuPCx26PJUXwMqUsJtkFUoaLmsPw3ob2dMEj4/oEvycxZP3+62MYumBq671TrTVhkKQpALVmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507900; c=relaxed/simple;
	bh=f+GjlE32vzWZmOiDbToslof6PM2iT1HIT181likQRsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tfk+N03z87cvm+OooYwr/fE4l+aD0jJiVMkFrQ8IUYDm19zxggwGQNkdap9efTtYYFFtbW5Fx6dvcPttCRowGVn4xfo3NT2W1HcJD+XHj6zcEzk1+PoDvd/UYAZ/fPCYvtRL6WEC8AewsUgqice0orZ5bN8I7/aLukHhvOHDScc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0qJqI0YH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0qJqI0YH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B3CDC4CEC3;
	Mon, 21 Oct 2024 10:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507899;
	bh=f+GjlE32vzWZmOiDbToslof6PM2iT1HIT181likQRsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0qJqI0YHCrA4dsSF6ju+pYoQlyk7XYm7ZlJ5eL5oIL07dNLU3eX9/cqBwHi3fHXXx
	 niXA6wLNt92/hG/g3AXV9ayaVs/wGbusYRYggJNkFLtoAcppg6J6Um9ta+HRy+lUHe
	 xl1M0a6tCAlfAhOkeVYLBMG9hrsVucNHqW3EYAoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 30/52] iio: hid-sensors: Fix an error handling path in _hid_sensor_set_report_latency()
Date: Mon, 21 Oct 2024 12:25:51 +0200
Message-ID: <20241021102242.805224939@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102241.624153108@linuxfoundation.org>
References: <20241021102241.624153108@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -35,7 +35,7 @@ static ssize_t _hid_sensor_set_report_la
 	latency = integer * 1000 + fract / 1000;
 	ret = hid_sensor_set_report_latency(attrb, latency);
 	if (ret < 0)
-		return len;
+		return ret;
 
 	attrb->latency_ms = hid_sensor_get_report_latency(attrb);
 


