Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278353A5422;
	Sat, 12 Sep 2026 11:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213660; cv=none; b=ZKc5FamOlSEYBMImD3gO162cHdRZjq4yx63cP4YAvHqZJddNU5S9+WZHG3BcrQccl11XQwzCSFDCcaACl2j6MQVF2kOBoTw3QMaUZtSqTB9C2VNJIg22vEOOa9Mjyx4bxouTG203P/4OjzIfpTY8YLwJ1djgK7tKiDthd7TvKg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213660; c=relaxed/simple;
	bh=9BuSl7Ve9TKsFjJg0OOwzA1ibo+ehjK01lyDeTcjgw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p1AAvUvZlrHkcTbLJ6cnr6QTQ6xGnYlAZyl2gldocXVk2zAdRM1vlKKYa97twbc41FXr117nmb10oqLFb0auZEdLQ1bZnqVxMxMcG0Yp0qmUOjnhxuqQZDvw/P7CI3P+Jg+cu8g0Cb7+QMJIX3ZslwW/DCBP0v5UyCTSTzVnEpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qv9CKGMB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qv9CKGMB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72D671F000FF;
	Sat, 12 Sep 2026 11:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213654;
	bh=KdAMboY2f2aJRZDRC7Ec+/rjVRhrp9al45mgCQq5Ejs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qv9CKGMBiSopqqjCsV5lIcTFO5z9N6047+e1G7LtuD7Eb8QxPaj2XL1ztojoLAvA9
	 foiOPK7gElceKitlAKAucYncsAEWQHnCXQj5BqVzZ2AOE3scml6ayG/RCu5iF5FBvD
	 PiK/7TsV9iuAjYhBufIv50ijhux0MgUmzyq+cZpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moksh Panicker <mokshpanicker.7@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.12 0139/1376] iio: chemical: atlas-sensor: fix PM reference leak in buffer postenable
Date: Sat, 12 Sep 2026 08:42:45 +0200
Message-ID: <20260912065610.652231119@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Moksh Panicker <mokshpanicker.7@gmail.com>

commit bcd3f72e26314edfce7eaf8d7160b3119c7b7fed upstream.

atlas_buffer_postenable() acquires a runtime PM reference with
pm_runtime_resume_and_get() but returns the result of
atlas_set_interrupt() directly. If atlas_set_interrupt() fails,
the runtime PM reference is leaked and the device can never
autosuspend.

Add pm_runtime_put_autosuspend() on the error path to balance
the reference.

Fixes: 0e4f336f50de ("iio: chemical: atlas-sensor: Balance runtime pm + pm_runtime_resume_and_get()")
Cc: stable@vger.kernel.org
Signed-off-by: Moksh Panicker <mokshpanicker.7@gmail.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/chemical/atlas-sensor.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/iio/chemical/atlas-sensor.c
+++ b/drivers/iio/chemical/atlas-sensor.c
@@ -414,7 +414,11 @@ static int atlas_buffer_postenable(struc
 	if (ret)
 		return ret;
 
-	return atlas_set_interrupt(data, true);
+	ret = atlas_set_interrupt(data, true);
+	if (ret)
+		pm_runtime_put_autosuspend(&data->client->dev);
+
+	return ret;
 }
 
 static int atlas_buffer_predisable(struct iio_dev *indio_dev)


