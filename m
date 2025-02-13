Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C432115539A;
	Thu, 13 Feb 2025 14:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458197; cv=none; b=uVOGXX7kyOLS0eSwkjgTdbj0DJf+4dxO0bcUVFx8Ao8pAA12QnycU8eQMWW9ozK8Lg15vqLsaoF69s7MB2ROusWD6ucdgSpSjCN4qfn0n8lhq+/fokfRRNhsqHWQlZ/QzfaXaB3R/dZY4vY9p0jBDHDYr92/Pm8Gf/OkO+9ZALo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458197; c=relaxed/simple;
	bh=X+fchYnzV+VncjeB2vPKYNC57+wuwXQA2+JgpD/It6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lJzvTLwCm34Yz1TwUUmSCHdgpC7U2UrfRn13iqMc5xsiXgaw2ErCU1qpi/WdceSGWs117UzOjxVcvpeEz82YZ19pahLpWcyyJrqUF751FDgG4lgY1XrCwNJpKYI2Ra52p+QYtCDQ4YdrIUDfhx63C62HwrKh7Szei5+VRPH6ZCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XyahEPXo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XyahEPXo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9A4BC4CED1;
	Thu, 13 Feb 2025 14:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458197;
	bh=X+fchYnzV+VncjeB2vPKYNC57+wuwXQA2+JgpD/It6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XyahEPXoNZ8QxvtOKFs+NBWWtAcUio5VJxkvRqxKUrPzNOnIMgfSGZlrG1WgMKBar
	 8MiQJR2fm7j1qb8rwHaXBIJJHxACdGY2miERaEf9yRqMvK/NvOTmwm28ADtGhLEd6d
	 ywh0REE8RK/QzYHgEO0Z07xPMheu1OAoLuzjHAnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mehdi Djait <mehdi.djait@linux.intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.12 329/422] media: ccs: Fix cleanup order in ccs_probe()
Date: Thu, 13 Feb 2025 15:27:58 +0100
Message-ID: <20250213142449.251692805@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3566,15 +3566,15 @@ out_disable_runtime_pm:
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


