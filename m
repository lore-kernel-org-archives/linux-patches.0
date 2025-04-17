Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C64F1A3178;
	Thu, 17 Apr 2025 18:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913619; cv=none; b=hczKYMIjYlcVhfWKfzYXXiH99xdlpX8w9zdL3z9ozUsqNkMkGw4wJg2MgI0ImNKEWOGuKTF+4OyZ6auydktEH7MPx/V6+efd8CGm9CsvLWHUAidCPEp5jrDTWgmB10/Be3lzojlQ6BiL7uPk+rETWJYKERE0Zd28OLRYGyKa1PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913619; c=relaxed/simple;
	bh=kn7BfVQj7bjB5EirDoBsncibUTCWM37Uik/Ih5Eaaig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MHfGLUOywkuAoDbOBuYkcYZGWopoymrKI//MQzYuyPL2OoEiedK+fGaAIm5cROmaM7Y4H29Q7Henh0oQXHhHV/5raKkbp2nauopKsxq9DPPT0+oVSuPtZp0wd1Y5d5u8mpGOKq8AthnuoP4pkXq99ajlxgNZzOhdt9OSfA/Yp7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tzQCnNIX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tzQCnNIX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1922C4CEE4;
	Thu, 17 Apr 2025 18:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913619;
	bh=kn7BfVQj7bjB5EirDoBsncibUTCWM37Uik/Ih5Eaaig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tzQCnNIXNKmCLSpNDHEHqvBakMcbfGj8wwfn0tAqb+FEqmbbMhgF89d2oI9KDSukH
	 K3zruwsXXvhyEhaTiUAhb7u4+i2Nh4Zg4O/odYjhLl//xR63+bRasS7eJLXGu4Ir4c
	 4QiksH4JopTI3IbsYSV94LWW0pgQuAJjb0OY8wSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.14 390/449] dm-verity: fix prefetch-vs-suspend race
Date: Thu, 17 Apr 2025 19:51:18 +0200
Message-ID: <20250417175133.964932920@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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


