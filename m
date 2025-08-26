Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01B5F343D63;
	Tue, 26 Aug 2025 14:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218369; cv=none; b=qOMZIcWP4Cna4h+o+gOhMfC7niM4ZCxysZdJgVB6sYHnUXAVgGq3g6nibFAe5vyAKIn1AMCYF3fTJ9y7hFz71a57nkorcNKABEsFY9BfhOf49Zys6NGJ4bJVF6kDuSoJKlI79QoONuhM8q2Fkp8LSlCeUz3aYk1ReR/cgob+5iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218369; c=relaxed/simple;
	bh=nK7wLgqeNYcQU//KwoFO6pVYaQ6yK94qU16JtX+Q7vU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pUMjd3z0ObnSxx0xwNjdcQm0PdcMs0ynpjey5ZyFg7lDol8rf81pSb+KkffPURqj9a13IgqvEOyr9z7QloVZGdnio3+8D5j1JpyNclkH2/CeCQ6Nvylvc3L9zZVeSUG9jamfLQkE20Y8ExWU40L9htq27GJnCB3bRIiXZYoMPYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0bBp5qfB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0bBp5qfB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86847C4CEF1;
	Tue, 26 Aug 2025 14:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218368;
	bh=nK7wLgqeNYcQU//KwoFO6pVYaQ6yK94qU16JtX+Q7vU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0bBp5qfB9C2a6Na/fiqsy7h5nVKwNfcrczS9GB4BB9BJnpbnQtPg0NZ2/vgTyI2Iz
	 kqL0IMBaStm21ZCWP0xXiXWV0u7B2T+nAXvijRSnX8GVCQK2SBU1s3D/cDd3pXeG2b
	 XM6hpfh/B7uKt+Q69+wXQN5xJawSpmLY6fOiPH/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <ming.lei@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>,
	Shivani Agarwal <shivani.agarwal@broadcom.com>
Subject: [PATCH 5.10 495/523] dm rq: dont queue request to blk-mq during DM suspend
Date: Tue, 26 Aug 2025 13:11:45 +0200
Message-ID: <20250826110936.652958645@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

commit b4459b11e84092658fa195a2587aff3b9637f0e7 upstream.

DM uses blk-mq's quiesce/unquiesce to stop/start device mapper queue.

But blk-mq's unquiesce may come from outside events, such as elevator
switch, updating nr_requests or others, and request may come during
suspend, so simply ask for blk-mq to requeue it.

Fixes one kernel panic issue when running updating nr_requests and
dm-mpath suspend/resume stress test.

Cc: stable@vger.kernel.org
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
[Shivani: Modified to apply on 5.10.y]
Signed-off-by: Shivani Agarwal <shivani.agarwal@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-rq.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -490,6 +490,14 @@ static blk_status_t dm_mq_queue_rq(struc
 	struct mapped_device *md = tio->md;
 	struct dm_target *ti = md->immutable_target;
 
+	/*
+	 * blk-mq's unquiesce may come from outside events, such as
+	 * elevator switch, updating nr_requests or others, and request may
+	 * come during suspend, so simply ask for blk-mq to requeue it.
+	 */
+	if (unlikely(test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags)))
+		return BLK_STS_RESOURCE;
+
 	if (unlikely(!ti)) {
 		int srcu_idx;
 		struct dm_table *map;


