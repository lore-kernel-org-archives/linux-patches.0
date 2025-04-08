Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD3D26A0FF;
	Tue,  8 Apr 2025 12:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113884; cv=none; b=TUoz/Fy0KvCFtOmVIz0HI2Z8slbqtvXgxf9nam1Od/nlZBH4qKZIk7rKgF7FecEbLlyOKBEGtz2vi3S73hiUTGVnCtmaoVYPIDRqqeZsdpLmBVh59yTQcClRNkM6K2ZC6ZGumxg6VpQq00jMaxVSUBF1FgN0t2SjqARgR8kxKvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113884; c=relaxed/simple;
	bh=UDc4/kxTdKJQJcfO5fc1y/T+h2pLYgaDg+vrDYIMqhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B2zm1ppfPKgyzJSsR8OjKZYuIfIGiod8KajULQNUoiN0hGo9j8B8dnsF+G4YJe9dt02QdImj8fB3QSFH+DHFSEtdZ+mF/Ytxd5OWoy+4wFkCa0qa2FOCASmNsj4vupzUdoAc9Vvs4GQpA/6Rz12mhXC5LllDLv6o9E5uPgpnAes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uaaw7JHh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uaaw7JHh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FB29C4CEE5;
	Tue,  8 Apr 2025 12:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113884;
	bh=UDc4/kxTdKJQJcfO5fc1y/T+h2pLYgaDg+vrDYIMqhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uaaw7JHhqueqHWAtH6rnbZhc+KzBLawBtY2BU8RGsFkiVJ0YW9FhVsxfDqRMgpcPL
	 WnJi5O5hx+j5PcEaGmfF2sQotgUgboONrOJRxd7pHcR4ozVBi8fMTGxN0AifzHgnZS
	 JPGxXWlER0E536pIDfgI7WZioLYE+HSMQkvKZwSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 029/154] s390/cio: Fix CHPID "configure" attribute caching
Date: Tue,  8 Apr 2025 12:49:30 +0200
Message-ID: <20250408104816.196304434@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 1fd982b4d64bd..18b2fc50463ba 100644
--- a/drivers/s390/cio/chp.c
+++ b/drivers/s390/cio/chp.c
@@ -646,7 +646,8 @@ static int info_update(void)
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



