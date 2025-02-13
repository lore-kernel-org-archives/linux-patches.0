Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F61926B087;
	Thu, 13 Feb 2025 15:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460885; cv=none; b=PiHTmvL3VXkw6fNXXtUbWAe3ew/zpeNCuqu3C4t4Pw0ZCqsRmYvTxHsD3UL6sbk9/3+vw1fZOXr8KpkH0OE2lJkk8TnIks39jnDfdtJhTZKN+p/1WoqRTYf4c0c1qp+lXIoyi5Ss77R0SBqWAqrhIgU7fNIRckT8qDfxYxQjlEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460885; c=relaxed/simple;
	bh=YBjw/bet8HcAXnLclaSvVAEvZVjQyNkPio4mVITVm+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ePubw1GO1azKIDI0DvSbG4jr8NzVQVosnFXy/AobiDCvelRstGVtB0gtQRd7wAnoHXEDbF5WOMH/3HM1PxC7F+s+J1pZVf3qKQafPawEIuPbKAESuqupFlIQKzHBNN6jgekWs2b83iatNFKH8yrxA9qYcq/skEcAI9VCKWD9M+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kKzsda+B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kKzsda+B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E7F3C4CED1;
	Thu, 13 Feb 2025 15:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460885;
	bh=YBjw/bet8HcAXnLclaSvVAEvZVjQyNkPio4mVITVm+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kKzsda+BsZ8rQuXbnumSRMgoacadY1QTi7uVkzXR7d2CpSeUiCjWpftcp1DO9grlT
	 waHRm7uMLwhUVgD3sXAwmTM+2wZ1gZl16DlHQhCE72XSAqRMvtS1jyyV6fUJ2ZP6Vz
	 sGsKcYPTo5vdr2mQGaE8lh+UstA81acvvvgWlnqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mehdi Djait <mehdi.djait@linux.intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.6 208/273] media: ccs: Fix cleanup order in ccs_probe()
Date: Thu, 13 Feb 2025 15:29:40 +0100
Message-ID: <20250213142415.540937303@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3658,15 +3658,15 @@ out_media_entity_cleanup:
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


