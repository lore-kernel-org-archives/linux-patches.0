Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0CA24E73B7;
	Thu, 17 Sep 2026 15:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659756; cv=none; b=qwIkfO2Ba+D5podOgLDM2e4wOen0v1I8DZi6nL7gqrIB457UGfMPTzC5gwiRZH2RAhe6RWxOZbLeXlqIiwLac/CqIgwtC9pWEWn/CeEUloVU8p0xkwwDt9wjPxNaVNnbkuDsKFsj2GYcx8ayFUiG4GvBewP/wx2kHYzkyZmRjVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659756; c=relaxed/simple;
	bh=V2wCPPsYmDDVKx9LHmlivc6vKXdQGsYEfrdSL0lpmgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rV/q7IO31oLTmbCwZ4kmUHNN8ONELV072AfOXbtzyEzS5YdHdtTecxWHMZHFodz/A9iz+oK4W/1wL/GmTx+ptrcuUeLSoRWzQPhDKbSEm0VJF5uulH5vcTzI9OJBTp2GdgBusVBJHqfrPEPXCJ60CC8gutdpxT3Kur7mxeF6whA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p8C2SvZI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p8C2SvZI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C0EB1F00899;
	Thu, 17 Sep 2026 15:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659746;
	bh=uR9kvMWKicGXJ6RjUL+lSzDKAdguiqSKokDMKPDl+B8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p8C2SvZIhpwB/tAmpM03/cabnzvSIvImYbL/zeRa1m3OOW4BkVLn3FViJdOrUsFVX
	 WRoh1sbiCnxtEHE8lRnpHyJjgtNzm3zd2Kw4/YlGbb3UKWF1PliXb87QQLdogS4RUF
	 fQGx9dAdrXZjuEqiKRw55Vfp5mVq0704LyRYxgrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linfeng Sun <linfeng.sun.dev@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 359/733] vduse: return compat ioctl results directly
Date: Thu, 17 Sep 2026 16:11:07 +0100
Message-ID: <20260917151400.545056007@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: Linfeng Sun <linfeng.sun.dev@gmail.com>

[ Upstream commit 48a4ee65e677559776349128e6a81a6041986c99 ]

The compat handler handles VDUSE_IOTLB_GET_FD and VDUSE_VQ_GET_INFO, but
then calls the native handler. Their different command sizes make native
dispatch return -ENOIOCTLCMD.

For GET_FD, this overwrites receive_fd()'s return value after the
descriptor is installed, leaking one fd per call. Return handled compat
results directly and use native dispatch only for other commands.

Fixes: 455a2a1af926 ("vduse: fix compat handling for VDUSE_IOTLB_GET_FD/VDUSE_VQ_GET_INFO")
Signed-off-by: Linfeng Sun <linfeng.sun.dev@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260908-fix-vduse_dev_compat_ioctl-v1-1-62264d9bfb8d@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/vdpa_user/vduse_dev.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
index 2ea30f85350d3..ed71e5835e60c 100644
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -1751,11 +1751,11 @@ static long vduse_dev_compat_ioctl(struct file *file, unsigned int cmd,
 		break;
 	}
 	default:
-		ret = -ENOIOCTLCMD;
-		break;
+		return vduse_dev_ioctl(file, cmd,
+				       (unsigned long)compat_ptr(arg));
 	}
 
-	return vduse_dev_ioctl(file, cmd, (unsigned long)compat_ptr(arg));
+	return ret;
 }
 #else
 #define vduse_dev_compat_ioctl compat_ptr_ioctl
-- 
2.53.0



