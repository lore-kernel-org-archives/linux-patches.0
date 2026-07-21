Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 659F63B6C17;
	Tue, 21 Jul 2026 22:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671211; cv=none; b=sEfTEylNlr0lSphA9XSruzIqUcUOJ+jDFffTwEWWBmhPIcQBlyPK2Bs1wOqb8/BSW/70OsQzXWvK0j0Z5+HFxJ2cxHyTemvo1pCL2O/OhYUS0LihWsOGS5f4oOmhcpasL/+7SE+gzKCakiKJAfyjGPmA202xBZi6gOjYIjqzgnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671211; c=relaxed/simple;
	bh=2YndVc0Ir/9ekPC89bevLCwRQ4getKUiKAC3AP/kfFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MNM+22ryYJjvHtGWsoU+RXc2ROQK9zjI8or3YDvr5aWw3N7EEfaiLeL9AUZ1mMGF1X2RoSGRDCeTHXDTTCKATBLnFpJQT5AkBRZTLIQLGXzNvmUUWQ4UrHe3i6cd6W4J1EK2cuSg9/SnY6sGGCh8tLZuiJ3M1kQWYi/aIHJtRus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZqWrBHDl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZqWrBHDl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBD8C1F000E9;
	Tue, 21 Jul 2026 22:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671210;
	bh=mQGeMm6rATkofjOPIJgi7ZqIm7jW8hkcWFUvDRyb2EU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZqWrBHDlv1fU36YKcRM2cjuWVtdghM3htdKxSCdjbjYllQBzSJm/dgt+06ORUI9Fz
	 lUvco9UkiA9E89Fh8v5yALqWziBVE2kNIqWz7Q07lSDKO/DEn1J9L3JqpTSXVYs0dV
	 EXi/EWFlPtQl5A8eFeUTUi0i1DJbdcqOrfQOZxhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 5.15 159/843] dm-ioctl: report an error if a device has no table
Date: Tue, 21 Jul 2026 17:16:34 +0200
Message-ID: <20260721152409.593013266@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1732,8 +1732,11 @@ static int target_message(struct file *f
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


