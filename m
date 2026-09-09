Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C11C256852F;
	Wed,  9 Sep 2026 13:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962367; cv=none; b=A/Y6l5CAEe1fRy9pR5pgszIOhchU7pVdU9oEEy1zWUWuo0Ns7q8hTPVcCX+mBQVN5cmfVL1Qita5/rl9vnlnZJWO34nZrZ1bfcGUfX6ZXYbmnGPFq+QQ5OBuumBuX3Z32WWJ5lKWUietcCiGMrljKMWjsGfsDLPzP2mY8wPojXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962367; c=relaxed/simple;
	bh=YvyhF0erE2g0vNcyc7LWqIvg0dlGbROFQnkMO6kp8X8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iWPJz3BY9DG2C/1w1C/iLMuj0FsEvagODYl13UIL/oMVrViCmiWBbiCmeH0qeyvBkNH5E03j9yB9WZDkn+J9bhonoCi71f3mkBJUnhVQDl5TCWiedaDC7qzJoga4GB+ET8daF+gA0sp7EKsvhBOQILfd2BUghBi3YAWNuKdW8Cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c+1vSPvk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c+1vSPvk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 270531F00A3A;
	Wed,  9 Sep 2026 13:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962366;
	bh=KV2ZNswwQ2TSsMQlJsc4BYh5q74hbo/mBeHn19twR4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c+1vSPvkIRB2zkF0ARmmbvNUZh5hQuHXqqNUAeR/ffNidug8cna4LFYbsdSDRMz1h
	 tssI7gRbSkXhQYwWAai1q+J3AglgcLxvDV6EdLA4uzNiEDmPSjelUT+Iyke6GoE9oK
	 WXKS29BfkU/AphW1Y0h1xWwSYfNjD1sM+ZugEzxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moksh Panicker <mokshpanicker.7@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 267/556] iio: chemical: atlas-sensor: fix PM reference leak in buffer postenable
Date: Wed,  9 Sep 2026 15:39:07 +0200
Message-ID: <20260909134239.968386361@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -412,7 +412,11 @@ static int atlas_buffer_postenable(struc
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


