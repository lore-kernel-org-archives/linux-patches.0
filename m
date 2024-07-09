Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A2D31586C0;
	Tue,  9 Jul 2024 11:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523749; cv=none; b=WUP0OuwSy4kqXtHfJv7exBHdzEgCC9h7Hc37ElhRLEys3YwealmnGF/OOgaODsZ3AcI3dTDkHQTcZBDHYnQlpBhya1jiVcG2FtHayOkaRqpN6QIsvnss8SxnQf3AkWdsBJBMtZMMPJoZqQGWekrP7+DQC4YsUqkJcmEUtotABR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523749; c=relaxed/simple;
	bh=IbZtROTB03+Iigjj7RctRnEsf5EVk5AnBr9Swq87KUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TVHacrreZlb++66Ze0rRpjahWtmHWHquSZB7lHss912U9BESESqQlMNc8ynLqIHMagmL1IdAvTZrlTVRJJsLPfOcJZ9NKeHGmKNqYz6mjsvdpzc6FQG5ASggQkKdociLUKNUIXnRYdKmcw0v5ra/6kSnsH0b63EMIILqA1k6jd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gPip65P2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gPip65P2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 613D5C32786;
	Tue,  9 Jul 2024 11:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523748;
	bh=IbZtROTB03+Iigjj7RctRnEsf5EVk5AnBr9Swq87KUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gPip65P2hrFBhFkXR+RDGpVpxjxa3QLtXEOt/AZy28XV92mHiDnp6eSjF7L4LIxKn
	 XN6p4ZxzwXA5sHxLmlFPrrh0Mt4d9t3yTYS1kfuD86ChzyBayGUBEI9G27RBI8LCUP
	 UqziCubLUElkzmWs5rAW2xt6lLsqMYk0SOvABDTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 096/139] scsi: mpi3mr: Use proper format specifier in mpi3mr_sas_port_add()
Date: Tue,  9 Jul 2024 13:09:56 +0200
Message-ID: <20240709110701.892099158@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit 9f365cb8bbd0162963d6852651d7c9e30adcb7b5 upstream.

When building for a 32-bit platform such as ARM or i386, for which size_t
is unsigned int, there is a warning due to using an unsigned long format
specifier:

  drivers/scsi/mpi3mr/mpi3mr_transport.c:1370:11: error: format specifies type 'unsigned long' but the argument has type 'unsigned int' [-Werror,-Wformat]
   1369 |                         ioc_warn(mrioc, "skipping port %u, max allowed value is %lu\n",
        |                                                                                 ~~~
        |                                                                                 %u
   1370 |                             i, sizeof(mr_sas_port->phy_mask) * 8);
        |                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the proper format specifier for size_t, %zu, to resolve the warning for
all platforms.

Fixes: 3668651def2c ("scsi: mpi3mr: Sanitise num_phys")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/r/20240514-mpi3mr-fix-wformat-v1-1-f1ad49217e5e@kernel.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/mpi3mr/mpi3mr_transport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -1366,7 +1366,7 @@ static struct mpi3mr_sas_port *mpi3mr_sa
 			continue;
 
 		if (i > sizeof(mr_sas_port->phy_mask) * 8) {
-			ioc_warn(mrioc, "skipping port %u, max allowed value is %lu\n",
+			ioc_warn(mrioc, "skipping port %u, max allowed value is %zu\n",
 			    i, sizeof(mr_sas_port->phy_mask) * 8);
 			goto out_fail;
 		}


