Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949C1227E9E;
	Mon,  2 Jun 2025 14:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875480; cv=none; b=RPiRbVP29x2Oc1ktfLQd4OZDr7/a/yBF5TySw80PNdhFeP1ENWmIku9LiOO+rghba1clyZKdJPBMCKTCjAu6LFb+954CbiBnofkNulnbCDO27Q3jvxu54CA3h+SyjmgmNA4tv7u4ABDglz9Ny/VGRzMGj5RWtB6WbE21G05Ymzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875480; c=relaxed/simple;
	bh=p37wUS8dtO0c9HfwEFKE2aoG2arQS2SJRV4n1X7X25c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gt54HHzRC6DwclVYLGr5tXcHZh0bQHvCzaRTzQ90X82y1nL3dI4YjPp9n+DjX8IaJUhzKNcvCwrURsjizGhXQ3HjeRLRqCxeM9qtFErPsnB1eXySDIIC/w2piYnhN94V8o9fR4glugD2s81E6AsRvtxZT1GdMlaYvwTa/Ow3Dic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fm/6vsq4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fm/6vsq4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A399DC4CEEB;
	Mon,  2 Jun 2025 14:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875480;
	bh=p37wUS8dtO0c9HfwEFKE2aoG2arQS2SJRV4n1X7X25c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fm/6vsq45YMRWPI1bA+yUXNDratHgqK/HpTfHY0+KjtOOH6gmEbGeqZF49R2xQ/gw
	 +1BuIIzDAkLnQ8mrl+vGjUo+5ze0khU31Mj0HzGgclN43D/VBlNi4uHoK135kXaZ8f
	 K/dmH7bqn+fhLmKpdenpPqpXfI8IOzkEvulVLkME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 147/270] dm: restrict dm device size to 2^63-512 bytes
Date: Mon,  2 Jun 2025 15:47:12 +0200
Message-ID: <20250602134313.233728798@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 45fc728515c14f53f6205789de5bfd72a95af3b8 ]

The devices with size >= 2^63 bytes can't be used reliably by userspace
because the type off_t is a signed 64-bit integer.

Therefore, we limit the maximum size of a device mapper device to
2^63-512 bytes.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-table.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index db40df5749c83..4351de47fa775 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -682,6 +682,10 @@ int dm_table_add_target(struct dm_table *t, const char *type,
 		DMERR("%s: zero-length target", dm_device_name(t->md));
 		return -EINVAL;
 	}
+	if (start + len < start || start + len > LLONG_MAX >> SECTOR_SHIFT) {
+		DMERR("%s: too large device", dm_device_name(t->md));
+		return -EINVAL;
+	}
 
 	tgt->type = dm_get_target_type(type);
 	if (!tgt->type) {
-- 
2.39.5



