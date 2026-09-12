Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F5F47126B;
	Sat, 12 Sep 2026 15:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228222; cv=none; b=mR11GBV7GYlLG7Xl1aVTK1hALomWQBBslOEDheZ7Kdd0RF4ww1WeXLxvPRBF7nl/iuIkCy90iccRTIDJEhMwhdILtRIhebvnPlGMDxSfC1khnW/GlgjGK/XDkiX1KO4c6y0I6PU8kogqx48smLcf65PPWW30B7fp2s+YRc03s8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228222; c=relaxed/simple;
	bh=dvisJlOCaeZpzEekt1/qfcuLlB7Gc3ejrQqEzcpQpGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FVe9SHGSwmkIL3QMuwrnry/Ww7aK51o8OE7vxZ1v+y1/JMEUP6ZT7Ajk9h2YX7ScfL3EMW9zmkuerJ/EqP/tGMEd5FPaHbFuvqvzgRtekKvUVlqGi6iaod5/QnTqAGJY+sjdzvdpdzibQ/g84h4mpX24hJP7XaEgYkkHA9pIs9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yCSQySsB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yCSQySsB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FBD31F000FF;
	Sat, 12 Sep 2026 15:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228220;
	bh=SGab6GG2K6skUUTA6/EsEC3SC4PFk2raIVSt+q4zQHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yCSQySsB/Dmd3Q68pbifkzVXTQVcoyjHKxLL6Y3KlYaiqo/1OVhabueFceQuUk0LI
	 O3nLVQ6yZZlu3TIrf7wR+w78qS9BBkaU5/lYlm7HwcrtqJCkUrycsruD+BrUyuTZxa
	 deZ7hNFJTnsKAxAgXzRedZLlppBS+VNk/tfgZ2P0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moksh Panicker <mokshpanicker.7@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.1 0342/1191] iio: chemical: atlas-sensor: fix PM reference leak in buffer postenable
Date: Sat, 12 Sep 2026 08:51:10 +0200
Message-ID: <20260912065555.909385116@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


