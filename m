Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D211B3934;
	Wed, 19 Mar 2025 14:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394891; cv=none; b=j8Huh/0MuyCWHdxdGIy7epRFk4rn7Dg9cUjKwB4buPgn2VFS0Q59EmHDm4T1KLFgemLLRsoDNsNd8lu+OKrAg1jOUIG0pQCr0ZVBGyBrq4HA4QMXQHQzB7HInvwmiFRxrrcUcrRT8STNGTMgoJLbRngepU72gLkAyIX8YHjJOio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394891; c=relaxed/simple;
	bh=7bVAn8ukkbIACcM4nlKQnzvSWtQ2JjFCHmaqFBAxGto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tr1vIY8hjqyMoICKfa0UjTKPHsPoJi8XMk0eH/sMJAS3KX0SCpR8OfOvjruvcSZykSNS6Arm32NJE5dkeeJoBYgr/FDrl9wvYClg45rkz5tmc/Ixmf4sH5a9zHSxc5s76zIHrNSLWhbvHqXCZDHt/tJN9kXod7OPKQfb0Vv4QNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z7DPba6F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z7DPba6F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F5FFC4CEE4;
	Wed, 19 Mar 2025 14:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394891;
	bh=7bVAn8ukkbIACcM4nlKQnzvSWtQ2JjFCHmaqFBAxGto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z7DPba6FvV1H0RauKMz/u/gZFFNTUBcttmC1I4bSsnUH0lSkwMuhc4HcVJRgV39q8
	 TDKtJ2xqJ02jlUMe85c74J5FQDkM2DKKzUipPqK0p++ooCaC1HJYCSSIkBaXfSWeLa
	 F5AlimxDTteDVKb/zBZEZBekQZBXjoSn9UFJP8xA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 094/241] s390/cio: Fix CHPID "configure" attribute caching
Date: Wed, 19 Mar 2025 07:29:24 -0700
Message-ID: <20250319143030.049161187@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Oberparleiter <oberpar@linux.ibm.com>

[ Upstream commit 32ae4a2992529e2c7934e422035fad1d9b0f1fb5 ]

In some environments, the SCLP firmware interface used to query a
CHPID's configured state is not supported. On these environments,
rapidly reading the corresponding sysfs attribute produces inconsistent
results:

  $ cat /sys/devices/css0/chp0.00/configure
  cat: /sys/devices/css0/chp0.00/configure: Operation not supported
  $ cat /sys/devices/css0/chp0.00/configure
  3

This occurs for example when Linux is run as a KVM guest. The
inconsistency is a result of CIO using cached results for generating
the value of the "configure" attribute while failing to handle the
situation where no data was returned by SCLP.

Fix this by not updating the cache-expiration timestamp when SCLP
returns no data. With the fix applied, the system response is
consistent:

  $ cat /sys/devices/css0/chp0.00/configure
  cat: /sys/devices/css0/chp0.00/configure: Operation not supported
  $ cat /sys/devices/css0/chp0.00/configure
  cat: /sys/devices/css0/chp0.00/configure: Operation not supported

Reviewed-by: Vineeth Vijayan <vneethv@linux.ibm.com>
Reviewed-by: Eric Farman <farman@linux.ibm.com>
Tested-by: Eric Farman <farman@linux.ibm.com>
Signed-off-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/chp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/cio/chp.c b/drivers/s390/cio/chp.c
index cba2d048a96b3..7855d88a49d85 100644
--- a/drivers/s390/cio/chp.c
+++ b/drivers/s390/cio/chp.c
@@ -695,7 +695,8 @@ static int info_update(void)
 	if (time_after(jiffies, chp_info_expires)) {
 		/* Data is too old, update. */
 		rc = sclp_chp_read_info(&chp_info);
-		chp_info_expires = jiffies + CHP_INFO_UPDATE_INTERVAL ;
+		if (!rc)
+			chp_info_expires = jiffies + CHP_INFO_UPDATE_INTERVAL;
 	}
 	mutex_unlock(&info_lock);
 
-- 
2.39.5



