Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF4F7274B46;
	Sat, 12 Sep 2026 18:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237605; cv=none; b=TISgN2D3w4TBcabrCl9HT6rPk09OgMdpNReJqGpYLlouz/rQBJ5ad61JcW5Jj6N5vEUt1oC9HnDiu0KvJSj5pKtSOyQlqbgEvhAzjPV0sTlRuwE8riPyH0D+xUX7nD6wBhySSqLYEfozqfDXk91/MaVLhg6iESEhb6ZK9se8Uzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237605; c=relaxed/simple;
	bh=03epeRrOMtVlQtIEg7DR80XETwuf+8tGY5+3a6uwAIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CrLm+TBgC/oACSRx17RA3JKV9K4HqF2YK/Oe0h10dDcQaYKEm8EK6MfavYu40bwzlXpzOGrVkDJowA5kbO6/BxO6jC8zGO8QdEhaVeARcYXMql2ZXpdUHBaoD7h9nziYDX3ps0NgJXuV2meUbkxFBMCPYk4zADzlSaNxbPZVDpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Byyig8UR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Byyig8UR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 819C91F000FF;
	Sat, 12 Sep 2026 18:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237604;
	bh=NJpa4zxxSPbYYdJeXwI8TmaG+dUsv4ZACxa8Tp54b9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Byyig8URBP13PRw1wVPdBQyhwhHYzC0+8NkqADiTPnEN47rJpGEMUlIjSx3mVXVsW
	 MxgLko/zkOPjaEMk7vsHTV+sCLlzh8+rD4N1ZmaRW7FANEap8avsubnsqWxPArIE+3
	 1/MTMvF011Iq31AfanMXI9nWzQuZ4QCW+l6Lob74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moksh Panicker <mokshpanicker.7@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 5.15 291/935] iio: chemical: atlas-sensor: fix PM reference leak in buffer postenable
Date: Sat, 12 Sep 2026 08:55:21 +0200
Message-ID: <20260912065533.486832147@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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


