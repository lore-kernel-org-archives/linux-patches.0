Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08F1C23BD1B;
	Fri,  4 Sep 2026 05:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499068; cv=none; b=sQoxTJAjOCAFpf/n2qGlJAaapwmSdKpVzYog4BWVHprGaTzJqAxJApIe1R6jdsL3sD/yL9LKRZ50xYgJU35goDy3DJMGceHIt2d0BXHuylwbtHy4uXlp1nkpM1K8X7gk46gGBYPyHDYDsY17Bi2jcGeh0TNIeW+Vf6EII94mP5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499068; c=relaxed/simple;
	bh=QCsw9q6jqtTfXVhk4i04CSt4xypb+p4mNr1tSJRTj4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VUoNgokoZfcI2EM3wJihwxGXGwz9nQdzM0irHM+pVrcgkSbnnL34zxRL7eaHgdu5DHTehyODMK/1tjHLyIhUrN1S4xXSU1j6eHYSZ1iknR66h932vMxSUgcisaIvay+os5OtZtFk+KrhyVvSByJAz0cnRJT4TO4wiy6ufHO/LiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H/OuF3So; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H/OuF3So"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1414D1F00A3D;
	Fri,  4 Sep 2026 05:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499066;
	bh=CwYdFDTCo6FbeOxcHOvUAZ9Wd0thPTJJwgjb2aa7rcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H/OuF3SoGFN5XyJP3YXCuTB2H/fJzVYaM5kr31J5evLacaLZ70rjexmVhQEVmbA49
	 cPpe6wtMfhzsSo8xI3TKu8idzVroLD23lXhydYD1S4MYmu/oxneit/t/jvEcUiVkBQ
	 L3daVMAcGZg2BlZfGLgzov4kkh/Nd2e+u1uisU7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 7.2 286/713] fbdev: uvesafb: unregister connector callback on init failure
Date: Fri,  4 Sep 2026 06:54:14 +0200
Message-ID: <20260904045810.249394419@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

commit de8db23aa7c337e606fca9faf48b3ba72968597a upstream.

uvesafb_init() registers the v86d connector callback before registering
the platform driver. If platform_driver_register() fails, the function
returns the error directly and leaves the connector callback registered.

The later platform-device failure path already unregisters the callback.
Add the same cleanup before the final return when platform-driver
registration fails.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: 8bdb3a2d7df4 ("uvesafb: the driver core")
Cc: stable@vger.kernel.org
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/uvesafb.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/video/fbdev/uvesafb.c
+++ b/drivers/video/fbdev/uvesafb.c
@@ -1907,6 +1907,8 @@ static int uvesafb_init(void)
 			err = 0;
 		}
 	}
+	if (err)
+		cn_del_callback(&uvesafb_cn_id);
 	return err;
 }
 


