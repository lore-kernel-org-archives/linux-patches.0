Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC454248CA;
	Thu, 16 Jul 2026 13:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210013; cv=none; b=pAePWo9jBy0koMcgEBcLSxmyL7DDe06Yu4JboMEkTAEiISoC5GJJTBAm0kiG2gwy9VnYHULN9LwMceOC46hgjxeKOjwHiUmxYKiLe6FDGMeqQjsNN+7/KliK6eDHi0X0/fQgGCjgr0LEPYOSWanIAKyixsjfqJWTDMCkv7vWetQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210013; c=relaxed/simple;
	bh=rQ/kRl2M3eIb9/aZNBMVulfgUPikcZ4FZLc35NrW1y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XdZ+WeucAiDC/y9TjBo26shv7mUAfdijGwfR5shgS8RtponGiafexnlbyiQYn+1htaA5BWpQmgwOXc4hEdnP6lWlkyoRNiMGe25l82iB5ijq/C1kGDitKGiFSsmefB3fOftM7+lEXH0EvXhXd9Iqp3KQ0dtQPOQOc8Oqpo6qJUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n369d0No; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n369d0No"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F61E1F000E9;
	Thu, 16 Jul 2026 13:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210012;
	bh=BIZPAIkaGCszNe6LFzgkLRmkvcx+iAg+qQVlSKzgZcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n369d0No97fco39iBeklfO0w40t0jVAPrKs4BhVJvUovRulVHKo5iFFQ83DoXmgtM
	 C3f3UnI4S0QctDKq/fzed+zX8C/0XIWIEHMyorwumw0KmiwPY46rREqoogytxF0tn0
	 AIqmrBGVeFB9U7S4bYwU9DFJOmqYJzZky+9vxhE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 7.1 350/518] dm-ioctl: report an error if a device has no table
Date: Thu, 16 Jul 2026 15:30:18 +0200
Message-ID: <20260716133055.481450006@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 457e32348d606a77f9b20e25e989734189834c07 upstream.

When we send a message to a device that has no table, the return code was
not set. The code would return "2", which is not considered a valid return value.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-ioctl.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1816,8 +1816,11 @@ static int target_message(struct file *f
 		goto out_argv;
 
 	table = dm_get_live_table(md, &srcu_idx);
-	if (!table)
+	if (!table) {
+		DMERR("The device has no table.");
+		r = -EINVAL;
 		goto out_table;
+	}
 
 	if (dm_deleting_md(md)) {
 		r = -ENXIO;


