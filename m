Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC2C41A5BA
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BaYO3C2B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5159DC433C9;
	Mon,  9 Oct 2023 13:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858058;
	bh=UexaXumbCpixOP4kNtkrPRLOAi0CcY8G5siVfpYdndM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BaYO3C2BtREo1RT/wVI6XtKyJBculOrKIORRrfPy2D7o92RVez1o0MkNEjwb0v6yG
	 IgLBKyignNgLJqYp67zB+nzVVTJb/C3ivy4wvvNMppi+7OOrVTB+JDCty4NX5gos8S
	 /OtRAD1+FO7aGVScykB6HDVc7VcR0nJkaoaOnEag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 5.15 63/75] dm zoned: free dmz->ddev array in dmz_put_zoned_devices
Date: Mon,  9 Oct 2023 15:02:25 +0200
Message-ID: <20231009130113.469038808@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130111.200710898@linuxfoundation.org>
References: <20231009130111.200710898@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

commit 9850ccd5dd88075b2b7fd28d96299d5535f58cc5 upstream.

Commit 4dba12881f88 ("dm zoned: support arbitrary number of devices")
made the pointers to additional zoned devices to be stored in a
dynamically allocated dmz->ddev array. However, this array is not freed.

Rename dmz_put_zoned_device to dmz_put_zoned_devices and fix it to
free the dmz->ddev array when cleaning up zoned device information.
Remove NULL assignment for all dmz->ddev elements and just free the
dmz->ddev array instead.

Found by Linux Verification Center (linuxtesting.org).

Fixes: 4dba12881f88 ("dm zoned: support arbitrary number of devices")
Cc: stable@vger.kernel.org
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-zoned-target.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/drivers/md/dm-zoned-target.c
+++ b/drivers/md/dm-zoned-target.c
@@ -750,17 +750,16 @@ err:
 /*
  * Cleanup zoned device information.
  */
-static void dmz_put_zoned_device(struct dm_target *ti)
+static void dmz_put_zoned_devices(struct dm_target *ti)
 {
 	struct dmz_target *dmz = ti->private;
 	int i;
 
-	for (i = 0; i < dmz->nr_ddevs; i++) {
-		if (dmz->ddev[i]) {
+	for (i = 0; i < dmz->nr_ddevs; i++)
+		if (dmz->ddev[i])
 			dm_put_device(ti, dmz->ddev[i]);
-			dmz->ddev[i] = NULL;
-		}
-	}
+
+	kfree(dmz->ddev);
 }
 
 static int dmz_fixup_devices(struct dm_target *ti)
@@ -951,7 +950,7 @@ err_bio:
 err_meta:
 	dmz_dtr_metadata(dmz->metadata);
 err_dev:
-	dmz_put_zoned_device(ti);
+	dmz_put_zoned_devices(ti);
 err:
 	kfree(dmz->dev);
 	kfree(dmz);
@@ -982,7 +981,7 @@ static void dmz_dtr(struct dm_target *ti
 
 	bioset_exit(&dmz->bio_set);
 
-	dmz_put_zoned_device(ti);
+	dmz_put_zoned_devices(ti);
 
 	mutex_destroy(&dmz->chunk_lock);
 


