Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72101231829;
	Tue, 21 Jul 2026 22:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673342; cv=none; b=AJKEkVWDK39zVfix5RupbHVs9H4Xx1v/7YqHtszVn48k9BUygYDXwwnLOBFg3G3VHYmJUkB6TiIpXbsMRvHozAWv6cbxNvdXn8gNuenV0g+oSsp1p6+fW4NRBu4u2gVPjH2i+wImetbfKv26Uv32J0dJTrEzBwlHEPdE5oxLvJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673342; c=relaxed/simple;
	bh=rP8H4F0rrq8OGZmGlwLSWug1Xke/UdiCSHPtXKO/ERQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ciQprp6PL/Ojqf1imfSt8PqQQqIiSYAix91cEn2P2B07D9C+5GHQGjLmkdRzhWwvMRJMsnG4MJ4pzmAAddxJKA3usfT8BFzVI0t5Y7Pdf6gYR+/qk1rilCFW+pmGT38m87qvLT6DwrZcRL7s6e8lHFQKDEdq1ziWP+w7EfNtJp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CE2H76BE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CE2H76BE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D80361F000E9;
	Tue, 21 Jul 2026 22:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673341;
	bh=6qFBu2WqmySnYCXxhoTcss0OIaT2L/ubNSISuseji+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CE2H76BECoVUOyERkDiAWvW0/Zpmmla4Qe+JuAn56HlKpUYMP8iNRnA25MPljqTSW
	 zs3MZyirVWxFgEvXtDj0/cIvSI4RFCgq4cAk61uNyNUqp60rX4ER3+yZlMP9sv8hby
	 W0Ev8u4JytHssgGaAU9XSGuy1NPvtUSCcAzmmk8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 5.10 124/699] dm-ioctl: report an error if a device has no table
Date: Tue, 21 Jul 2026 17:18:03 +0200
Message-ID: <20260721152358.501991226@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1633,8 +1633,11 @@ static int target_message(struct file *f
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


