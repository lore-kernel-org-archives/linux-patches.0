Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBCDB1C4A24;
	Mon, 10 Mar 2025 17:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629484; cv=none; b=E9JY8o/sh1TVSMS7zUqZ4KTSoKDSdHMXFbRuORUGZuSvWoH7AZI48MfCWc9J4GlQ1PkYDj5Vdyl6KuCP+NSiqBaYwBkq7HXHjiyq1qEPU7u105nge8lTMphFNE/S2uetn9QGAVYkL+cdWGGHeAGHIavPyyqeUUK7rkfqwR1LRe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629484; c=relaxed/simple;
	bh=oqUeKzl3pWkuarN/7ZIBZ9wggVyhxKF6Xnv9yNkIZSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DsSokA3jXi6DjCATlSlHfoMUjhPtx7/6Sgx6OK2UqLUwfoP8YHJ+IJVn1RJUCIqoCVaK4YFfkQ0PT0LBOn8enPR2wWY0aSpWmBErDRtccyz2/4GEh0hhlw3m2BIfFBPCCx+Y/IJgxUmjIjVbNY3TQHYL/irXnRL5OMyUwl3htfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bdxOAm7p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bdxOAm7p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54D8EC4CEE5;
	Mon, 10 Mar 2025 17:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629484;
	bh=oqUeKzl3pWkuarN/7ZIBZ9wggVyhxKF6Xnv9yNkIZSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bdxOAm7pfWCGUwD+zQl8qaAmvn6bsvCBhiTa+rTgvo1qv4zVFr7If1NqgoqpY9Dnf
	 7pUFFVA+lRjkbaBDHNaiEgJFeKhq2A18znlTjtpGduoX3UEmytd8VP+OHnCuzTs18c
	 5QDRHmK/ZmMTgDG69fi9oqa744Y+gRHSGFlm/SCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mehdi Djait <mehdi.djait@linux.intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.15 310/620] media: ccs: Fix cleanup order in ccs_probe()
Date: Mon, 10 Mar 2025 18:02:36 +0100
Message-ID: <20250310170557.854276472@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mehdi Djait <mehdi.djait@linux.intel.com>

commit 6fdbff0f54786e94f0f630ff200ec1d666b1633e upstream.

ccs_limits is allocated in ccs_read_all_limits() after the allocation of
mdata.backing. Ensure that resources are freed in the reverse order of
their allocation by moving out_free_ccs_limits up.

Fixes: a11d3d6891f0 ("media: ccs: Read CCS static data from firmware binaries")
Cc: stable@vger.kernel.org
Signed-off-by: Mehdi Djait <mehdi.djait@linux.intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ccs/ccs-core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/media/i2c/ccs/ccs-core.c
+++ b/drivers/media/i2c/ccs/ccs-core.c
@@ -3652,15 +3652,15 @@ out_media_entity_cleanup:
 out_cleanup:
 	ccs_cleanup(sensor);
 
+out_free_ccs_limits:
+	kfree(sensor->ccs_limits);
+
 out_release_mdata:
 	kvfree(sensor->mdata.backing);
 
 out_release_sdata:
 	kvfree(sensor->sdata.backing);
 
-out_free_ccs_limits:
-	kfree(sensor->ccs_limits);
-
 out_power_off:
 	ccs_power_off(&client->dev);
 	mutex_destroy(&sensor->mutex);


