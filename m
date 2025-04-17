Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FE4826462C;
	Thu, 17 Apr 2025 18:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914864; cv=none; b=sa1/0kV2uRJCoaNiQG/ZMGDL4dLD+ZDqOPC/q7PWL7BXdSHd8Cj2KSceB1PDvwySf5B9ECG/Ho7HhoYgn8kT8wLMczrprjal4eil+LSUig7YSb//EmijxvEREQsIQqcEDUnQM/FMSg2SmcTV8+O3o4KPeg/tkAKVNj81eHt0jnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914864; c=relaxed/simple;
	bh=aiqyjsFF5VZtxPwkyCPNN1xTRL1cqpekeEvIzHFeyTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j3rt6xNMNT0F5UCJ5Di+ps9KrGBKKaajukm62gJRPbh5VxqwCcef0h5jbUgblMltPQ3i9Rs7BBSCXPE8F0CMed1CS7iFFYDX4tyHom1/NnoTHCEFdkpecFBVNFbUFTrfm8TMCoMhABtwBlzYBTFUcRNnaYq4YAkoHqq7QwouExY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mp4BKp3M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mp4BKp3M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DFB5C4CEE4;
	Thu, 17 Apr 2025 18:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914863;
	bh=aiqyjsFF5VZtxPwkyCPNN1xTRL1cqpekeEvIzHFeyTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mp4BKp3M5JC5xsFRw/3Y/n9CAE5FzSrdE7O5itDKv/nMMJqgK3TCimuRVvbj0Mwq7
	 qBPGndo3/R0FYR4jc1JKo3IM66Y/CIx0RIJ3h49/1X3Mdxvh9hdARWIyUwKWyhAWR8
	 4rkuB2YlRjmBosm0kNpboVvBdshoCwr4HRaUPYVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.13 356/414] dm-verity: fix prefetch-vs-suspend race
Date: Thu, 17 Apr 2025 19:51:54 +0200
Message-ID: <20250417175125.784745754@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

commit 2de510fccbca3d1906b55f4be5f1de83fa2424ef upstream.

There's a possible race condition in dm-verity - the prefetch work item
may race with suspend and it is possible that prefetch continues to run
while the device is suspended. Fix this by calling flush_workqueue and
dm_bufio_client_reset in the postsuspend hook.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-verity-target.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -796,6 +796,13 @@ static int verity_map(struct dm_target *
 	return DM_MAPIO_SUBMITTED;
 }
 
+static void verity_postsuspend(struct dm_target *ti)
+{
+	struct dm_verity *v = ti->private;
+	flush_workqueue(v->verify_wq);
+	dm_bufio_client_reset(v->bufio);
+}
+
 /*
  * Status: V (valid) or C (corruption found)
  */
@@ -1766,6 +1773,7 @@ static struct target_type verity_target
 	.ctr		= verity_ctr,
 	.dtr		= verity_dtr,
 	.map		= verity_map,
+	.postsuspend	= verity_postsuspend,
 	.status		= verity_status,
 	.prepare_ioctl	= verity_prepare_ioctl,
 	.iterate_devices = verity_iterate_devices,


